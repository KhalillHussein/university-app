import 'package:dio/dio.dart';

import '../util/index.dart';
import 'index.dart';

/// Services that retrieves phone numbers.
class PhoneBookService extends BaseService {
  const PhoneBookService(Dio client) : super(client);

  /// Retrieves a list featuring the phone numbers.
  Future<Response> getRecordings() async {
    return client.get(Url.phoneNumbers);
  }
}
