import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/workout.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static const String _key = 'workouts';

  Future<List<Workout>> getAllWorkouts() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_key);
    if (data == null) return [];
    final List<dynamic> decoded = json.decode(data);
    return decoded.map((item) => Workout.fromJson(item)).toList();
  }

  Future<void> saveWorkouts(List<Workout> workouts) async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = json.encode(workouts.map((w) => w.toJson()).toList());
    await prefs.setString(_key, encoded);
  }

  Future<void> insertWorkout(Workout workout) async {
    final workouts = await getAllWorkouts();
    workouts.insert(0, workout);
    await saveWorkouts(workouts);
  }

  Future<void> updateWorkout(Workout workout) async {
    final workouts = await getAllWorkouts();
    final index = workouts.indexWhere((w) => w.id == workout.id);
    if (index != -1) {
      workouts[index] = workout;
      await saveWorkouts(workouts);
    }
  }

  Future<void> deleteWorkout(String id) async {
    final workouts = await getAllWorkouts();
    workouts.removeWhere((w) => w.id == id);
    await saveWorkouts(workouts);
  }

  Future<void> deleteAllWorkouts() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }

  Future<int> getTotalCaloriesBurned() async {
    final workouts = await getAllWorkouts();
    int total = 0;
    for (var workout in workouts) {
      total = total + workout.caloriesBurned;
    }
    return total;
  }

  Future<int> getTotalSteps() async {
    final workouts = await getAllWorkouts();
    int total = 0;
    for (var workout in workouts) {
      total = total + workout.steps;
    }
    return total;
  }

  Future<int> getWorkoutCount() async {
    final workouts = await getAllWorkouts();
    return workouts.length;
  }
}