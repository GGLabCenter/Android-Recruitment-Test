import 'package:flutter_application_sample/models/post.dart';
import 'package:flutter_application_sample/models/comment.dart';
import 'package:flutter_application_sample/utils.dart';
import 'package:http/http.dart' show Client;
import 'dart:convert';

class DataProvider {
  Client client = Client();

  String endpointPosts = Utils.baseUrl + Utils.urlPosts;

  Future<List<Post>?> getPosts() async {
    final response = await client.get(Uri.parse(endpointPosts));
    if (response.statusCode == 200) {
      return postFromJson(response.body);
    } else {
      return null;
    }
  }

  Future<Post?> deletePost(Post post) async {
    final response =
        await client.delete(Uri.parse(endpointPosts + post.id.toString()));
    if (response.statusCode == 200) {
      return post;
    } else {
      return null;
    }
  }

  Future<Post?> updatePost(Post post) async {
    var payload = {
      'title': post.title,
      'body': post.body,
      'id': post.id,
      'userId': post.userId
    };
    var headers = {
      'Content-type': 'application/json; charset=UTF-8',
    };
    final response = await client.post(Uri.parse(endpointPosts),
        headers: headers, body: json.encode(payload));
    if (response.statusCode == 201) {
      print(Post.fromJson(json.decode(response.body)).toString());
      return Post.fromJson(json.decode(response.body));
    } else {
      return null;
    }
  }

  Future<Post?> createPost(Post post) async {
    var payload = {
      'title': post.title,
      'body': post.body,
      'userId': '999' // faked userId
    };
    var headers = {
      'Content-type': 'application/json; charset=UTF-8',
    };
    final response = await client.post(Uri.parse(endpointPosts),
        headers: headers, body: json.encode(payload));
    if (response.statusCode == 201) {
      print(Post.fromJson(json.decode(response.body)).toString());
      return Post.fromJson(json.decode(response.body));
    } else {
      return null;
    }
  }

  Future<List<Comment>?> getComments(int postId) async {
    final response = await client
        .get(Uri.parse(endpointPosts + postId.toString() + Utils.urlComments));
    if (response.statusCode == 200) {
      return commentFromJson(response.body);
    } else {
      return null;
    }
  }
}
