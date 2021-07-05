// import 'dart:io';
//
// import 'package:dio/dio.dart';
// import 'package:flutter/foundation.dart';
// import 'package:image_picker/image_picker.dart';
//
// class NewsCreateProvider extends ChangeNotifier {
//   String introText;
//
//   String fullText;
//
//   DateTime createdAt;
//
//   String title;
//
//   List<File> images = [];
//
//   bool get isValid {
//     if (introText != null &&
//         fullText != null &&
//         createdAt != null &&
//         title != null) {
//       return true;
//     } else {
//       return false;
//     }
//   }
//
//   File _image;
//   final ImagePicker picker = ImagePicker();
//
//   Future getImage() async {
//     final pickedFile = await picker.getImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       _image = File(pickedFile.path);
//       if (!images.contains(_image)) images.add(_image);
//       notifyListeners();
//     } else {
//       debugPrint('No image selected.');
//     }
//   }
//
//   Map<String, dynamic> toMap() {
//     return {
//       'title': title,
//       'introText': introText,
//       'date': createdAt.millisecondsSinceEpoch,
//       'fullText': fullText,
//       'image': [
//         for (final image in images)
//           MultipartFile.fromFileSync(
//             image.path,
//             filename: image.path.split('/').last,
//           ),
//       ],
//     };
//   }
//
//   void clearFields() {
//     images = [];
//     introText = '';
//     fullText = '';
//     title = '';
//   }
//
//   void changeDate(DateTime date) {
//     createdAt = date;
//     notifyListeners();
//   }
// }

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class NewsCreateProvider extends ChangeNotifier {
  String introText;

  String fullText;

  DateTime createdAt;

  String title;

  List<File> paths;
  List<File> images = [];

  bool get isValid {
    if (introText != null &&
        fullText != null &&
        createdAt != null &&
        title != null) {
      return true;
    } else {
      return false;
    }
  }

  Future getImage() async {
    try {
      paths = (await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: true,
      ))
          ?.paths
          ?.map((path) => File(path))
          ?.toList();
      if (paths != null) {
        images.addAll(paths);
        notifyListeners();
      } else {
        debugPrint('No image selected.');
      }
    } on PlatformException catch (e) {
      debugPrint('Unsupported operation ${e.toString()}');
    } catch (ex) {
      debugPrint(ex.toString());
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'introText': introText,
      'date': createdAt.millisecondsSinceEpoch,
      'fullText': fullText,
      'image': [
        for (final image in images)
          MultipartFile.fromFileSync(
            image.path,
            filename: image.path.split('/').last,
          ),
      ],
    };
  }

  void clearFields() {
    images = [];
    introText = '';
    fullText = '';
    title = '';
  }

  void changeDate(DateTime date) {
    createdAt = date;
    notifyListeners();
  }
}
