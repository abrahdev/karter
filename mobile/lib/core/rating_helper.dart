import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:mobile/core/modal_helpers.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

const _hasRatedKey = 'has_rated';
const _lastPromptKey = 'last_prompt_date';
const _servicesSinceKey = 'services_since_prompt';
const _enabledKey = 'rating_prompt_enabled';
const _intervalKey = 'rating_prompt_services_interval';
const _repeatDaysKey = 'rating_prompt_repeat_days';

const defaultServicesInterval = 10;
const defaultRepeatDays = 30;

Future<bool> isRatingPromptEnabled() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool(_enabledKey) ?? true;
}

Future<void> setRatingPromptEnabled(bool enabled) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool(_enabledKey, enabled);
}

Future<int> getServicesInterval() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getInt(_intervalKey) ?? defaultServicesInterval;
}

Future<void> setServicesInterval(int value) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt(_intervalKey, value);
}

Future<int> getRepeatDays() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getInt(_repeatDaysKey) ?? defaultRepeatDays;
}

Future<void> setRepeatDays(int value) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt(_repeatDaysKey, value);
}

Future<void> showRatePrompt(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  if (prefs.getBool(_hasRatedKey) == true) return;
  if (prefs.getBool(_enabledKey) == false) return;

  final interval = prefs.getInt(_intervalKey) ?? defaultServicesInterval;
  final count = (prefs.getInt(_servicesSinceKey) ?? 0) + 1;
  await prefs.setInt(_servicesSinceKey, count);

  if (count < interval) return;

  final lastDateStr = prefs.getString(_lastPromptKey);
  if (lastDateStr != null) {
    final lastDate = DateTime.tryParse(lastDateStr);
    final repeatDays = prefs.getInt(_repeatDaysKey) ?? defaultRepeatDays;
    if (lastDate != null &&
        DateTime.now().difference(lastDate).inDays < repeatDays) {
      return;
    }
  }

  await prefs.setInt(_servicesSinceKey, 0);
  await prefs.setString(_lastPromptKey, DateTime.now().toIso8601String());

  final review = InAppReview.instance;
  if (await review.isAvailable()) {
    await review.requestReview();
    return;
  }

  if (!context.mounted) return;

  final result = await karterShowModalBottomSheet<bool>(
    context: context,
    builder: (ctx) => const _RatingSheet(),
  );

  if (result == true) {
    await prefs.setBool(_hasRatedKey, true);
    await openStorePage();
  }
}

class _RatingSheet extends StatelessWidget {
  const _RatingSheet();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.colorScheme.outlineVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Text(l.moreRate, style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            l.ratePromptMessage,
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(l.cancel),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => Navigator.pop(context, true),
                  icon: const Icon(Icons.star_outline, size: 20),
                  label: Text(l.rate),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Future<void> openStorePage() async {
  final review = InAppReview.instance;
  if (await review.isAvailable()) {
    await review.openStoreListing(
      appStoreId: 'dev.abrah.karter',
    );
    return;
  }

  final uri = Uri.parse(
    'https://play.google.com/store/apps/details?id=dev.abrah.karter',
  );
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
