class AppConstants {
  // App Info
  static const String appName = 'Linguify';
  static const String appVersion = '1.0.0';

  // API
  static const String baseUrl = 'https://linguify-backend.railway.app/api';
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;

  // Egyptian Phone
  static const String phonePrefix = '+20';
  static const String phoneHint = '01XXXXXXXXX';

  // Subscription Prices (EGP)
  static const double freePriceEGP = 0;
  static const double premiumPriceEGP = 99;
  static const double proPriceEGP = 199;

  // Subscription Limits
  static const int freeLessonsPerMonth = 5;
  static const int freeChatPerDay = 5;
  static const int premiumChatPerDay = 20;
  static const int proChatPerDay = 50;

  // XP
  static const int baseXP = 50;
  static const double beginnerMultiplier = 0.8;
  static const double intermediateMultiplier = 1.0;
  static const double advancedMultiplier = 1.2;
  static const double fullCompletionBonus = 1.0;
  static const double partialCompletionBonus = 0.5;
  static const double completionThreshold = 0.8;

  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String onboardingKey = 'onboarding_done';

  // Firestore Collections
  static const String usersCollection = 'users';
  static const String lessonsCollection = 'lessons';
  static const String chatsCollection = 'chats';
  static const String leaderboardCollection = 'leaderboard';
  static const String paymentsCollection = 'payments';
  static const String teachersCollection = 'teachers';

  // Teacher emails
  static const List<String> teacherEmails = [
    'ahmed.hassan@linguify.eg',
    'sara.mohamed@linguify.eg',
    'omar.khalil@linguify.eg',
    'nour.ibrahim@linguify.eg',
    'youssef.ali@linguify.eg',
    'mariam.saad@linguify.eg',
    'karim.mostafa@linguify.eg',
    'dina.farouk@linguify.eg',
    'tarek.nasser@linguify.eg',
    'hana.mahmoud@linguify.eg',
  ];
}
