import 'package:authentication/repository/user/user_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_auth/dart_frog_auth.dart';

Handler middleware(Handler handler) {
  return handler
      .use(provider<UserRepository>((context) => UserRepository()))
      .use(basicAuthentication<User>(
        authenticator: (context, userName, password) async {
          final repository = context.read<UserRepository>();
          return await repository.userFromCredentials(userName, password);
        },
        applies: (RequestContext context) async =>
            context.request.method != HttpMethod.post,
      ));
}
