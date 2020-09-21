import 'package:community_material_icon/community_material_icon.dart';

class Sections {
  static const List<Map<String, Object>> drawerSections = [
    {
      'id': 1,
      'parentId': -1,
      'title': 'Root',
    },
    {
      'id': 2,
      'parentId': 1,
      'title': 'Основные сведения',
      'icon': CommunityMaterialIcons.alert_octagram_outline,
    },
    {
      'id': 3,
      'parentId': 1,
      'title': 'Структура и органы управления',
      'icon': CommunityMaterialIcons.account_group_outline,
    },
    {
      'id': 4,
      'parentId': 3,
      'title': 'Ученый совет',
    },
    {
      'id': 5,
      'parentId': 3,
      'title': 'Факультет инфокоммуникаций',
    },
    {
      'id': 6,
      'parentId': 3,
      'title': 'Кафедра инфокоммуникационных технологий и систем связи',
    },
    {
      'id': 7,
      'parentId': 3,
      'title': 'Кафедра информатики и вычислительной техники',
    },
    {
      'id': 8,
      'parentId': 3,
      'title': 'Кафедра общенаучной подготовки',
    },
    {
      'id': 9,
      'parentId': 1,
      'title': 'Документы',
      'icon': CommunityMaterialIcons.book_open_page_variant,
    },
    {
      'id': 10,
      'parentId': 1,
      'title': 'Образовательные стандарты',
      'icon': CommunityMaterialIcons.book_variant_multiple,
    },
    {
      'id': 11,
      'parentId': 1,
      'title': 'Руководство. Научно-педагогический состав',
      'icon': CommunityMaterialIcons.account_tie_outline,
    },
    {
      'id': 12,
      'parentId': 11,
      'title': 'Руководство',
    },
    {
      'id': 13,
      'parentId': 11,
      'title': 'Научно-педагогический состав',
    },
    {
      'id': 14,
      'parentId': 1,
      'title':
          'Материально-техническое обеспечение и оснащенность образовательного процесса',
      'icon': CommunityMaterialIcons.cog_outline,
    },
    {
      'id': 15,
      'parentId': 14,
      'title': 'Учебные кабинеты',
    },
    {
      'id': 16,
      'parentId': 14,
      'title': 'Объекты для проведения практических занятий',
    },
    {
      'id': 17,
      'parentId': 1,
      'title': 'Стипендии и иные виды материальной помощи',
      'icon': CommunityMaterialIcons.account_cash_outline,
    },
    {
      'id': 18,
      'parentId': 1,
      'title': 'Платные образовательные услуги',
      'icon': CommunityMaterialIcons.cart_outline,
    },
    {
      'id': 19,
      'parentId': 18,
      'title': 'Основная образовательная деятельность',
    },
    {
      'id': 20,
      'parentId': 18,
      'title': 'Дополнительная образовательная деятельность',
    },
    {
      'id': 21,
      'parentId': 1,
      'title': 'Финансово-хозяйственная деятельность',
      'icon': CommunityMaterialIcons.anvil,
    },
    {
      'id': 22,
      'parentId': 1,
      'title': 'Вакантные места для приема (перевода)',
      'icon': CommunityMaterialIcons.arrow_decision_outline,
    },
    {
      'id': 23,
      'parentId': 1,
      'title': 'Доступная среда',
      'icon': CommunityMaterialIcons.share,
    },
    {
      'id': 24,
      'parentId': 1,
      'title': 'Международное сотрудничество',
      'icon': CommunityMaterialIcons.earth,
    },
  ];
}
