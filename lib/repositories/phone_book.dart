import 'package:dio/dio.dart';
import 'package:mtusiapp/models/phone_book.dart';
import 'package:mtusiapp/services/phone_book.dart';
import 'package:mtusiapp/util/exception.dart';
import 'index.dart';

/// Repository that holds lecturers data.
class PhoneBookRepository extends BaseRepository<PhoneBookService> {
  List<PhoneBook> _recordings;

  PhoneBookRepository(PhoneBookService service) : super(service);

  @override
  Future<void> loadData() async {
    try {
      final response = await service.getRecordings();
      _recordings = [
        for (final item in response.data) PhoneBook.fromJson(item)
      ];
      finishLoading();
    } on DioError catch (dioError) {
      receivedError(ApiException.fromDioError(dioError).message);
    } catch (_) {
      receivedError('[PARSER ERROR]');
    }
  }

  List<PhoneBook> get recordings => _recordings;

  int get itemCount => _recordings?.length;
}
