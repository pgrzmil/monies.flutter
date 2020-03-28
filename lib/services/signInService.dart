import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef ErrorCallback = void Function(Error error);

class SignInService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final _userIdKey = "userId";
  String _userId;

  Future<bool> get isLoggedIn async {
    final id = await userIdAsync;
    return id != null && id.isNotEmpty;
  }

  String get userId {
    return _userId;
  }

  Future<String> get userIdAsync async {
    if (_userId == null) {
      final preferences = await SharedPreferences.getInstance();
      _userId = preferences.getString(_userIdKey);
    }
    return _userId;
  }

  Future<FirebaseUser> signIn(ErrorCallback onError) async {
    try {
      final GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final AuthResult authResult = await FirebaseAuth.instance.signInWithCredential(credential);
      final FirebaseUser user = authResult.user;

      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
      assert(user.uid == currentUser.uid);

      final preferences = await SharedPreferences.getInstance();
      await preferences.setString(_userIdKey, currentUser.uid);

      return currentUser;
    } catch (error) {
      onError(error);
      return null;
    }
  }

  Future<void> signOut() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(_userIdKey);
    await preferences.clear();
    _userId = null;
    await FirebaseAuth.instance.signOut();
    await _googleSignIn.signOut();
  }
}
