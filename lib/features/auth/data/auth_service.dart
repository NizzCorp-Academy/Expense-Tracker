// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';

// class AuthService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final GoogleSignIn _googleSignIn = GoogleSignIn();

//   // Sign Up with Email & Password
//   Future<User?> signUpWithEmail(String email, String password) async {
//     try {
//       UserCredential result = await _auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       return result.user;
//     } on FirebaseAuthException catch (e) {
//       throw e.message ?? "An unknown error occurred";
//     }
//   }

//   // Login with Email & Password
//   Future<User?> loginWithEmail(String email, String password) async {
//     try {
//       UserCredential result = await _auth.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       return result.user;
//     } on FirebaseAuthException catch (e) {
//       throw e.message ?? "An unknown error occurred";
//     }
//   }


//   Future<User?> signInWithGoogle() async {
//     try {
//       final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
//       if (googleUser == null) return null;

//       final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

//       final credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );

//       final UserCredential userCredential = await _auth.signInWithCredential(credential);
//       return userCredential.user;
//     } catch (e) {
//       print('Google Sign-In Error: $e');
//       return null;
//     }
//   }


//   // Logout
//   Future<void> signOut() async {
//     await _auth.signOut();
//     await _googleSignIn.signOut();
//   }

//   // Get current user
//   User? get currentUser => _auth.currentUser;

//   // Listen to auth changes
//   Stream<User?> get authStateChanges => _auth.authStateChanges();
// }
