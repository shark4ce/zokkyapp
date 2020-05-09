import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:zokkyapp/models/user.dart';

enum LoginType {
  Google,
  Facebook,
  Email,
  EmailR
}
class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  static final FacebookLogin facebookLogin = FacebookLogin();
  static LoginType loginType = LoginType.Email;


  //create user object based on FirebaseUser

  User _userFromFirebaseUser(FirebaseUser user) {

    if(user == null) {
      return null;
    }else if((loginType == LoginType.Email || loginType == LoginType.EmailR) && !user.isEmailVerified){
      if (loginType == LoginType.EmailR)
        user.sendEmailVerification();
      _auth.signOut();
      return null;
    }else{
      return User(user.uid);
    }
  }

  //auth change user stream
  Stream<User> get user {
    return _auth.onAuthStateChanged
    .map(_userFromFirebaseUser);
  }

  //google sign in
  Future signInWithGoogle() async {
    try {
      loginType = LoginType.Google;
      GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );
      AuthResult result = await _auth.signInWithCredential(credential);
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    }catch(e) {
      print(e.toString());
      return null;
    }
  }

  Future signInWithFacebook() async {
    try {
      loginType = LoginType.Facebook;
      FacebookLoginResult facebookLoginResult = await facebookLogin.logIn(['email']);
      switch (facebookLoginResult.status) {
        case FacebookLoginStatus.loggedIn:
          FacebookAccessToken accessToken = facebookLoginResult.accessToken;
          AuthCredential credential = FacebookAuthProvider.getCredential(
            accessToken: accessToken.token
          );
          AuthResult result = await _auth.signInWithCredential(credential);
          FirebaseUser user = result.user;
          return _userFromFirebaseUser(user);
        case FacebookLoginStatus.error:
          return null;
        case FacebookLoginStatus.cancelledByUser:
          return null;
      }
    }catch(e) {
      print(e.toString());
      return null;
    }
  }

  //sign in with email & password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      loginType = LoginType.Email;
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      if(!user.isEmailVerified) {
        return "Verify Email";
      }
    }catch(e) {
      print(e.toString());
      return null;
    }
  }

  //register with email & password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      loginType = LoginType.EmailR;
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      user.sendEmailVerification();
      return "Verify Email";
    }catch(e) {
      if(e.code == "ERROR_EMAIL_ALREADY_IN_USE"){
        return 'The email address is already in use by another account.';
      }
    }
  }

  //sign out
  Future signOut() async {
    try {
      if(loginType == LoginType.Facebook) {
        await facebookLogin.logOut();
      }else if (loginType == LoginType.Google) {
        await _googleSignIn.disconnect();
      }
      return await _auth.signOut();
    }catch(e) {
      print(e.toString());
      return null;
    }
  }

}