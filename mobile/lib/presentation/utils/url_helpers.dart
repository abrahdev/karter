import 'package:flutter/material.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

String? normalizeUrl(
  String? raw,
  ScaffoldMessengerState messenger,
  AppLocalizations l,
) {
  if (raw == null || raw.isEmpty) return null;
  var candidate = raw;
  if (!candidate.startsWith('http://') &&
      !candidate.startsWith('https://')) {
    candidate = 'https://$candidate';
  }
  final uri = Uri.tryParse(candidate);
  if (uri == null || !uri.hasScheme || uri.host.isEmpty) {
    messenger.showSnackBar(SnackBar(content: Text(l.invalidUrl)));
    return null;
  }
  return candidate;
}

Future<void> openLink(BuildContext context, String url) async {
  final l = AppLocalizations.of(context)!;
  final messenger = ScaffoldMessenger.of(context);
  final uri = Uri.tryParse(url);
  if (uri == null || !uri.hasScheme || uri.host.isEmpty) {
    messenger.showSnackBar(SnackBar(content: Text(l.invalidUrl)));
    return;
  }
  final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
  if (!opened && context.mounted) {
    messenger.showSnackBar(SnackBar(content: Text(l.invalidUrl)));
  }
}
