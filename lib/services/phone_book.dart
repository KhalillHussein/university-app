import 'package:dio/dio.dart';

import 'index.dart';

/// Services that retrieves phone book.
class PhoneBookService extends BaseService {
  const PhoneBookService(Dio client) : super(client);

  /// Retrieves a list featuring the phone numbers.
  Future<Response> getRecordings() async {
    return client.get(
        'https://firebasestorage.googleapis.com/v0/b/my-flutter-f53db.appspot.com/o/phone_book.json?alt=media&token=86493ec9-52a3-456e-8bd4-a85db6526470');
  }
}
