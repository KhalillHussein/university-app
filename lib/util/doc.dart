import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class Doc {
  static const organizationText =
      'Северо-Кавказский филиал ордена Трудового Красного Знамени федерального Государственного бюджетного образовательного учреждения высшего образования "Московский технический университет связи и информатики"';

  static const List<Map> info = [
    {
      'name': 'Адрес',
      'desc': '344002, г.Ростов-на-Дону, ул.Серафимовича, 62.',
      'icon': MdiIcons.mapMarker,
    },
    {
      'name': 'Телефон',
      'desc': '(863) 310-69-60',
      'icon': MdiIcons.phoneClassic,
    },
    {
      'name': 'Факс',
      'desc': '(863) 310-69-68',
      'icon': MdiIcons.deskphone,
    },
    {'name': 'Телекс', 'desc': '123432 VOLT RU', 'icon': MdiIcons.phoneVoip},
    {
      'name': 'Email',
      'desc': 'mаil@skf-mtusi.ru',
      'icon': MdiIcons.at,
    },
    {
      'name': 'Instagram',
      'desc': '@skf_mtusi',
      'icon': MdiIcons.instagram,
    },
    {
      'name': 'График работы',
      'desc':
          'С понедельника по пятницу: с 8.00 до 22.00. Суббота с 8.00 до 14.00',
      'icon': MdiIcons.accountHardHat,
    },
    {
      'name': 'Перерыв',
      'desc': '13.00 до 14.00',
      'icon': MdiIcons.sofaSingleOutline
    },
    {
      'name': 'Посетителям',
      'desc':
          'ПН-ЧТ: с 09.00 до 11.00 и с 16.00 до 18.00. ПТ с 14.00 до 16.00. СБ с 10.00 до 12.00',
      'icon': MdiIcons.accountCheckOutline,
    }
  ];
}
