import 'package:flutter/material.dart';
import 'package:mobile/core/rating_helper.dart';
import 'package:mobile/core/theme/app_spacing.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:mobile/presentation/widgets/karter_switch_list_tile.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  bool _enabled = true;
  int _servicesInterval = defaultServicesInterval;
  int _repeatDays = defaultRepeatDays;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final enabled = await isRatingPromptEnabled();
    final interval = await getServicesInterval();
    final days = await getRepeatDays();
    if (!mounted) return;
    setState(() {
      _enabled = enabled;
      _servicesInterval = interval;
      _repeatDays = days;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: Text(l.feedbackTitle)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(l.feedbackTitle)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.pagePadding),
        children: [
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Icons.star_outline),
            title: Text(l.moreRate),
            subtitle: Text(l.moreRateSubtitle),
            trailing: const Icon(Icons.open_in_new),
            onTap: () => openStorePage(),
          ),
          const Divider(),
          KarterSwitchListTile(
            leading: Icon(
              _enabled ? Icons.notifications_active : Icons.notifications_off,
            ),
            title: Text(l.feedbackReminderToggle),
            subtitle: Text(l.feedbackReminderToggleSubtitle),
            value: _enabled,
            onChanged: (v) async {
              await setRatingPromptEnabled(v);
              setState(() => _enabled = v);
            },
          ),
          if (_enabled) ...[
            const Divider(height: 1, indent: 16, endIndent: 16),
            ListTile(
              leading: const Icon(Icons.build),
              title: Text(l.feedbackServicesInterval),
              subtitle: Text(l.feedbackServicesIntervalValue(_servicesInterval)),
              trailing: const Icon(Icons.edit),
              onTap: () => _editServicesInterval(context),
            ),
            const Divider(height: 1, indent: 16, endIndent: 16),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: Text(l.feedbackRepeatDays),
              subtitle: Text(l.feedbackRepeatDaysValue(_repeatDays)),
              trailing: const Icon(Icons.edit),
              onTap: () => _editRepeatDays(context),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _editServicesInterval(BuildContext context) async {
    final l = AppLocalizations.of(context)!;
    final controller = TextEditingController(text: _servicesInterval.toString());

    final result = await showDialog<int>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.feedbackServicesInterval),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            suffixText: l.feedbackServicesSuffix,
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l.cancel),
          ),
          FilledButton(
            onPressed: () {
              final val = int.tryParse(controller.text.trim());
              if (val != null && val >= 1) Navigator.pop(ctx, val);
            },
            child: Text(l.saveChangesShort),
          ),
        ],
      ),
    );

    if (result != null) {
      await setServicesInterval(result);
      setState(() => _servicesInterval = result);
    }
  }

  Future<void> _editRepeatDays(BuildContext context) async {
    final l = AppLocalizations.of(context)!;
    final controller = TextEditingController(text: _repeatDays.toString());

    final result = await showDialog<int>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.feedbackRepeatDays),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            suffixText: l.feedbackRepeatDaysSuffix,
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l.cancel),
          ),
          FilledButton(
            onPressed: () {
              final val = int.tryParse(controller.text.trim());
              if (val != null && val >= 1) Navigator.pop(ctx, val);
            },
            child: Text(l.saveChangesShort),
          ),
        ],
      ),
    );

    if (result != null) {
      await setRepeatDays(result);
      setState(() => _repeatDays = result);
    }
  }
}
