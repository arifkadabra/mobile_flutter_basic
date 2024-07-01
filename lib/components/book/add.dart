import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile/services/api.dart';

import '../home.dart';

class AddForm extends StatefulWidget {
  const AddForm({super.key});

  @override
  State<AddForm> createState() => AddFormState();
}

class AddFormState extends State<AddForm> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController authorController = TextEditingController();

  Future<void> submit(String title, String author) async {
    final params = json.encode(<String, String>{
          'title': title,
          'author': author,
        });
    final response = await Api().store(params);
    if (response.statusCode == 200) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
        (route) => false,
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Failed'),
            content: Text('Try Again'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              )
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Form'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextFormField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
              ),
            ),
            TextFormField(
              controller: authorController,
              decoration: const InputDecoration(
                labelText: 'Author',
              ),
            ),
            const SizedBox(height: 16.0),
            // ignore: deprecated_member_use
            ElevatedButton(
              child: const Text('Submit'),
              onPressed: () {
                submit(titleController.text, authorController.text);
              },
            ),
          ],
        ),
      ),
    );
  }
}
