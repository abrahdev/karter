import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:mobile/presentation/providers/vehicle_providers.dart';
import 'package:mobile/presentation/widgets/add_document_modal.dart';

class DocumentListPage extends ConsumerWidget {
  final String vehicleId;

  const DocumentListPage({super.key, required this.vehicleId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final docsAsync = ref.watch(vehicleDocumentsProvider(vehicleId));

    return Scaffold(
      appBar: AppBar(title: Text(l.vehicleDocuments)),
      body: docsAsync.when(
        data: (docs) {
          if (docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.description,
                      size: 64,
                      color: Theme.of(context).colorScheme.outline),
                  const SizedBox(height: 16),
                  Text(l.noFileSelected,
                      style: Theme.of(context).textTheme.titleMedium),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (_, i) {
              final doc = docs[i];
              return Card(
                child: ListTile(
                  leading: Icon(_iconForType(doc.type.name)),
                  title: Text(doc.name),
                  subtitle: Text(doc.fileName),
                ),
              );
            },
          );
        },
        loading: () =>
            const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddDocumentModal(
          context,
          vehicleId: vehicleId,
          onSaved: () =>
              ref.invalidate(vehicleDocumentsProvider(vehicleId)),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }

  IconData _iconForType(String type) {
    return switch (type) {
      'fine' => Icons.gavel,
      'parkingFee' => Icons.local_parking,
      'insurance' => Icons.verified_user,
      'vehicleCheck' => Icons.checklist,
      'tax' => Icons.receipt_long,
      'complexInsurance' => Icons.shield,
      'vehicleRegister' => Icons.assignment,
      _ => Icons.description,
    };
  }
}
