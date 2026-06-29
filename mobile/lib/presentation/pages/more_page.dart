import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  static const _repoUrl = 'https://github.com/abrahdev/karter';
  static const _docsUrl = 'https://abrahdev.github.io/karter/';
  static const _sponsorsUrl = 'https://github.com/sponsors/abrahdev';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Acerca de Karter',
                    style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                Text(
                  'Karter es una app de mantenimiento de vehículos '
                  'local-first, open source y respetuosa con tu privacidad.',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        ListTile(
          leading: const Icon(Icons.storage),
          title: const Text('Exportar / Importar datos'),
          subtitle: const Text('Respaldar o transferir tu información'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.push('/data'),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.menu_book),
          title: const Text('Documentación'),
          subtitle: const Text('Guía de uso y características'),
          trailing: const Icon(Icons.open_in_new),
          onTap: () => _openUrl(context, _docsUrl),
        ),
        ListTile(
          leading: const Icon(Icons.code),
          title: const Text('Código fuente'),
          subtitle: const Text('Repositorio en GitHub'),
          trailing: const Icon(Icons.open_in_new),
          onTap: () => _openUrl(context, _repoUrl),
        ),
        ListTile(
          leading: const Icon(Icons.favorite, color: Colors.red),
          title: const Text('Donar'),
          subtitle: const Text('Apoya el desarrollo en GitHub Sponsors'),
          trailing: const Icon(Icons.open_in_new),
          onTap: () => _openUrl(context, _sponsorsUrl),
        ),
        const SizedBox(height: 24),
        Center(
          child: Text(
            'Hecho con ❤️ por abrahdev',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _openUrl(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se pudo abrir $url')),
        );
      }
    }
  }
}
