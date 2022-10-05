import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pom/main.dart';
import 'package:pom/models/exceptions.dart';

class AuthRepository {
  FirebaseFirestore db = FirebaseFirestore.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  AuthRepository();

  Future<User> signInWithGoogle() async {
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount == null) {
      throw StandardException('Erreur lors de la connexion.');
    }

    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential userCredential =
        await firebaseAuth.signInWithCredential(credential);

    if (userCredential.user == null) {
      throw StandardException('Erreur lors de la connexion.');
    }

    return userCredential.user!;
  }

  Future<void> signOut() async {
    await googleSignIn.signOut();
    await firebaseAuth.signOut(); // TODO: check if both are necessary
  }
}
