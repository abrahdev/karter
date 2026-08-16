import 'package:flutter/material.dart';
import 'package:mobile/core/modal_helpers.dart';
import 'package:mobile/l10n/app_localizations.dart';

void showPhotoSourcePicker({
  required BuildContext context,
  required VoidCallback onTakePhoto,
  required VoidCallback onChooseFromGallery,
  required VoidCallback onBrowseFiles,
}) {
  final l = AppLocalizations.of(context)!;
  karterShowModalBottomSheet(
    context: context,
    builder: (ctx) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: Text(l.takePhoto),
            onTap: () {
              Navigator.pop(ctx);
              onTakePhoto();
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: Text(l.chooseFromGallery),
            onTap: () {
              Navigator.pop(ctx);
              onChooseFromGallery();
            },
          ),
          ListTile(
            leading: const Icon(Icons.attach_file),
            title: Text(l.browseFiles),
            onTap: () {
              Navigator.pop(ctx);
              onBrowseFiles();
            },
          ),
        ],
      ),
    ),
  );
}
