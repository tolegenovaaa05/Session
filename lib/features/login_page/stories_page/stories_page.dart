import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Stories extends StatelessWidget {
  final String imageUrl;

  const Stories({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.network(imageUrl),
      ),
    );
  }
}

class StoriesPage extends StatelessWidget {
  const StoriesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Center(
          child: Text(
            'Истории',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('stories').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No Stories Available'),
            );
          }

          final stories = snapshot.data!.docs;

          return ListView.builder(
            itemCount: stories.length,
            itemBuilder: (BuildContext context, int index) {
              // Получаем данные из Firebase
              final story = stories[index];
              final name = story['name'];
              final profileImage = story['image_url'];
              final storiesImage = story['stories_url'];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Stories(imageUrl: storiesImage),
                    ),
                  );

                  Future.delayed(Duration(seconds: 3), () {
                    Navigator.pop(context);
                  });
                },
                child: Card(
                  elevation: 3,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(profileImage),
                    ),
                    title: Text(
                      name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('Tap to view story'),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
