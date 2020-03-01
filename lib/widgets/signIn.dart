import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final userIdKey = "userId";

  Future<bool> isLoggedIn() async {
    final preferences = await SharedPreferences.getInstance();
    final userId = preferences.getString(userIdKey);
    return userId != null && userId.isNotEmpty;
  }

  Future<FirebaseUser> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final AuthResult authResult = await _auth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(userIdKey, currentUser.uid);

    return currentUser;
  }

  Future<GoogleSignInAccount> signOutGoogle() {
    return _googleSignIn.signOut();
  }
}
