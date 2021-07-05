import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dio/dio.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:path_provider/path_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:row_collection/row_collection.dart';

import '../../../providers/index.dart';
import '../../../repositories/changelog.dart';
import '../../../services/changelog.dart';
import '../../../util/index.dart';
import '../../widgets/index.dart';
import '../screens/changelog.dart';

class SettingsScreen extends StatelessWidget {
  static const route = '/settings';

  @override
  Widget build(BuildContext context) {
    final service = Dio();
    return BasicPage(
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
            onTap: () => _buildTextSettingsDialog(context),
          ),
          _buildSettingsTile(
            context,
            icon: MdiIcons.imageAutoAdjust,
            title: 'Качество изображений',
            subtitle: 'Степень сжатия изображений',
            onTap: () => showBottomDialog(
              context: context,
              title: 'КАЧЕСТВО ИЗОБРАЖЕНИЙ',
              padding: EdgeInsets.zero,
              children: <Widget>[
                RadioListTile<ImageQuality>(
                  title: const Text('Низкое'),
                  value: ImageQuality.low,
                  selected: context.read<ImageQualityProvider>().imageQuality ==
                      ImageQuality.low,
                  activeColor: Theme.of(context).accentColor,
                  selectedTileColor:
                      Theme.of(context).accentColor.withOpacity(0.1),
                  groupValue: context.read<ImageQualityProvider>().imageQuality,
                  onChanged: (value) => _changeImageQuality(context, value),
                ),
                RadioListTile<ImageQuality>(
                  title: const Text('Среднее'),
                  activeColor: Theme.of(context).accentColor,
                  value: ImageQuality.medium,
                  selected: context.read<ImageQualityProvider>().imageQuality ==
                      ImageQuality.medium,
                  selectedTileColor:
                      Theme.of(context).accentColor.withOpacity(0.1),
                  groupValue: context.read<ImageQualityProvider>().imageQuality,
                  onChanged: (value) => _changeImageQuality(context, value),
                ),
                RadioListTile<ImageQuality>(
                  title: const Text('Высокое'),
                  value: ImageQuality.high,
                  activeColor: Theme.of(context).accentColor,
                  selected: context.read<ImageQualityProvider>().imageQuality ==
                      ImageQuality.high,
                  selectedTileColor:
                      Theme.of(context).accentColor.withOpacity(0.1),
                  groupValue: context.read<ImageQualityProvider>().imageQuality,
                  onChanged: (value) => _changeImageQuality(context, value),
                ),
                Separator.spacer(space: 24),
              ],
            ),
          ),
          HeaderText(
            'Данные',
          ),
          _buildSettingsTile(
            context,
            icon: Icons.cleaning_services,
            title: 'Удаление данных',
            subtitle: 'Удаление временных файлов',
            onTap: () => showModalDialog(
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
            title: 'Версия 0.9.4 beta',
            subtitle: 'Просмотр списка изменений',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ChangeNotifierProvider<ChangelogRepository>(
                  create: (context) => ChangelogRepository(
                    ChangelogService(service),
                  ),
                  child: ChangelogScreen(),
                ),
                fullscreenDialog: true,
              ),
            ),
          ),
          _buildSettingsTile(
            context,
            icon: Icons.email,
            title: 'Напишите нам',
            subtitle: 'Сообщения о найденных ошибках, запрос новых функций',
            isThreeLine: true,
            onTap: () => showModalDialog(context,
                title: 'Перед отправкой',
                contentWidget: MarkdownBody(
                  data: messageRequirements,
                  listItemCrossAxisAlignment:
                      MarkdownListItemCrossAxisAlignment.start,
                  styleSheet:
                      MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                    blockSpacing: 10,
                    strong:
                        GoogleFonts.rubikTextTheme(Theme.of(context).textTheme)
                            .subtitle1
                            .copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                    p: GoogleFonts.rubikTextTheme(Theme.of(context).textTheme)
                        .bodyText2,
                  ),
                ), onPressed: () {
              _launchURL(
                context,
                'mailto:Informationtecnologies@yandex.ru',
              );
              Navigator.pop(context);
            }),
          ),
        ],
      ),
    );
  }

  // Updates image quality setting
  Future<void> _changeImageQuality(
      BuildContext context, ImageQuality quality) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Saves new settings
    context.read<ImageQualityProvider>().imageQuality = quality;
    prefs.setInt('quality', quality.index);

    // Hides dialog
    Navigator.of(context).pop();
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

  Future<void> _buildTextSettingsDialog(BuildContext context) {
    return showBottomDialog(
      context: context,
      title: 'МАСШТАБИРОВАНИЕ ТЕКСТА',
      children: [
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
                          padding: const EdgeInsets.only(right: 3.0),
                          child: Text(
                            '${(scale.scaleFactor * 100).round()}%',
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ),
                      ),
                      TextSpan(
                        text: (scale.scaleFactor * 100).round() ==
                                initialScale * 100
                            ? '(Масштаб по умолчанию)'
                            : '(Пользовательский масштаб)',
                        style: Theme.of(context).textTheme.caption,
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
              color: Theme.of(context).textTheme.caption.color,
            ),
            Expanded(
              child: Consumer<TextScaleProvider>(
                builder: (ctx, scale, _) => Slider.adaptive(
                  min: 0.8,
                  max: 1.5,
                  value: scale.scaleFactor,
                  activeColor: Theme.of(context).accentColor,
                  inactiveColor: Colors.black12,
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
              color: Theme.of(context).textTheme.caption.color,
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              border: Border.all(
                color: Theme.of(context).dividerColor,
                width: 2,
              )),
          child: Text(
            'Перемещайте ползунок, пока текст не станет удобным для чтения.',
            textScaleFactor: 0.85,
            style: Theme.of(context).textTheme.subtitle1.copyWith(
                  height: 1.3,
                  letterSpacing: 0.15,
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.black87
                      : Colors.white.withOpacity(0.9),
                ),
          ).scalable(),
        ),
      ],
    );
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
