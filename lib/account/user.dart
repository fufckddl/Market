import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class User {
  final String id;
  final String password;
  final String age;
  final String name;

  User({
    required this.id,
    required this.password,
    required this.age,
    required this.name,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      password: json['password'],
      age: json['age'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'password': password,
      'age': age,
      'name': name,
    };
  }

  Future<void> saveUserInfo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final userInfoJson = json.encode(toJson());
    await prefs.setString('user_info', userInfoJson);
    print('User info saved to SharedPreferences');
  }
}
