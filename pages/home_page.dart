import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nepal_sport/pages/add_post.dart';

import 'login_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firestore Post App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PostListScreen(),
    );
  }
}
class SportArticle {
  final String title;
  final String author;
  final String content;

  SportArticle({
    required this.title,
    required this.author,
    required this.content,
  });
}

class PostListScreen extends StatelessWidget {
 void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
  }
@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sport Articles'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: Text('No articles available.'),
            );
          }

          List<SportArticle> articles = snapshot.data!.docs.map((doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            return SportArticle(
              title: data['title'] ?? '',   // Use empty string if title is null
              author: data['author'] ?? '', // Use empty string if author is null
              content: data['content'] ?? '', // Use empty string if content is null
            );
          }).toList();

          return ListView.builder(
            itemCount: articles.length,
            itemBuilder: (context, index) {
          
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ArticleDetailPage(article: articles[index]),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        articles[index].title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'By ${articles[index].author}',
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        articles[index].content,
                        style: const TextStyle(
                          fontSize: 16,
                      ),
                      ),
                    ],
                  ),
                ),
              );
            },
            
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
                 Navigator.push(context, MaterialPageRoute(builder: (context)=>PostPage()));
        },
        child: const Icon(Icons.add),

          ),
      
    );

  }
}

class ArticleDetailPage extends StatelessWidget {
  final SportArticle article;

  ArticleDetailPage({required this.article});

  @override
  Widget build(BuildContext context) {
    var posts = FirebaseFirestore.instance.collection('posts');
  return Scaffold(
      appBar: AppBar(
        title: const Text('Article Detail'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                article.title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'By ${article.author}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 16),
              Image.network(
                'https://source.unsplash.com/random/800x400/?football',
                width: 400,
                height: 200,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 16),
              const Text(
                'Description:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
             FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance.collection("posts").doc(posts.id).get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return const Text('Description not available.');
                  }
                  var description = snapshot.data!['description'] ?? '';
                  return Text(
                    description,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
