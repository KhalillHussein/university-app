import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'package:file_picker/file_picker.dart';
import 'package:mtusiapp/models/index.dart';

class TimetableUploadProvider with ChangeNotifier {
  bool filePicked = false;
  String path;
  List<PlatformFile> _paths;
  ValidationItem title = ValidationItem(null, null);
  ValidationItem description = ValidationItem(null, null);

  Future<void> openFileExplorer() async {
    try {
      _paths = (await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      ))
          ?.files;
      filePicked = _paths != null;
      path = _paths?.first?.path;
      notifyListeners();
    } on PlatformException catch (e) {
      debugPrint("Unsupported operation" + e.toString());
    } catch (ex) {
      debugPrint(ex);
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title.value,
      'description': description.value,
      '': MultipartFile.fromFileSync(
        path,
        filename: path.split('/').last,
      ),
    };
  }

  bool get isFormValid {
    if (title.value != null && description.value != null && filePicked) {
      return true;
    } else {
      return false;
    }
  }

  void changeTitle(String value) {
    if (value.length > 5) {
      title = ValidationItem(value, null);
    } else {
      title = ValidationItem(null, 'Слишком короткая запись');
    }
    notifyListeners();
  }

  void changeDescription(String value) {
    if (value.length > 5) {
      description = ValidationItem(value, null);
    } else {
      description = ValidationItem(null, 'Слишком короткая запись');
    }
    notifyListeners();
  }

  void cleanSelectable() {
    _paths = null;
    filePicked = false;
    title = ValidationItem(null, null);
    description = ValidationItem(null, null);
    notifyListeners();
  }
}
