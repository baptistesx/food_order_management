import 'dart:convert';

class Suggestion {
  final String userName;
  final String email;
  final String body;

  Suggestion({
    required this.userName,
    required this.email,
    required this.body,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userName': userName,
      'email': email,
      'body': body,
    };
  }

  factory Suggestion.fromMap(Map<String, dynamic> map) {
    return Suggestion(
      userName: map['userName'] ?? '',
      email: map['email'] ?? '',
      body: map['body'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Suggestion.fromJson(String source) =>
      Suggestion.fromMap(json.decode(source));
}
