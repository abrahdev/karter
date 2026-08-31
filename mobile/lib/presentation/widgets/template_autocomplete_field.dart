import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/data/models/template_index.dart';
import 'package:mobile/presentation/providers/vehicle_providers.dart';

class KarterAutocompleteField extends ConsumerWidget {
  final String label;
  final String? hint;
  final String initialValue;
  final List<String> Function(String query, TemplateIndex? index) optionsBuilder;
  final ValueChanged<String> onChanged;
  final String? Function(String?)? validator;
  final TemplateIndex? index;

  const KarterAutocompleteField({
    super.key,
    required this.label,
    this.hint,
    required this.initialValue,
    required this.optionsBuilder,
    required this.onChanged,
    this.validator,
    this.index,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index =
        this.index ?? ref.watch(templateIndexProvider).value;
    return Autocomplete<String>(
      initialValue: TextEditingValue(text: initialValue),
      optionsBuilder: (textEditingValue) {
        final query = textEditingValue.text;
        if (query.isEmpty) return const <String>[];
        return optionsBuilder(query, index);
      },
      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
        return TextFormField(
          controller: controller,
          focusNode: focusNode,
          decoration: InputDecoration(labelText: label, hintText: hint),
          onChanged: onChanged,
          onFieldSubmitted: (_) => onFieldSubmitted(),
          validator: validator,
        );
      },
      onSelected: (value) => onChanged(value),
    );
  }
}