import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mtusiapp/providers/index.dart';
import 'package:mtusiapp/ui/widgets/custom_page.dart';
import 'package:mtusiapp/ui/widgets/dialogs.dart';
import 'package:mtusiapp/ui/widgets/header_text.dart';
import 'package:mtusiapp/ui/widgets/index.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:row_collection/row_collection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../util/index.dart';

class SettingsScreen extends StatelessWidget {
  static const route = '/settings';

  @override
  Widget build(BuildContext context) {
    return SimplePage(
      title: 'Настройки',
      body: ListView(
        children: [
          HeaderText(
            'Общие настройки',
            head: true,
          ),
          _buildSettingsTile(
            context,
            icon: MdiIcons.formatLetterCase,
            title: 'Масштабирование текста',
            subtitle: 'Изменение масштаба текста',
            onTap: () => showBottomDialog(
              context: context,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Separator.spacer(space: 25),
                    Text(
                      'МАСШТАБИРОВАНИЕ ТЕКСТА',
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.headline6.copyWith(
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.2,
                          ),
                      textScaleFactor: 0.9,
                    ).scalable(),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Separator.spacer(),
                          Consumer<TextScaleProvider>(
                            builder: (ctx, scale, _) => Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        WidgetSpan(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 3.0),
                                            child: Text(
                                              '${(scale.scaleFactor * 100).round()}%',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .caption,
                                            ),
                                          ),
                                        ),
                                        TextSpan(
                                          text: (scale.scaleFactor * 100)
                                                      .round() ==
                                                  initialScale * 100
                                              ? '(Масштаб по умолчанию)'
                                              : '(Пользовательский масштаб)',
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption,
                                        ),
                                      ],
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    textScaleFactor: 1.15,
                                  ).scalable(),
                                ),
                                TextButton(
                                    onPressed: () => _changeTextScale(
                                          context,
                                          scaleFactor: initialScale,
                                        ),
                                    style: TextButton.styleFrom(
                                      primary: Theme.of(context).accentColor,
                                    ),
                                    child: const Text('Сброс').scalable())
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Icon(
                                MdiIcons.formatLetterCase,
                                size: 18,
                                color:
                                    Theme.of(context).textTheme.caption.color,
                              ),
                              Expanded(
                                child: Consumer<TextScaleProvider>(
                                  builder: (ctx, scale, _) => Slider.adaptive(
                                    min: 0.8,
                                    max: 1.5,
                                    value: scale.scaleFactor,
                                    activeColor: Theme.of(context).accentColor,
                                    inactiveColor: Colors.black26,
                                    onChanged: scale.setScaleFactor,
                                    onChangeEnd: (val) => _changeTextScale(
                                      context,
                                      scaleFactor: val,
                                    ),
                                  ),
                                ),
                              ),
                              Icon(
                                MdiIcons.formatLetterCase,
                                size: 28,
                                color:
                                    Theme.of(context).textTheme.caption.color,
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                border: Border.all(
                                  color: Theme.of(context).dividerColor,
                                  width: 2,
                                )),
                            child: Text(
                              'Перемещайте ползунок, пока текст не станет удобным для чтения.',
                              textScaleFactor: 0.85,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  .copyWith(
                                    height: 1.3,
                                    letterSpacing: 0.15,
                                    color: Theme.of(context).brightness ==
                                            Brightness.light
                                        ? Colors.black87
                                        : Colors.white.withOpacity(0.9),
                                  ),
                            ).scalable(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          _buildSettingsTile(
            context,
            icon: Icons.notification_important,
            title: 'Уведомления',
            subtitle: 'Выбор отображаемых уведомлений',
            onTap: AppSettings.openNotificationSettings,
          ),
          HeaderText(
            'Данные',
          ),
          _buildSettingsTile(
            context,
            icon: Icons.cleaning_services,
            title: 'Удаление данных',
            subtitle:
                'Освободить место на устройстве, путем удаления временных файлов и папок',
            isThreeLine: true,
            onTap: () => _showDialog(
              context,
              title: 'Удалить данные?',
              content: 'Будут удалены кэшированные данные приложения.',
              onPressed: () async {
                await _deleteCacheDir();
                await _deleteAppDir();
                Navigator.pop(context);
              },
            ),
          ),
          HeaderText(
            'О приложении',
          ),
          _buildSettingsTile(
            context,
            icon: Icons.info,
            title: 'Версия 0.9.3',
            subtitle: 'Просмотр изменений',
          ),
          _buildSettingsTile(
            context,
            icon: Icons.email,
            title: 'Напишите нам',
            subtitle: 'Сообщения о найденных ошибках, запрос новых функций',
            isThreeLine: true,
            onTap: () => _showDialog(
              context,
              title: 'Перед отправкой',
              content:
                  '[BUG] в заголовке сообщения, если сообщение об ошибке,\n[FEATURE] в заголовке сообщения, если предложение новых функций. В сообщении об ошибке помимо самой ошибки, необходимо указать модель телефона, версию Android и сценарий ее появления.',
              onPressed: () => _launchURL(
                context,
                'mailto:Informationtecnologies@yandex.ru',
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDialog(
    BuildContext context, {
    String title,
    String content,
    VoidCallback onPressed,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).appBarTheme.color,
        title: Text(
          title,
        ).scalable(),
        content: Text(
          content,
        ).scalable(),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              primary: Theme.of(context).disabledColor,
            ),
            onPressed: Navigator.of(ctx).pop,
            child: const Text(
              'ОТМЕНА',
            ).scalable(),
          ),
          TextButton(
            onPressed: onPressed,
            child: const Text(
              'ОК',
            ).scalable(),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteAppDir() async {
    final appDir = await getApplicationSupportDirectory();
    if (appDir.existsSync()) {
      appDir.deleteSync(recursive: true);
    }
  }

  Future<void> _deleteCacheDir() async {
    final Directory tempDir = await getTemporaryDirectory();
    final Directory libCacheDir =
        Directory('${tempDir.path}/libCachedImageData');
    if (libCacheDir.existsSync()) {
      await libCacheDir.delete(recursive: true);
    }
  }

  Future<void> _launchURL(BuildContext context, String url) async {
    try {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'На Вашем устройстве не найден почтовый клиент для отправки';
      }
    } catch (error) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Theme.of(context).errorColor,
            content: Text(
              error.toString(),
              style: Theme.of(context).snackBarTheme.contentTextStyle,
            ),
            duration: const Duration(seconds: 1),
          ),
        );
    }
  }

  Widget _buildSettingsTile(
    BuildContext context, {
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
    bool isThreeLine = false,
  }) {
    return ListTile(
      onTap: onTap,
      isThreeLine: isThreeLine,
      horizontalTitleGap: 10,
      leading: Transform.translate(
        offset: Offset(0, 4),
        child: Icon(
          icon,
          size: 25,
          color: Theme.of(context).textTheme.caption.color,
        ),
      ),
      title: Text(
        title,
        style: GoogleFonts.rubikTextTheme(
          Theme.of(context).textTheme,
        ).bodyText1,
        textScaleFactor: 1.1,
      ).scalable(),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.rubikTextTheme(
          Theme.of(context).textTheme,
        ).caption,
        textScaleFactor: 1.1,
      ).scalable(),
      trailing: Icon(
        Icons.arrow_forward_ios_outlined,
        size: 15,
        color: Theme.of(context).textTheme.caption.color,
      ),
    );
  }

  Future<void> _changeTextScale(BuildContext context,
      {double scaleFactor}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Saves new settings
    context.read<TextScaleProvider>().setScaleFactor(scaleFactor);
    prefs.setDouble('scale', scaleFactor);
  }
}