library globals;

import 'dart:async';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hythr/content/user.dart';
import 'package:firebase_database/firebase_database.dart';


final userSignIn = new UserSignIn();

class UserSignIn {
  final googleSignIn = new GoogleSignIn();
  final auth = FirebaseAuth.instance;
  User currentUser;

  StreamController<User> _currentUserController = new StreamController<User>.broadcast();

  Stream<User> get onCurrentUserChanged => _currentUserController.stream;

  User setCurrentUser(User user) {
    if (user != currentUser) {
      currentUser = user;
      _currentUserController.add(currentUser);
    }
    return currentUser;
  }

  signOut() {
    googleSignIn.signOut();
  }

  Future<Null> signIn() async {
    GoogleSignInAccount user = googleSignIn.currentUser;

    if (user == null) {
      user = await googleSignIn.signInSilently();
    }

    if (user == null) {
      await googleSignIn.signIn();
    }

    // log into firebase
    if (await auth.currentUser() == null) {
      GoogleSignInAuthentication credentials = await googleSignIn.currentUser.authentication;
      await auth.signInWithGoogle(
        idToken: credentials.idToken,
        accessToken: credentials.accessToken,
      );
    }

    // get the user record, or create it.
    var userDoc = FirebaseDatabase.instance.reference().child('users/' + googleSignIn.currentUser.id);
    var userSnapshot = await userDoc.once();
    User u;
    if ( userSnapshot.value != null ) {
      u = new User.fromFirebaseSnapshot(userSnapshot);
    }
    if (userSnapshot.value == null ) {
      u = new User.fromGoogleUser(user);
      await userDoc.update(u.toFirebaseUpdate());
    }

    // should be logged in by now.
    setCurrentUser(u);
  }

  createNewUser(String email ) async {
    var userDoc = FirebaseDatabase.instance.reference().child('users').push();
    var u = new User(email);
    await userDoc.update(u.toFirebaseUpdate());
  }
}
