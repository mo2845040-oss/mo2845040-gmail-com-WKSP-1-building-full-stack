import 'package:cloud_firestore/cloud_firestore.dart';

class LeaderboardModel {
  final String userId;
  final String userName;
  final String userPhone;
  final int totalXP;
  final int rank;
  final String profileImageUrl;
  final int lessonsCompleted;
  final DateTime lastActivityAt;

  LeaderboardModel({
    required this.userId,
    required this.userName,
    required this.userPhone,
    required this.totalXP,
    required this.rank,
    required this.profileImageUrl,
    required this.lessonsCompleted,
    required this.lastActivityAt,
  });

  factory LeaderboardModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return LeaderboardModel(
      userId: doc.id,
      userName: data['userName'] ?? 'Unknown',
      userPhone: data['userPhone'] ?? '',
      totalXP: data['totalXP'] ?? 0,
      rank: data['rank'] ?? 0,
      profileImageUrl: data['profileImageUrl'] ?? '',
      lessonsCompleted: data['lessonsCompleted'] ?? 0,
      lastActivityAt: data['lastActivityAt'] is Timestamp
          ? (data['lastActivityAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  factory LeaderboardModel.fromMap(Map<String, dynamic> data, String userId) {
    return LeaderboardModel(
      userId: userId,
      userName: data['userName'] ?? 'Unknown',
      userPhone: data['userPhone'] ?? '',
      totalXP: data['totalXP'] ?? 0,
      rank: data['rank'] ?? 0,
      profileImageUrl: data['profileImageUrl'] ?? '',
      lessonsCompleted: data['lessonsCompleted'] ?? 0,
      lastActivityAt: data['lastActivityAt'] is Timestamp
          ? (data['lastActivityAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userName': userName,
      'userPhone': userPhone,
      'totalXP': totalXP,
      'rank': rank,
      'profileImageUrl': profileImageUrl,
      'lessonsCompleted': lessonsCompleted,
      'lastActivityAt': Timestamp.fromDate(lastActivityAt),
    };
  }

  LeaderboardModel copyWith({
    String? userId,
    String? userName,
    String? userPhone,
    int? totalXP,
    int? rank,
    String? profileImageUrl,
    int? lessonsCompleted,
    DateTime? lastActivityAt,
  }) {
    return LeaderboardModel(
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userPhone: userPhone ?? this.userPhone,
      totalXP: totalXP ?? this.totalXP,
      rank: rank ?? this.rank,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      lessonsCompleted: lessonsCompleted ?? this.lessonsCompleted,
      lastActivityAt: lastActivityAt ?? this.lastActivityAt,
    );
  }
}
