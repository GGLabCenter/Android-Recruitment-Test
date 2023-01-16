import 'dart:convert';

class Post {
  int id;
  int userId;
  String title;
  String body;

  Post(
      {this.id = 0,
      required this.userId,
      required this.title,
      required this.body});

  factory Post.fromJson(Map<String, dynamic> map) {
    return Post(
        id: map["id"],
        userId: map["userId"],
        title: map["title"],
        body: map["body"]);
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "userId": userId, "title": title, "body": body};
  }

  @override
  String toString() {
    return 'Post{id: $id, userId: $userId, title: $title, body: $body}';
  }
}

List<Post> postFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<Post>.from(data.map((item) => Post.fromJson(item)));
}

String postToJson(Post data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
