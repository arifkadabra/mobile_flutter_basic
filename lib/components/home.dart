import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile/components/book/add.dart';
import 'package:mobile/models/book.dart';
import 'package:mobile/components/book/edit.dart';
import 'package:mobile/services/api.dart';
import 'package:mobile/services/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Future<void> handleLogout() async {
    await Auth().logout();
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.remove('token');
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (route) => false,
    );
  }

  static Future<List<Book>> getBook() async {
    final response = await Api().list();
    final List body = json.decode(response.body);
    return body.map((e) => Book.fromJson(e)).toList();
  }

  Future<void> _destroy(int id) async {
    await Api().destroy(id);
    setState(() {
      getBook();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            onPressed: () => handleLogout(),
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Text('+'),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddForm()),
          );
        },
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FutureBuilder<List<Book>>(
              future: getBook(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasData) {
                  final book = snapshot.data!;
                  return buildList(book);
                } else {
                  return const Text("No data available");
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildList(List<Book> book) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: book.length,
      itemBuilder: (context, index) {
        final listData = book[index];
        return ListTile(
          title: Text(listData.title!),
          subtitle: Text(listData.author!),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditForm(
                          id: listData.id!,
                          title: listData.title!,
                          author: listData.author!),
                    )),
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => _destroy(listData.id!),
              ),
            ],
          ),
        );
      },
    );
  }
}
