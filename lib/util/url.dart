/// Has all Urls used in the app as static const strings.

class Url {
  //Base URLs
  static const baseUrl = 'http://188.93.210.205:3000';

  //News URLs
  static const newsUrl = '$baseUrl/news';
  static const allNewsUrl = '$newsUrl/all';
  static const newsImgUrl = '$baseUrl/img/news/';

  //Params for paginate data
  static const limit = '/?limit=';
  static const page = '&page=';

  //Lecturers URL
  static const lecturersAllUrl = '$baseUrl/lecturers/all';

  //Schedule URL
  static const scheduleUrl = '$baseUrl/timetable';
  static const allScheduleUrl = '$baseUrl/timetable/all';

  //Auth URLs
  static const loginUrl = '$baseUrl/login';
}
