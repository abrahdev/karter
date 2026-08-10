import 'package:flutter/material.dart';
import 'package:mobile/core/theme/app_spacing.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:mobile/presentation/widgets/dtc_lookup_modal.dart';

class ObdPage extends StatelessWidget {
  const ObdPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l.navObd)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.pagePadding),
        children: [
          Card(
            clipBehavior: Clip.antiAlias,
            child: ListTile(
              leading: const Icon(Icons.search),
              title: Text(l.dtcLookupTitle),
              subtitle: Text(l.dtcSearchHint),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => showDtcLookupModal(context),
            ),
          ),
        ],
      ),
    );
  }
}
