import 'package:flutter/material.dart';
import '../models/leaderboard_model.dart';
import '../services/api_service.dart';

class LeaderboardProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<LeaderboardModel> _leaderboard = [];
  bool _isLoading = false;
  String? _error;
  int? _userRank;
  int? _userXP;

  List<LeaderboardModel> get leaderboard => _leaderboard;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int? get userRank => _userRank;
  int? get userXP => _userXP;

  Future<void> fetchLeaderboard() async {
    _setLoading(true);
    _error = null;
    try {
      final response = await _apiService.get('/leaderboard/top10');
      _leaderboard = (response['leaderboard'] as List)
          .map((item) => LeaderboardModel.fromJson(item))
          .toList();
      _userRank = response['userRank'];
      _userXP = response['userXP'];
    } catch (e) {
      _error = e.toString();
    }
    _setLoading(false);
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
