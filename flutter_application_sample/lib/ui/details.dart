import 'package:flutter/material.dart';
import 'package:flutter_application_sample/data_provider.dart';
import 'package:flutter_application_sample/models/post.dart';

final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

class DetailsScreen extends StatefulWidget {
  final Post? post;
  const DetailsScreen({super.key, required this.post});
  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  bool _isLoading = false;
  final DataProvider _dataProvider = DataProvider();
  bool _isFieldBodyValid = true;
  bool _isFieldTitleValid = true;
  final TextEditingController _controllerTitle = TextEditingController();
  final TextEditingController _controllerBody = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (widget.post == null) {
      // create new post
      return Scaffold(
          key: _scaffoldState,
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: const Text("New Post"),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        _buildTextFieldTitle(null),
                        _buildTextFieldBody(null),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() => _isLoading = true);
                              String body = _controllerBody.text.toString();
                              String title = _controllerTitle.text.toString();
                              Post post = Post(
                                  userId: 999,
                                  body: body,
                                  title: title); // faked userId
                              _dataProvider.createPost(post).then((isSuccess) {
                                setState(() => _isLoading = false);
                                if (isSuccess != null) {
                                  Navigator.pop(
                                      _scaffoldState.currentState!.context,
                                      isSuccess);
                                } else {
                                  // To be handled properly.
                                  print('an error occurred');
                                  // return Text("Submit new post failed");
                                }
                                return Container();
                              });
                            },
                            child: Text(
                              "Submit".toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  _isLoading
                      ? Stack(
                          children: const <Widget>[
                            Opacity(
                              opacity: 0.3,
                              child: ModalBarrier(
                                dismissible: false,
                                color: Colors.grey,
                              ),
                            ),
                            Center(
                              child: CircularProgressIndicator(),
                            ),
                          ],
                        )
                      : Container(),
                ],
              ),
            ),
          ));
    } else {
      // modify existing post
      return Scaffold(
          key: _scaffoldState,
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: const Text("Edit Post"),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        _buildTextFieldTitle(widget.post),
                        _buildTextFieldBody(widget.post),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() => _isLoading = true);
                              String body = _controllerBody.text.toString();
                              String title = _controllerTitle.text.toString();
                              widget.post!.body = body;
                              widget.post!.title = title;
                              _dataProvider
                                  .updatePost(widget.post!)
                                  .then((isSuccess) {
                                setState(() => _isLoading = false);
                                if (isSuccess != null) {
                                  Navigator.pop(
                                      _scaffoldState.currentState!.context,
                                      isSuccess);
                                } else {
                                  // To be handled properly.
                                  print('an error occurred');
                                  // return Text("Submit new post failed");
                                }
                                return Container();
                              });
                            },
                            child: Text(
                              "Submit".toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  _isLoading
                      ? Stack(
                          children: const <Widget>[
                            Opacity(
                              opacity: 0.3,
                              child: ModalBarrier(
                                dismissible: false,
                                color: Colors.grey,
                              ),
                            ),
                            Center(
                              child: CircularProgressIndicator(),
                            ),
                          ],
                        )
                      : Container(),
                ],
              ),
            ),
          ));
    }
  }

  Widget _buildTextFieldBody(Post? post) {
    if (post != null) {
      _controllerBody.text = post.body;
      _controllerBody.selection =
          TextSelection.collapsed(offset: _controllerBody.text.length);
    }
    return TextField(
      controller: _controllerBody,
      maxLines: null,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: "Body",
        errorText: _isFieldBodyValid == null || _isFieldBodyValid
            ? null
            : "Body is required",
      ),
      onChanged: (value) {
        bool isFieldValid = value.trim().isNotEmpty;
        if (isFieldValid != _isFieldBodyValid) {
          setState(() => _isFieldBodyValid = isFieldValid);
        }
      },
    );
  }

  Widget _buildTextFieldTitle(Post? post) {
    if (post != null) {
      _controllerTitle.text = post.title;
      _controllerTitle.selection =
          TextSelection.collapsed(offset: _controllerTitle.text.length);
    }
    return TextField(
      controller: _controllerTitle,
      maxLines: null,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: "Title",
        errorText: _isFieldTitleValid == null || _isFieldTitleValid
            ? null
            : "Title is required",
      ),
      onChanged: (value) {
        bool isFieldValid = value.trim().isNotEmpty;
        if (isFieldValid != _isFieldTitleValid) {
          setState(() => _isFieldTitleValid = isFieldValid);
        }
      },
    );
  }
}
