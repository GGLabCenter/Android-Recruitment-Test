import 'package:flutter/material.dart';
import 'package:flutter_application_sample/data_provider.dart';
import 'package:flutter_application_sample/models/comment.dart';
import 'package:flutter_application_sample/models/post.dart';
import 'package:flutter_application_sample/ui/details.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});

  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late DataProvider _dataProvider;

  @override
  void initState() {
    super.initState();
    _dataProvider = DataProvider();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: (() {}), //TODO new post from here addPost(),
          tooltip: 'Add a new post',
          child: const Icon(Icons.add),
        ),
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: SafeArea(
          child: FutureBuilder(
            future: _dataProvider.getPosts(),
            builder:
                (BuildContext context, AsyncSnapshot<List<Post>?> snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                      "Something went wrong, error message: ${snapshot.error.toString()}"),
                );
              } else if (snapshot.connectionState == ConnectionState.done) {
                List<Post>? posts = snapshot.data;
                print(posts!.length);
                return _buildListView(posts);
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ));
  }

  /*
  DetailsScreen is used to add a new post or open in view mode an existing post.
  */
  void goToDetailsScreen(Post post) {
    setState(() {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => DetailsScreen(post: post)));
    });
  }

  void _showModalSheet(List<Comment>? comments) {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Container(
              height: 200.0,
              color: Colors.green,
              child: Center(
                  child: ListView.builder(
                      itemCount: comments!.length,
                      itemBuilder: (context, index) {
                        Comment comment = comments[index];
                        return Text(comment.body);
                      })));
        });
  }

  _buildListView(List<Post>? items) {
    return ListView.builder(
        itemCount: items!.length,
        itemBuilder: (context, index) {
          Post post = items[index];
          return Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: InkWell(
              onTap: (() => print('test ')), //_showModalSheet,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        post.title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(post.body),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          TextButton(
                              onPressed: () {
                                // TODO
                              },
                              child: const Text(
                                "Delete",
                                style: TextStyle(color: Colors.red),
                              )),
                          TextButton(
                              onPressed: (() => goToDetailsScreen(post)),
                              child: const Text(
                                "Edit",
                                style: TextStyle(color: Colors.blue),
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0));
  }
}
