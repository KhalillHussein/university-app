/// Has all Urls used in the app as static const strings.

class Url {
  //Base URLs
  static const baseUrl = 'http://188.93.210.205:3000';

  //News URLs
  static const news = '$baseUrl/news';
  static const allNews = '$news/all';
  static const newsImg = '$baseUrl/img/news/';

  //Params for paginate data
  static const limit = '/?limit=';
  static const page = '&page=';

  //Lecturers URL
  static const lecturersAll = '$baseUrl/lecturers/all';

  //Schedule URL
  static const schedule = '$baseUrl/timetable';
  static const allSchedule = '$schedule/all';

  //Auth URLs
  static const loginUrl = '$baseUrl/login';

  //Alternative Lecturers URL
  static const lecturers =
      'https://firebasestorage.googleapis.com/v0/b/my-flutter-f53db.appspot.com/o/lecturers_full.json?alt=media&token=722d462a-38db-4480-a43d-ef3241758af2';

  //Alternative Phone numbers URL
  static const phoneNumbers =
      'https://firebasestorage.googleapis.com/v0/b/my-flutter-f53db.appspot.com/o/phone_book.json?alt=media&token=f1066c76-8561-414c-8f08-44841c5823d2';

  //Changelog URL
  static const changelog =
      'https://raw.githubusercontent.com/KhalillHussein/under-construction/master/CHANGELOG.md';
}
