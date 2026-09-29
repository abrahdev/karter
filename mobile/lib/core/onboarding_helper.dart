import 'package:shared_preferences/shared_preferences.dart';

const _kOnboardingKey = 'has_seen_onboarding';
const _kCoachMarksKey = 'has_seen_coach_marks';

Future<bool> hasSeenOnboarding() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool(_kOnboardingKey) ?? false;
}

Future<void> markOnboardingSeen() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool(_kOnboardingKey, true);
}

Future<bool> hasSeenCoachMarks() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool(_kCoachMarksKey) ?? false;
}

Future<void> markCoachMarksSeen() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool(_kCoachMarksKey, true);
}