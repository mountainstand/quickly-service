import 'package:google_sign_in/google_sign_in.dart';

import '../../../constants_and_extensions/nonui_extensions.dart';

class GoogleSignInManager {
  GoogleSignIn? _googleSignIn;

  // Shared Instance
  GoogleSignInManager._sharedInstance() : super();
  static final GoogleSignInManager _shared =
      GoogleSignInManager._sharedInstance();
  factory GoogleSignInManager() => _shared;

  void _initialiseIfRequired() {
    if (_googleSignIn != null) {
      return;
    }
    _googleSignIn = GoogleSignIn(
      // Optional clientId
      // clientId: '133440251506-fqp0ebiiu4mgv2acfd3htuh6pblqlgii.apps.googleusercontent.com',
      scopes: ['email'],
    );
  }

  Future<GoogleSignInAccount?> signIn() async {
    _initialiseIfRequired();
    try {
      return await _googleSignIn?.signIn();
    } catch (error) {
      ("Error in signIn():", error).log();
    }
    return null;
  }

  Future<void> signOut() async {
    _initialiseIfRequired();
    if (await _googleSignIn?.isSignedIn() == true) {
      try {
        await _googleSignIn?.signOut();
      } catch (error) {
        ("Error in signOut():", error).log();
      }
    }
  }
}
