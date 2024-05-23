import 'dart:io';
import 'package:authentication/repository/user/user_repository.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context) {
  return switch (context.request.method) {
    HttpMethod.post => _loginUser(context),
    _ => Future.value(Response(statusCode: HttpStatus.methodNotAllowed)),
  };
}

Future<Response> _loginUser(RequestContext context) async {
  try {
    final body = await context.request.json() as Map<String, dynamic>;

    final userName = body['userName'] as String?;
    final password = body['password'] as String?;

    if (userName == null || password == null) {
      return Response(statusCode: HttpStatus.badRequest, body: 'Missing required fields');
    }

    final userRepository = context.read<UserRepository>();
    final user = await userRepository.userFromCredentials(userName, password);

    if (user != null) {
      // Generate a simple token for demonstration purposes
      final token = user.id; // In real-world, use JWT or similar
      return Response.json(body: {"token": token});
    } else {
      return Response(statusCode: HttpStatus.unauthorized, body: 'Invalid credentials');
    }
  } catch (e) {
    return Response(statusCode: HttpStatus.internalServerError, body: 'Internal Server Error');
  }
}
