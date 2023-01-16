import 'package:flutter_application_sample/models/post.dart';
import 'package:flutter_application_sample/models/comment.dart';
import 'package:flutter_application_sample/utils.dart';
import 'package:http/http.dart' show Client;

class DataProvider {
  Client client = Client();

  String endpointPosts = Utils.baseUrl + Utils.urlPosts;
  String endpointComments = Utils.baseUrl + Utils.urlPosts + Utils.urlComments;

  Future<List<Post>?> getPosts() async {
    final response = await client.get(Uri.parse(endpointPosts));
    if (response.statusCode == 200) {
      // print(endpointPosts);
      return postFromJson(response.body);
    } else {
      return null;
    }
  }

  Future<List<Comment>?> getComments() async {
    final response = await client.get(Uri.parse(endpointComments));
    if (response.statusCode == 200) {
      print(endpointComments);
      return commentFromJson(response.body);
    } else {
      return null;
    }
  }
}
