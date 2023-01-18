import 'package:flutter/material.dart';
import 'package:flutter_application_sample/data_provider.dart';
import 'package:flutter_application_sample/models/comment.dart';
import 'package:flutter_application_sample/models/post.dart';
import 'package:flutter_application_sample/open_container.dart';
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
          onPressed: (() {
            goToDetailsScreen(null);
          }),
          tooltip: 'Add a new post',
          child: OpenContainer(
            transitionType: ContainerTransitionType.fadeThrough,
            closedColor: Colors.blue,
            openColor: Colors.white,
            middleColor: Colors.blue,
            closedElevation: 0.0,
            openElevation: 4.0,
            transitionDuration: const Duration(milliseconds: 1000),
            openBuilder: (BuildContext context, VoidCallback _) =>
                const DetailsScreen(post: null),
            closedBuilder: (BuildContext _, VoidCallback openContainer) {
              return const Icon(Icons.add);
            },
          ),
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
  void goToDetailsScreen(Post? post) {
    setState(() {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => DetailsScreen(post: post)));
    });
  }

  void _showModalSheet(int postId) {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Container(
            height: 400.0,
            color: Colors.blueGrey,
            child: FutureBuilder(
              future: _dataProvider.getComments(postId),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Comment>?> snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                        "Something went wrong, error message: ${snapshot.error.toString()}"),
                  );
                } else if (snapshot.connectionState == ConnectionState.done) {
                  List<Comment>? comments = snapshot.data;
                  return ListView.builder(
                      itemCount: comments!.length,
                      itemBuilder: (context, index) {
                        Comment comment = comments[index];
                        return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Card(
                                child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(comment.body))));
                      });
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          );
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
              onTap: (() => _showModalSheet(post.id)),
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
                                showAlertDialog(
                                    context, _dataProvider, post.id);
                              },
                              child: const Text(
                                "Delete",
                                style: TextStyle(color: Colors.red),
                              )),
                          TextButton(
                              onPressed: (() => goToDetailsScreen(post)),
                              child: OpenContainer(
                                transitionType:
                                    ContainerTransitionType.fadeThrough,
                                //closedColor:  Colors.blue, //.of(context).cardColor,
                                openColor: Colors.white,
                                //middleColor: Colors.white,
                                closedElevation: 0.0,
                                openElevation: 4.0,
                                transitionDuration:
                                    const Duration(milliseconds: 1000),
                                openBuilder:
                                    (BuildContext context, VoidCallback _) =>
                                        DetailsScreen(post: post),
                                closedBuilder: (BuildContext _,
                                    VoidCallback openContainer) {
                                  return const Text(
                                    "Edit",
                                    style: TextStyle(color: Colors.blue),
                                  );
                                },
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

  showAlertDialog(BuildContext context, DataProvider dataProvider, int postId) {
    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop(); //
      },
    );
    Widget continueButton = TextButton(
      child: const Text("Confirm"),
      onPressed: () {
        dataProvider.deletePost(postId);
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text("Delete Post with id: $postId"),
      content: const Text("Are you sure?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
