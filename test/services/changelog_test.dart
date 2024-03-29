import 'package:mtusiapp/services/index.dart';
import 'package:mtusiapp/util/index.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import './mock.dart';

void main() {
  group('ChangelogService', () {
    Dio client;
    ChangelogService service;

    setUp(() {
      client = MockClient();
      service = ChangelogService(client);
    });

    test('throws AssertionError when client is null', () {
      expect(() => ChangelogService(null), throwsAssertionError);
    });

    test('returns request when client returns 200', () async {
      const json = 'Just a normal JSON here';
      final response = MockResponse();

      when(response.statusCode).thenReturn(200);
      when(response.data).thenReturn(json);
      when(
        client.get(Url.changelog),
      ).thenAnswer((_) => Future.value(response));

      final output = await service.getChangelog();
      expect(output.data, json);
    });
  });
}
