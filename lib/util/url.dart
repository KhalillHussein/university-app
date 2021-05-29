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
      'https://firebasestorage.googleapis.com/v0/b/my-flutter-f53db.appspot.com/o/lecturers_full.json?alt=media&token=b6b92f37-600e-4f8e-814e-9823c46939a6';

  //Alternative Phone numbers URL
  static const phoneNumbers =
      'https://firebasestorage.googleapis.com/v0/b/my-flutter-f53db.appspot.com/o/phone_book.json?alt=media&token=ca9acece-6664-47b1-bad9-7978637e50da';

  //Changelog URL
  static const changelog =
      'https://raw.githubusercontent.com/KhalillHussein/under-construction/master/CHANGELOG.md';
}
