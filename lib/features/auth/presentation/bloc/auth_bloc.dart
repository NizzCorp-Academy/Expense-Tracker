import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_trackerl_ite/features/auth/presentation/bloc/auth_event.dart';
import 'package:expense_trackerl_ite/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  AuthBloc() : super(AuthInitial()) {

    on<SignInEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );
        emit(Authenticated(userCredential.user!));
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });

    on<SignOutEvent>((event, emit) async {
  await _firebaseAuth.signOut();
  await _googleSignIn.signOut(); 
  emit(Unauthenticated());
});


    on<CheckAuthStatusEvent>((event, emit) {
      User? user = _firebaseAuth.currentUser;
      if (user != null) {
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }
    });
    
on<GoogleSignInEvent>((event, emit) async { // Handling Google Sign-In
      emit(AuthLoading());
      try {
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
        if (googleUser == null) {
          emit(AuthFailure("Google sign-in was canceled"));
          return;
        }

        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
        emit(Authenticated(userCredential.user!));
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });

    on<SignUpEvent>((event, emit) async {
  emit(AuthLoading());
  try {
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: event.email,
      password: event.password,
    );

    // Update display name
    await userCredential.user!.updateDisplayName(event.name);
    await userCredential.user!.reload();

    // Optional: Save user data to Firestore
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userCredential.user!.uid)
        .set({
          'name': event.name,
          'email': event.email,
          'createdAt': Timestamp.now(),
        });

    emit(Authenticated(_firebaseAuth.currentUser!));
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      emit(AuthFailure('The password provided is too weak.'));
    } else if (e.code == 'email-already-in-use') {
      emit(AuthFailure('The account already exists for that email.'));
    } else {
      emit(AuthFailure('An error occurred. Please try again.'));
    }
  } catch (e) {
    emit(AuthFailure('Unexpected error: ${e.toString()}'));
  }
});

  }

  
}