import 'package:dio/dio.dart';

import '../models/index.dart';
import '../services/index.dart';
import '../util/index.dart';
import 'index.dart';

/// Repository that holds lecturers data.
class PhoneBookRepository extends BaseRepository<PhoneBookService> {
  PhoneBookRepository(PhoneBookService service) : super(service);

  List<PhoneBook> _phoneNumbers;

  @override
  Future<void> loadData() async {
    try {
      final response = await service.getRecordings();
      _phoneNumbers = [
        for (final item in response.data) PhoneBook.fromJson(item)
      ];
      finishLoading();
    } on DioError catch (dioError) {
      receivedError(ApiException.fromDioError(dioError).message);
    } catch (_) {
      receivedError('Internal error');
    }
  }

  List<PhoneBook> get recordings => _phoneNumbers;

  int get itemCount => _phoneNumbers?.length;
}
