/// Has all urls used in the app as static const strings.

class Url {
  //Base URLs
  static const baseUrl = 'http://80.78.248.203:3064';

  //News URLs
  static const newsUrl = '$baseUrl/news';
  static const allNewsUrl = '$newsUrl/all';

  //Auth URLs
  static const loginUrl = '$baseUrl/login';
}
