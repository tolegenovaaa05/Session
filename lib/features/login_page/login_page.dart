import 'package:cyber_news/features/login_page/bloc/login_bloc.dart';
import 'package:cyber_news/features/login_page/bloc/login_event.dart';
import 'package:cyber_news/features/login_page/bloc/login_state.dart';
import 'package:cyber_news/features/main_screen/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

    return BlocProvider(
      create: (context) => AuthBloc(firebaseAuth: _firebaseAuth),
      child: Scaffold(
        body: ListView(
          children: [
            LoginForm(),
          ],
        ),
      ),
    );
  }
}

class LoginForm extends StatelessWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _authBloc = BlocProvider.of<AuthBloc>(context);

    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthenticatedState) {
          // On successful authentication, navigate to a new page
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => MainScreen()),
          );
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is LoadingState) {
            return CircularProgressIndicator();
          } else if (state is FailureState) {
            // Display error message in case of failure
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.red,
                  content: Text('Error: ${state.error}'),
                  duration: Duration(seconds: 2),
                ),
              );
            });
            return buildLoginForm(emailController, passwordController, _authBloc);
          } else {
            // Display login form
            return buildLoginForm(emailController, passwordController, _authBloc);
          }
        },
      ),
    );
  }

  Widget buildLoginForm(TextEditingController emailController,
      TextEditingController passwordController, AuthBloc _authBloc) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            child: Image.asset('images/cyber.png'),
          ),
          TextFormField(
            controller: emailController,
            decoration: InputDecoration(
              labelText: 'Username',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20.0),
          TextFormField(
            controller: passwordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20.0),
          Container(
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:Colors.blue,
              ),
              onPressed: () {
                _authBloc.add(LoginButtonPressed(
                  username: emailController.text,
                  password: passwordController.text,
                ));
              },
              child: Text('Login'),
            ),
          ),
        ],
      ),
    );
  }
}
