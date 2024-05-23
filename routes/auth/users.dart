import 'dart:io';
import 'package:authentication/repository/user/user_repository.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context) {
  return switch (context.request.method) {
    HttpMethod.post => _createUser(context),
    _ => Future.value(Response(statusCode: HttpStatus.methodNotAllowed)),
  };
}

Future<Response> _createUser(RequestContext context) async {
  try {
    final body = await context.request.json() as Map<String, dynamic>;

    final name = body['name'] as String?;
    final userName = body['userName'] as String?;
    final password = body['password'] as String?;

    if (name == null || userName == null || password == null) {
      return Response(statusCode: HttpStatus.badRequest, body: 'Missing required fields');
    }

    final userRepository = context.read<UserRepository>();
    final id = await userRepository.createUser(
      name: name,
      userName: userName,
      password: password,
    );

    return Response.json(body: {"id": id});
  } catch (e) {
    return Response(statusCode: HttpStatus.internalServerError, body: 'Internal Server Error');
  }
}
