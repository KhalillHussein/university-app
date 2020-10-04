/// Has all Urls used in the app as static const strings.

class Url {
  //Base URLs
  static const baseUrl = 'http://80.78.248.203:3064';

  //API Map Key
  static const stadiaKey = '0877e6d4-a77b-449d-8386-e6346ac05a58';

  // Map URLs
  static const lightMap =
      'https://tiles.stadiamaps.com/tiles/alidade_smooth/{z}/{x}/{y}@2x.png?api_key=$stadiaKey';
  static const darkMap =
      'https://tiles.stadiamaps.com/tiles/alidade_smooth_dark/{z}/{x}/{y}@2x.png?api_key=$stadiaKey';

  //News URLs
  static const newsUrl = '$baseUrl/news';
  static const allNewsUrl = '$newsUrl/all';
  static const newsImgUrl = '$baseUrl/img/news/';

  //Lecturers url
  static const lecturersAllUrl = '$baseUrl/lecturers/all';

  //Auth URLs
  static const loginUrl = '$baseUrl/login';
}
