import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? _verificationId;
  int? _resendToken;

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<void> sendOTP({
    required String phoneNumber,
    required Function(String verificationId) onCodeSent,
    required Function(String error) onError,
  }) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          onError(e.message ?? 'Verification failed');
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
          _resendToken = resendToken;
          onCodeSent(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
        forceResendingToken: _resendToken,
        timeout: const Duration(seconds: 60),
      );
    } catch (e) {
      onError(e.toString());
    }
  }

  Future<UserModel?> verifyOTP({
    required String smsCode,
    required String verificationId,
  }) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;
      if (user == null) return null;

      final isNew = userCredential.additionalUserInfo?.isNewUser ?? false;
      if (isNew) {
        final newUser = UserModel(
          uid: user.uid,
          phoneNumber: user.phoneNumber ?? '',
          displayName: '',
          email: '',
          role: 'student',
          subscriptionTier: 'free',
          xpPoints: 0,
          lessonsCompleted: 0,
          streakDays: 0,
          createdAt: DateTime.now(),
          lastActiveAt: DateTime.now(),
          fcmToken: '',
          isActive: true,
          monthlyLessonsUsed: 0,
          dailyChatUsed: 0,
        );
        await _firestore
            .collection('users')
            .doc(user.uid)
            .set(newUser.toMap());
        return newUser;
      } else {
        return await getUserProfile(user.uid);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel?> getUserProfile(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (!doc.exists) return null;
      return UserModel.fromMap(doc.data()!, doc.id);
    } catch (e) {
      return null;
    }
  }

  Future<void> updateUserProfile(String uid, Map<String, dynamic> data) async {
    await _firestore.collection('users').doc(uid).update(data);
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<bool> isTeacher(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (!doc.exists) return false;
    return doc.data()?['role'] == 'teacher';
  }
}
