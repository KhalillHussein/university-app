import 'dart:ui';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:row_collection/row_collection.dart';

import '../../../models/index.dart';
import '../../../providers/index.dart';
import '../../../repositories/index.dart';
import '../../../util/index.dart';
import '../../widgets/index.dart';
import '../pages/index.dart';
import '../screens/index.dart';

class AccountTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final notify = context.read<NotificationsRepository>();
    return Consumer<AuthRepository>(
      builder: (ctx, userData, _) => BasicPage(
        title: 'Аккаунт',
        actions: [
          Consumer<NotificationsRepository>(
            builder: (ctx, model, _) => IconButton(
              splashRadius: 20,
              tooltip: 'Уведомления',
              icon: Icon(
                model.isNotify ? MdiIcons.bell : MdiIcons.bellOff,
                size: 25,
              ),
              color: model.isNotify
                  ? Theme.of(context).accentColor
                  : Theme.of(context).textTheme.caption.color,
              onPressed: model.isLoading
                  ? null
                  : () => model.isNotify
                      ? model.disableNotifications().then(
                            (value) => _showSnackBar(
                              context,
                              model.loadingFailed
                                  ? model.errorMessage
                                  : 'Все уведомления отключены.',
                              color: model.loadingFailed
                                  ? Theme.of(context).errorColor
                                  : Theme.of(context).textTheme.caption.color,
                            ),
                          )
                      : model.loadData().then(
                            (value) => _showSnackBar(
                              context,
                              model.loadingFailed
                                  ? model.errorMessage
                                  : 'Уведомления о новостях и расписании успешно подключены.',
                              color: model.loadingFailed
                                  ? Theme.of(context).errorColor
                                  : Theme.of(context).textTheme.caption.color,
                            ),
                          ),
            ),
          ),
          IconButton(
            splashRadius: 20,
            icon: const Icon(
              MdiIcons.email,
              size: 25,
            ),
            onPressed: null,
          ),
          PopupMenuButton<String>(
              tooltip: 'Еще',
              itemBuilder: (context) => [
                    PopupMenuItem(
                        value: 'Выход',
                        child: Row(
                          children: [
                            const Icon(Icons.exit_to_app),
                            Separator.spacer(),
                            const Text('Выход').scalable(),
                          ],
                        )),
                    PopupMenuItem(
                        value: 'Настройки',
                        child: Row(
                          children: [
                            const Icon(Icons.settings_outlined),
                            Separator.spacer(),
                            const Text('Настройки').scalable(),
                          ],
                        )),
                  ],
              onSelected: (text) {
                switch (text) {
                  case 'Выход':
                    showModalDialog(context,
                        title: 'Выход',
                        content:
                            'При выходе из учетной записи будут удалены все связанные с нею данные.',
                        onPressed: () async {
                      await notify.disableNotifications();
                      userData.logout();
                      Navigator.of(ctx).pop();
                    });
                    break;
                  case 'Настройки':
                    Navigator.pushNamed(context, SettingsScreen.route);
                    break;
                }
              }),
        ],
        body: userData.user.getUserPosition() == Positions.student
            ? _Student()
            : userData.user.getUserPosition() == Positions.lecturer
                ? _Lecturer()
                : userData.user.getUserPosition() == Positions.admin
                    ? _Master()
                    : const Center(
                        child: Text('Отсутствуют данные для просмотра'),
                      ),
      ).contentTab<AuthRepository>(context),
    );
  }

  void _showSnackBar(BuildContext context, String message,
      {Color color, IconData icon}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: color ?? Theme.of(context).errorColor,
          content: icon != null
              ? Row(
                  children: [
                    Icon(
                      icon,
                      color: Theme.of(context).primaryColor,
                    ),
                    Separator.spacer(),
                    Expanded(
                      child: Text(
                        message,
                        softWrap: true,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ).scalable(),
                    ),
                  ],
                )
              : Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text(
                    message,
                    softWrap: true,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ).scalable(),
                ),
          duration: const Duration(seconds: 2),
        ),
      );
  }
}

