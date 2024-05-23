import 'dart:async';
import 'package:equatable/equatable.dart';

Map<String, User> userDb = {};

class User extends Equatable {
  User({
    required this.id,
    required this.name,
    required this.userName,
    required this.password,
  });

  final String id;
  final String name;
  final String userName;
  final String password;

  @override
  List<Object?> get props => [id, name, userName, password];
}

class UserRepository {
  Future<User?> userFromCredentials(String userName, String password) async {
    final hashedPassword = password.hashCode.toString();
    final users = userDb.values.where(
        (user) => user.userName == userName && user.password == hashedPassword);
    if (users.isNotEmpty) {
      return users.first;
    }
    return null;
  }

  User? userFromId(String id) {
    return userDb[id];
  }

  Future<String> createUser({
    required String name,
    required String userName,
    required String password,
  }) async {
    final id = userName.hashCode.toString();
    final user = User(
      id: id,
      name: name,
      userName: userName,
      password: password.hashCode.toString(),
    );

    userDb[id] = user;

    return Future.value(id);
  }

  Future<void> deleteUser(String id) async {
    userDb.remove(id);
  }

  Future<void> updateUser({
    required String id,
    String? name,
    String? userName,
    String? password,
  }) async {
    final currentUser = userDb[id];

    if (currentUser == null) {
      return Future.error(Exception("User not found"));
    }
    final user = User(
      id: id,
      name: name ?? currentUser.name,
      userName: userName ?? currentUser.userName,
      password: password ?? currentUser.password,
    );

    userDb[id] = user;
    return Future.value();
  }
}
