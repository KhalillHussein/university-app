import 'package:dio/dio.dart';

import 'index.dart';

/// Services that retrieves phone numbers.
class PhoneBookService extends BaseService {
  const PhoneBookService(Dio client) : super(client);

  /// Retrieves a list featuring the phone numbers.
  Future<Response> getRecordings() async {
    return client.get(
        'https://firebasestorage.googleapis.com/v0/b/my-flutter-f53db.appspot.com/o/phone_book.json?alt=media&token=ca9acece-6664-47b1-bad9-7978637e50da');
  }
}
