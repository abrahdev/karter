import 'package:mobile/data/services/template_translations.dart';

String localizedLabel(String locale, String? i18nKey, String fallback) {
  if (i18nKey == null) return fallback;
  return TemplateTranslations.getLabel(locale, i18nKey, fallback);
}

String localizedDesc(String locale, String? descI18nKey, String fallback) {
  if (descI18nKey == null) return fallback;
  return TemplateTranslations.getDesc(locale, descI18nKey, fallback);
}
