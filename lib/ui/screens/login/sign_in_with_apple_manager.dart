import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class SignInWithAppleManager {
  // Shared Instance
  SignInWithAppleManager._sharedInstance() : super();
  static final SignInWithAppleManager _shared =
      SignInWithAppleManager._sharedInstance();
  factory SignInWithAppleManager() => _shared;

  Future<AuthorizationCredentialAppleID> signIn() async {
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      // nonce: 'example-nonce',
      // state: 'example-state',
    );
    // If we got this far, a session based on the Apple ID credential has been created in your system,
    // and you can now set this as the app's session
    return credential;
  }

  Future<void> signOut() async {
    //currently sign-in-with-apple provides no sign out options
  }
}
