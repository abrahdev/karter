import 'package:flutter/material.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  static const _url = 'https://karter.abrah.dev/privacy/';

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l.privacyPolicy)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.privacy_tip_outlined, size: 64),
              const SizedBox(height: 16),
              Text(l.privacyPolicyDesc, textAlign: TextAlign.center),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () => launchUrl(
                  Uri.parse(_url),
                  mode: LaunchMode.externalApplication,
                ),
                icon: const Icon(Icons.open_in_new),
                label: Text(l.openPrivacyPolicy),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
