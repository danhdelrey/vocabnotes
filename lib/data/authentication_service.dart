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

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut(); // Đăng xuất khỏi Google Sign-In
      await FirebaseAuth.instance
          .signOut(); // Đăng xuất khỏi Firebase Authentication
      // Xử lý thành công (ví dụ: điều hướng đến màn hình đăng nhập)
    } catch (e) {
      // Xử lý lỗi đăng xuất
      print('Lỗi đăng xuất: $e');
    }
  }
}
