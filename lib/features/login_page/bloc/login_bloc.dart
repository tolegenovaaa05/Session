import 'package:cyber_news/features/login_page/bloc/login_event.dart';
import 'package:cyber_news/features/login_page/bloc/login_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _firebaseAuth;

  AuthBloc({required FirebaseAuth firebaseAuth})
      : _firebaseAuth = firebaseAuth,
        super(InitialAuthState()) {
    on<LoginButtonPressed>((event, emit) async {
      emit(LoadingState());
      try {
        final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
          email: event.username,
          password: event.password,
        );

        if (userCredential.user != null) {
          emit(AuthenticatedState());
        } else {
          emit(FailureState(error: "Failed to authenticate"));
        }
      } catch (error) {
        emit(FailureState(error: error.toString()));
      }
    });
  }
}
