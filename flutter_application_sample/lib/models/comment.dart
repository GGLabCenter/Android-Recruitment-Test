import 'dart:convert';

class Comment {
  int id;
  int postId;
  String name;
  String email;
  String body;

  Comment(
      {this.id = 0,
      required this.postId,
      required this.name,
      required this.email,
      required this.body});

  factory Comment.fromJson(Map<String, dynamic> map) {
    return Comment(
        id: map["id"],
        postId: map["postId"],
        name: map["name"],
        email: map["email"],
        body: map["body"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "postId": postId,
      "name": name,
      "email": email,
      "body": body
    };
  }

  @override
  String toString() {
    return 'Comment{id: $id, postId: $postId, name: $name, email: $email, body: $body}';
  }
}

List<Comment> commentFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<Comment>.from(data.map((item) => Comment.fromJson(item)));
}

String commentToJson(Comment data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
