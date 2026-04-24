import 'package:cloud_firestore/cloud_firestore.dart';

enum UserRole { student, teacher }
enum SubscriptionTier { free, premium, pro }

class UserModel {
  final String uid;
  final String phoneNumber;
  final String? displayName;
  final String? photoUrl;
  final UserRole role;
  final SubscriptionTier subscriptionTier;
  final int xpTotal;
  final int lessonsCompletedThisMonth;
  final int chatMessagesToday;
  final DateTime? subscriptionExpiry;
  final DateTime createdAt;
  final DateTime lastActive;

  UserModel({
    required this.uid,
    required this.phoneNumber,
    this.displayName,
    this.photoUrl,
    this.role = UserRole.student,
    this.subscriptionTier = SubscriptionTier.free,
    this.xpTotal = 0,
    this.lessonsCompletedThisMonth = 0,
    this.chatMessagesToday = 0,
    this.subscriptionExpiry,
    required this.createdAt,
    required this.lastActive,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      phoneNumber: data['phoneNumber'] ?? '',
      displayName: data['displayName'],
      photoUrl: data['photoUrl'],
      role: UserRole.values.firstWhere(
        (e) => e.name == (data['role'] ?? 'student'),
        orElse: () => UserRole.student,
      ),
      subscriptionTier: SubscriptionTier.values.firstWhere(
        (e) => e.name == (data['subscriptionTier'] ?? 'free'),
        orElse: () => SubscriptionTier.free,
      ),
      xpTotal: data['xpTotal'] ?? 0,
      lessonsCompletedThisMonth: data['lessonsCompletedThisMonth'] ?? 0,
      chatMessagesToday: data['chatMessagesToday'] ?? 0,
      subscriptionExpiry: data['subscriptionExpiry'] != null
          ? (data['subscriptionExpiry'] as Timestamp).toDate()
          : null,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      lastActive: (data['lastActive'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'phoneNumber': phoneNumber,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'role': role.name,
      'subscriptionTier': subscriptionTier.name,
      'xpTotal': xpTotal,
      'lessonsCompletedThisMonth': lessonsCompletedThisMonth,
      'chatMessagesToday': chatMessagesToday,
      'subscriptionExpiry': subscriptionExpiry != null
          ? Timestamp.fromDate(subscriptionExpiry!)
          : null,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastActive': Timestamp.fromDate(lastActive),
    };
  }

  UserModel copyWith({
    String? displayName,
    String? photoUrl,
    SubscriptionTier? subscriptionTier,
    int? xpTotal,
    int? lessonsCompletedThisMonth,
    int? chatMessagesToday,
    DateTime? subscriptionExpiry,
    DateTime? lastActive,
  }) {
    return UserModel(
      uid: uid,
      phoneNumber: phoneNumber,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      role: role,
      subscriptionTier: subscriptionTier ?? this.subscriptionTier,
      xpTotal: xpTotal ?? this.xpTotal,
      lessonsCompletedThisMonth:
          lessonsCompletedThisMonth ?? this.lessonsCompletedThisMonth,
      chatMessagesToday: chatMessagesToday ?? this.chatMessagesToday,
      subscriptionExpiry: subscriptionExpiry ?? this.subscriptionExpiry,
      createdAt: createdAt,
      lastActive: lastActive ?? this.lastActive,
    );
  }

  bool get isTeacher => role == UserRole.teacher;
  bool get isPremium => subscriptionTier == SubscriptionTier.premium;
  bool get isPro => subscriptionTier == SubscriptionTier.pro;
  bool get hasActiveSubscription =>
      subscriptionExpiry != null && subscriptionExpiry!.isAfter(DateTime.now());
}
