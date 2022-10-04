import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pom/main.dart';

class AuthRepository {
  FirebaseFirestore db = FirebaseFirestore.instance;

  AuthRepository();

  Future<UserCredential> signInWithGoogle() async {
    // GoogleSignIn _googleSignIn = GoogleSignIn(
    //   // Optional clientId
    //   // clientId: '479882132969-9i9aqik3jfjd7qhci1nqf0bm2g71rm1u.apps.googleusercontent.com',
    //   scopes: <String>[
    //     'email',
    //   ],
    // );
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await firebaseAuth.signInWithCredential(credential);
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }
}
