/// Has all Urls used in the app as static const strings.

class Url {
  //Base URLs
  static const baseUrl = 'http://80.78.248.203:3064';

  //News URLs
  static const newsUrl = '$baseUrl/news';
  static const allNewsUrl = '$newsUrl/all';
  static const newsImgUrl = '$baseUrl/img/news/';

  //Lecturers url
  static const lecturersAllUrl = '$baseUrl/lecturers/all';

  //Auth URLs
  static const loginUrl = '$baseUrl/login';
}
