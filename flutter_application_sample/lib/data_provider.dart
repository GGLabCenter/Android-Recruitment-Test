import 'package:flutter_application_sample/models/post.dart';
import 'package:flutter_application_sample/models/comment.dart';
import 'package:flutter_application_sample/utils.dart';
import 'package:http/http.dart' show Client;

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

  Future<String> deletePost(int postId) async {
    final response =
        await client.delete(Uri.parse(endpointPosts + postId.toString()));
    if (response.statusCode == 200) {
      return 'ok';
    } else {
      return 'ko';
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
