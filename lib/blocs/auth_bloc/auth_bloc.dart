import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(const AuthState()) {
    /// Jalankan Monitor Auth State saat AuthBloc di inisialisasi
    monitorAuthState();

    /// Register Event
    on<AuthRegister>((event, emit) async {
      /// Emit Loading State
      emit(const AuthState(isLoading: true));

      /// Lakukan Register dengan Email dan Password
      try {
        final res = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );

        /// Emit User Data yang telah ter-register.
        emit(AuthState(userData: res.user));
      } catch (e) {
        /// Emit error jika terjadi
        emit(AuthState(errorMessage: e.toString()));
      }
    });

    /// Login Event
    on<AuthLogin>((event, emit) async {
      /// Emit Loading State
      emit(const AuthState(isLoading: true));

      /// Lakukan Sign In dengan Email dan Password
      try {
        final res = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );

        /// Emit User Data yang telah login.
        emit(AuthState(userData: res.user));
      } catch (e) {
        /// Emit error jika terjadi
        emit(AuthState(errorMessage: e.toString()));
      }
    });

    /// Auth Updated Untuk Auth Changes
    on<AuthUpdated>((event, emit) {
      emit(AuthState(userData: event.userData));
    });
  }

  void monitorAuthState() {
    /// Setiap kali ada perubahan pada Auth user dari Firebase.
    /// Kita update user kita.
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        add(AuthUpdated(userData: user));
      }
    });
  }
}
