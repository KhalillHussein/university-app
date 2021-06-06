import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';

import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

import '../models/index.dart';
import '../services/index.dart';
import '../util/index.dart';
import 'index.dart';

///Repository that manage news creation
class NewsCreateRepository extends BaseRepository<NewsCreateService> {
  NewsCreateRepository(NewsCreateService service) : super(service);

  String token;

  String introText;

  String fullText;

  DateTime createdAt = DateTime.now();

  String title;

  List<File> images = [];

  File _image;
  final ImagePicker picker = ImagePicker();

  @override
  Future<void> loadData() async {
    startLoading();
    try {
      await service.postNews(
          News(
              title: title,
              introText: introText,
              fullText: fullText,
              createdAt: createdAt,
              images: [for (final image in images) image.path]),
          token);
      finishLoading();
      clearFields();
    } on DioError catch (dioError) {
      try {
        final dynamic error = dioError.response.data['errors']['msg'];
        receivedError(error.toString());
      } catch (e) {
        receivedError(ApiException.fromDioError(dioError).message);
      }
    } catch (error) {
      receivedError(error.toString());
    }
  }

  Future<void> deleteData(String id) async {
    startLoading();
    try {
      await service.deleteNews(token, id);
      finishLoading();
    } on DioError catch (dioError) {
      receivedError(ApiException.fromDioError(dioError).message);
    } catch (error) {
      receivedError(error.toString());
    }
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      if (!images.contains(_image)) images.add(_image);
      notifyListeners();
    } else {
      debugPrint('No image selected.');
    }
  }

  void clearFields() {
    images = [];
    introText = '';
    fullText = '';
    title = '';
  }

  void changeIntoText(String value) {
    introText = value;
    notifyListeners();
  }

  void changeTitle(String value) {
    title = value;
    notifyListeners();
  }

  void changeFullText(String value) {
    fullText = value;
    notifyListeners();
  }

  void changeDate(DateTime date) {
    createdAt = date;
    notifyListeners();
  }
}
