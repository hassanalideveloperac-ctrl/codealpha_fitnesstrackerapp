import 'package:flutter/material.dart';
import '../models/workout.dart';
import '../database/database_helper.dart';

class FitnessProvider extends ChangeNotifier {
  List<Workout> _workouts = [];
  int _totalCalories = 0;
  int _totalSteps = 0;
  int _totalWorkouts = 0;
  bool _isLoading = false;

  List<Workout> get workouts => _workouts;
  int get totalCalories => _totalCalories;
  int get totalSteps => _totalSteps;
  int get totalWorkouts => _totalWorkouts;
  bool get isLoading => _isLoading;

  final DatabaseHelper _db = DatabaseHelper();

  Future<void> loadWorkouts() async {
    _isLoading = true;
    notifyListeners();

    try {
      _workouts = await _db.getAllWorkouts();
      await _updateStats();
    } catch (e) {
      debugPrint('Error loading workouts: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _updateStats() async {
    _totalCalories = await _db.getTotalCaloriesBurned();
    _totalSteps = await _db.getTotalSteps();
    _totalWorkouts = await _db.getWorkoutCount();
  }

  Future<void> addWorkout(Workout workout) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _db.insertWorkout(workout);
      await loadWorkouts();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateWorkout(Workout workout) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _db.updateWorkout(workout);
      await loadWorkouts();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> deleteWorkout(String id) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _db.deleteWorkout(id);
      await loadWorkouts();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> clearAllWorkouts() async {
    _isLoading = true;
    notifyListeners();
    try {
      await _db.deleteAllWorkouts();
      await loadWorkouts();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  List<Workout> getTodayWorkouts() {
    final today = DateTime.now();
    return _workouts.where((w) =>
    w.date.year == today.year &&
        w.date.month == today.month &&
        w.date.day == today.day
    ).toList();
  }

  List<Workout> getWeeklyWorkouts() {
    final today = DateTime.now();
    final weekAgo = today.subtract(const Duration(days: 7));
    return _workouts.where((w) =>
    w.date.isAfter(weekAgo) && w.date.isBefore(today.add(const Duration(days: 1)))
    ).toList();
  }

  int getTodayCalories() {
    return getTodayWorkouts().fold(0, (sum, w) => sum + w.caloriesBurned);
  }

  int getTodaySteps() {
    return getTodayWorkouts().fold(0, (sum, w) => sum + w.steps);
  }

  int getWeeklyCalories() {
    return getWeeklyWorkouts().fold(0, (sum, w) => sum + w.caloriesBurned);
  }

  int getWeeklySteps() {
    return getWeeklyWorkouts().fold(0, (sum, w) => sum + w.steps);
  }
}