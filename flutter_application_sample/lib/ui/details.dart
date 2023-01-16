import 'package:flutter/material.dart';
import 'package:flutter_application_sample/models/post.dart';

class DetailsScreen extends StatefulWidget {
  final Post post;
  const DetailsScreen({super.key, required this.post});
  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: editPost,
          tooltip: 'Edit post',
          child: const Icon(Icons.edit),
        ),
        appBar: AppBar(
          title: Text(widget.post.title),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(widget.post.userId.toString()),
                Text(widget.post.body),
              ],
            ),
          ),
        ));
  }

  void editPost() {
    // TODO
  }
}
