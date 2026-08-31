import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mobile/data/services/catalog_service.dart';

void main() {
  group('resolveBaseUrl', () {
    test('substitutes <tag> with the latest release of any repo', () async {
      final client = MockClient((request) async {
        if (request.url.path == '/repos/acme/workshop/releases/latest') {
          return http.Response('{"tag_name": "v2.0.1"}', 200);
        }
        return http.Response('not found', 404);
      });
      const url =
          'https://raw.githubusercontent.com/acme/workshop/<tag>/templates';
      expect(
        await CatalogService.resolveBaseUrl(url, client: client),
        'https://raw.githubusercontent.com/acme/workshop/v2.0.1/templates',
      );
    });

    test('returns the literal URL when the tag cannot be resolved', () async {
      final client = MockClient((request) async => http.Response('nope', 404));
      const url =
          'https://raw.githubusercontent.com/acme/workshop/<tag>/templates';
      expect(await CatalogService.resolveBaseUrl(url, client: client), url);
    });

    test('converts github.com URLs to raw with main branch', () async {
      final client = MockClient((request) async => http.Response('nope', 404));
      expect(
        await CatalogService.resolveBaseUrl(
          'https://github.com/acme/workshop/templates',
          client: client,
        ),
        'https://raw.githubusercontent.com/acme/workshop/main/templates',
      );
    });

    test('leaves raw URLs without <tag> untouched', () async {
      final client = MockClient((request) async => http.Response('nope', 404));
      const url =
          'https://raw.githubusercontent.com/acme/workshop/main/templates';
      expect(await CatalogService.resolveBaseUrl(url, client: client), url);
    });

    test('replaces <tag> in a github.com URL then converts to raw', () async {
      final client = MockClient((request) async {
        if (request.url.path == '/repos/acme/workshop/releases/latest') {
          return http.Response('{"tag_name": "v1.0.0"}', 200);
        }
        return http.Response('not found', 404);
      });
      expect(
        await CatalogService.resolveBaseUrl(
          'https://github.com/acme/workshop/<tag>/templates',
          client: client,
        ),
        'https://raw.githubusercontent.com/acme/workshop/v1.0.0/templates',
      );
    });
  });

  group('latestReleaseRef', () {
    test('parses tag_name', () async {
      final client = MockClient(
        (request) async => http.Response('{"tag_name": "v1.2.3"}', 200),
      );
      expect(
        await CatalogService.latestReleaseRef(owner: 'a', repo: 'b', client: client),
        'v1.2.3',
      );
    });

    test('returns null on non-200', () async {
      final client = MockClient((request) async => http.Response('x', 404));
      expect(
        await CatalogService.latestReleaseRef(owner: 'a', repo: 'b', client: client),
        isNull,
      );
    });
  });

  group('listTags', () {
    test('parses tag names', () async {
      final client = MockClient(
        (request) async => http.Response('[{"name":"v1"},{"name":"v2"}]', 200),
      );
      expect(
        await CatalogService.listTags(owner: 'a', repo: 'b', client: client),
        ['v1', 'v2'],
      );
    });

    test('returns empty on failure', () async {
      final client =
          MockClient((request) async => throw Exception('boom'));
      expect(
        await CatalogService.listTags(owner: 'a', repo: 'b', client: client),
        isEmpty,
      );
    });
  });

  group('parseOwnerRepo', () {
    test('parses raw, github and rejects others', () {
      expect(
        CatalogService.parseOwnerRepo(
          'https://raw.githubusercontent.com/a/b/<tag>/templates',
        ),
        ('a', 'b'),
      );
      expect(
        CatalogService.parseOwnerRepo('https://github.com/a/b/templates'),
        ('a', 'b'),
      );
      expect(CatalogService.parseOwnerRepo('https://example.com/x'), isNull);
    });
  });
}