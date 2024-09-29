import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<UserCredential?> signInWithGoogle() async {
    // Kích hoạt luồng xác thực Google
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

    // Lấy chi tiết xác thực từ yêu cầu
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Tạo thông tin đăng nhập Firebase từ thông tin xác thực Google
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Đăng nhập vào Firebase với thông tin đăng nhập Google
    return await _auth.signInWithCredential(credential);
  }
}
