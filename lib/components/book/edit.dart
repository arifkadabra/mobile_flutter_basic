import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../home.dart';

class EditForm extends StatefulWidget {
  final int id;
  final String title;
  final String author;
  EditForm({required this.id, required this.title, required this.author});

  @override
  State<EditForm> createState() => _EditFormState();
}

class _EditFormState extends State<EditForm> {
  late final TextEditingController titleController = TextEditingController(text: widget.title);
  late final TextEditingController authorController = TextEditingController(text: widget.author);

  @override
  void dispose() {
    titleController.dispose();
    authorController.dispose();
    super.dispose();
  }

  Future<void> submit(String title, String author) async {
    final String? token =
        "19|nBsduzbuER3V2T1ApBns6kwYRfjTtlpdMgBL6dx655930114"; //prefs.getString('token');
    final apiUrl = 'http://127.0.0.1:8000/api/book/${this.widget.id}';
    final headers = {
      'Authorization': 'Bearer ${token}',
      'Content-Type': 'application/json'
    };
    
    final response = await http.put(Uri.parse(apiUrl),
        headers: headers,
        body: json.encode(<String, String>{
          'title': title,
          'author': author,
        }));
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
        title: Text('Edit Form'),
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
