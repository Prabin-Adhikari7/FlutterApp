import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PostPage extends StatefulWidget {
  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _postController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Author Name'),
            ),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _postController,
              maxLines: 8,
              decoration: const InputDecoration(labelText: 'Post Description'),
            ),
            ElevatedButton(
              onPressed: () {
                _addPostToFirestore();
              },
              child: Text('Add Post'),
            ),
          ],
        ),
      ),
    );
  }

  void _addPostToFirestore() async {
    try {
      // Get a reference to the Firestore collection
      CollectionReference postsCollection =
          FirebaseFirestore.instance.collection('posts');

      String author = _nameController.text;
      String title = _titleController.text;
      String postDesc = _postController.text;

      if (author.isNotEmpty &&
          title.isNotEmpty &&
          postDesc.isNotEmpty &&
          postDesc.length >= 500 &&
          postDesc.length <= 1500) {
        // Create a new document with auto-generated ID
        DocumentReference newPostRef = await postsCollection.add({
          'author': author,
          'title': title,
          'postDesc': postDesc,
          'likes': 0,
          'comments': 0,
        });

        if (newPostRef.id.isNotEmpty) {
          // Display a success message or navigate to a new screen
          print('Post added successfully');

          // Clear the text fields after successful post
          _nameController.clear();
          _titleController.clear();
          _postController.clear();
        } else {
          // Handle an error case
          print('Failed to add post');
        }
      } else {
        print('Please fill in all fields, and make sure post description is between 500 and 1500 characters.');
      }
    } catch (e) {
      print('Error adding post: $e');
    }
  }
}


