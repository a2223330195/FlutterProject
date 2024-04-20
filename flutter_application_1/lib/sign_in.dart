import 'package:logging/logging.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();
final Logger logger = Logger('sign_in');

Future<String> signInWithGoogle() async {
  try {
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    final GoogleSignInAuthentication? googleSignInAuthentication =
        await googleSignInAccount?.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication?.accessToken,
      idToken: googleSignInAuthentication?.idToken,
    );
    final UserCredential authResult =
        await _auth.signInWithCredential(credential);
    final User? user = authResult.user;
    assert(!user!.isAnonymous);
    assert(await user?.getIdToken() != null);
    final User? currentUser = _auth.currentUser;
    assert(user?.uid == currentUser?.uid);
    return 'signInWithGoogle succeeded: $user';
  } catch (error) {
    logger.severe('Error en signInWithGoogle: $error');
    rethrow;
  }
}

void signOutGoogle() async {
  await googleSignIn.signOut();

  logger.info("User Sign Out");
}
