import 'package:flutter/material.dart';
import '../models/lesson_model.dart';
import '../services/api_service.dart';

class LessonProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<LessonModel> _lessons = [];
  LessonModel? _currentLesson;
  bool _isLoading = false;
  String? _error;
  String _selectedLevel = 'all';
  String _searchQuery = '';

  List<LessonModel> get lessons => _filteredLessons;
  LessonModel? get currentLesson => _currentLesson;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get selectedLevel => _selectedLevel;

  List<LessonModel> get _filteredLessons {
    return _lessons.where((lesson) {
      final matchesLevel = _selectedLevel == 'all' || lesson.level == _selectedLevel;
      final matchesSearch = _searchQuery.isEmpty ||
          lesson.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          lesson.description.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesLevel && matchesSearch;
    }).toList();
  }

  Future<void> fetchLessons() async {
    _setLoading(true);
    _error = null;
    try {
      final response = await _apiService.get('/lessons');
      _lessons = (response['lessons'] as List)
          .map((l) => LessonModel.fromJson(l))
          .toList();
    } catch (e) {
      _error = e.toString();
    }
    _setLoading(false);
  }

  Future<void> fetchLessonById(String id) async {
    _setLoading(true);
    _error = null;
    try {
      final response = await _apiService.get('/lessons/$id');
      _currentLesson = LessonModel.fromJson(response['lesson']);
    } catch (e) {
      _error = e.toString();
    }
    _setLoading(false);
  }

  Future<void> completeLesson(String lessonId, double watchPercent) async {
    try {
      await _apiService.post('/lessons/$lessonId/complete', {
        'watchPercent': watchPercent,
      });
      await fetchLessons();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  void setLevel(String level) {
    _selectedLevel = level;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