class _Student extends StatelessWidget {
  List<Map<String, dynamic>> _tabs(BuildContext context) {
    return [
      {
        'tab': 'УСПЕВАЕМОСТЬ',
        'page': Progress(),
      },
      {
        'tab': 'ЗАЧЕТКА',
        'page': RecordBookPage(),
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            color: Theme.of(context).primaryColor,
            child: TabBar(
              labelColor: Theme.of(context).accentColor,
              unselectedLabelColor: Theme.of(context).textTheme.caption.color,
              tabs: <Widget>[
                for (final item in _tabs(context))
                  Tab(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        item['tab'],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: <Widget>[
                for (final item in _tabs(context))
                  Tab(
                    child: item['page'],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Master extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildCardSection(
              context,
              title: 'Новости',
              subtitle: 'Создание новости',
              icon: MdiIcons.newspaperVariantMultipleOutline,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewsCreateScreen(),
                  fullscreenDialog: true,
                ),
              ),
            ),
            _buildCardSection(
              context,
              title: 'Расписание',
              subtitle: 'Загрузка расписания',
              icon: MdiIcons.archiveAlertOutline,
              onTap: () async => _showBottomDialog(context),
            ),
            _buildCardSection(
              context,
              title: 'Преподаватели',
              subtitle: 'Просмотр преподавателей',
              icon: MdiIcons.accountTie,
            ),
            _buildCardSection(
              context,
              title: 'Аккаунты',
              subtitle: 'Управление аккаунтами',
              icon: MdiIcons.accountGroupOutline,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showBottomDialog(BuildContext context) {
    return showBottomDialog(
      context: context,
      title: 'ЗАГРУЗКА РАСПИСАНИЯ',
      children: [
        Consumer<TimetableUploadProvider>(
          builder: (ctx, uploader, _) => TextFormField(
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: 'Название*',
              filled: true,
              hintText: 'Что было изменено?',
              helperText: 'Краткое название. Не будьте многословны',
              errorText: uploader.title.error,
              errorMaxLines: 1,
            ),
            onChanged: (value) => uploader.changeTitle(value),
          ),
        ),
        Separator.spacer(space: 16),
        Consumer<TimetableUploadProvider>(
          builder: (ctx, uploader, _) => TextFormField(
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              hintText: 'Каких групп коснулись изменения?',
              labelText: 'Описание*',
              helperText: 'Краткое описание. Не будьте многословны',
              filled: true,
              errorText: uploader.description.error,
              errorMaxLines: 1,
            ),
            onChanged: (value) => uploader.changeDescription(value),
          ),
        ),
        Separator.spacer(space: 16),
        DottedBorder(
          dashPattern: const [6, 6],
          color: Theme.of(context).dividerColor,
          radius: const Radius.circular(10),
          strokeWidth: 2,
          child: InkWell(
            onTap: context.read<TimetableUploadProvider>().openFileExplorer,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Consumer<TimetableUploadProvider>(
                builder: (ctx, uploader, _) => Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    uploader.filePicked
                        ? Icon(
                            Icons.file_present,
                            color: Theme.of(context).textTheme.caption.color,
                            size: 40,
                          )
                        : Icon(
                            Icons.upload_sharp,
                            color: Theme.of(context).textTheme.caption.color,
                            size: 40,
                          ),
                    Separator.spacer(space: 4),
                    uploader.filePicked
                        ? Text(
                            'Файл выбран',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.caption,
                          )
                        : Text(
                            'Нажмите сюда, чтобы выбрать DBF файл',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.caption,
                          ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Separator.spacer(),
        Consumer2<TimetableUploadRepository, TimetableUploadProvider>(
          builder: (ctx, model, provider, _) => ElevatedButton(
            onPressed: model.isLoading || !provider.isFormValid
                ? null
                : () async {
                    model.formData =
                        context.read<TimetableUploadProvider>().toMap();
                    await context.read<TimetableUploadRepository>().loadData();
                    context.read<TimetableRepository>().refreshData();
                    Navigator.pop(context);
                  },
            child: model.isLoading
                ? _buildLoadingSpinner(context)
                : const Text('Загрузить файл'),
          ),
        ),
      ],
    ).whenComplete(context.read<TimetableUploadProvider>().cleanSelectable);
  }

  Widget _buildLoadingSpinner(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Center(
        heightFactor: 1,
        widthFactor: 1,
        child: SizedBox(
          height: 10,
          width: 10,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            valueColor: AlwaysStoppedAnimation<Color>(
              Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardSection(
    BuildContext context, {
    @required String title,
    @required String subtitle,
    @required IconData icon,
    VoidCallback onTap,
  }) {
    return Card(
      elevation: 3.0,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(3.0),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(3.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 25),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.rubikTextTheme(
                        Theme.of(context).textTheme,
                      ).headline5.copyWith(
                            color: onTap != null
                                ? Theme.of(context).textTheme.headline5.color
                                : Theme.of(context).disabledColor,
                          ),
                    ).scalable(),
                    Separator.spacer(space: 3),
                    Text(
                      subtitle,
                      style: GoogleFonts.rubikTextTheme(
                        Theme.of(context).textTheme,
                      ).caption.copyWith(
                            height: 1.2,
                            letterSpacing: 0.3,
                            color: onTap != null
                                ? Theme.of(context).textTheme.caption.color
                                : Theme.of(context).disabledColor,
                          ),
                      textScaleFactor: 1.1,
                    ).scalable(),
                  ],
                ),
              ),
              Icon(
                icon,
                size: 45,
                color: onTap != null
                    ? Theme.of(context).iconTheme.color
                    : Theme.of(context).disabledColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Lecturer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Container(
        color: Theme.of(context).cardTheme.color,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TabBar(
                tabs: <Widget>[
                  Tab(
                    child: const Text(
                      'РАСПИСАНИЕ ЗАНЯТИЙ',
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      softWrap: true,
                    ).scalable(),
                  ),
                  Tab(
                    child: Text('МРС').scalable(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Center(child: Text('МРС').scalable()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
