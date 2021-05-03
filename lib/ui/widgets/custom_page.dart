import 'dart:async';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:big_tip/big_tip.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:row_collection/row_collection.dart';

import '../../repositories/index.dart';
import '../../util/index.dart';
import 'index.dart';

/// Centered [CircularProgressIndicator] widget.
Widget get _loadingIndicator =>
    const Center(child: CircularProgressIndicator());

/// Function which handles reloading [QueryModel] models.
Future<void> _onRefresh(BuildContext context, BaseRepository repository) {
  final Completer<void> completer = Completer<void>();
  repository.refreshData().then((_) {
    if (repository.loadingFailed) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Theme.of(context).errorColor,
            content: Row(
              children: [
                Icon(
                  Icons.error,
                  color: Theme.of(context).primaryColor,
                ),
                Separator.spacer(),
                Expanded(
                  child: Text(
                    repository.errorMessage,
                    softWrap: true,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            duration: const Duration(seconds: 1),
          ),
        );
    }
    completer.complete();
  });
  return completer.future;
}

/// Basic screen.
/// Used when the desired page doesn't have reloading.
class SimplePage extends StatelessWidget {
  final String title;
  final Widget body, fab, leading;
  final PreferredSizeWidget bottom;
  final List<Widget> actions;

  const SimplePage({
    @required this.title,
    @required this.body,
    this.leading,
    this.bottom,
    this.fab,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: leading,
        bottom: bottom,
        title: Text(
          title,
          style: GoogleFonts.rubik(fontWeight: FontWeight.w600),
        ),
        actions: actions,
      ),
      body: body,
      floatingActionButton: fab,
    );
  }
}

/// Basic page which has reloading properties.
/// It uses the [BlankPage] widget inside it.
class ReloadableSimplePage<T extends BaseRepository> extends StatelessWidget {
  final String title;
  final List<Widget> actions;
  final Widget body, fab, placeholder, leading;
  final PreferredSizeWidget bottom;

  const ReloadableSimplePage({
    @required this.title,
    @required this.body,
    this.bottom,
    this.actions,
    this.placeholder,
    this.fab,
    this.leading,
  });

  factory ReloadableSimplePage.tabs({
    @required String title,
    @required Widget body,
    @required VoidCallback leadingCallBack,
    Widget fab,
    Widget placeholder,
    PreferredSizeWidget bottom,
  }) {
    return ReloadableSimplePage(
      bottom: bottom,
      placeholder: placeholder,
      title: title,
      body: body,
      leading: IconButton(
        splashRadius: 20,
        icon: const Icon(MdiIcons.menu),
        onPressed: leadingCallBack,
      ),
      fab: fab,
      actions: [
        ThemeSwitchIcon(),
        IconButton(
          splashRadius: 20,
          icon: const Icon(MdiIcons.cogOutline),
          onPressed: null,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SimplePage(
      bottom: bottom,
      actions: actions,
      title: title,
      fab: fab,
      leading: leading,
      body: Consumer<T>(
        builder: (context, model, child) => RefreshIndicator(
          onRefresh: () => _onRefresh(context, model),
          child: model.isLoading
              ? placeholder ?? _loadingIndicator
              : model.loadingFailed && model.list.isEmpty
                  ? ChangeNotifierProvider.value(
                      value: model,
                      child: ConnectionError<T>(),
                    )
                  : model.databaseFetch
                      ? Stack(
                          children: [
                            body,
                            Positioned(
                              bottom: 0.0,
                              left: 0.0,
                              right: 0.0,
                              child: ChangeNotifierProvider.value(
                                value: model,
                                child: Message<T>(),
                              ),
                            ),
                          ],
                        )
                      : body,
        ),
      ),
    );
  }
}

/// Widget used to display a connection error message.
/// It allows user to reload the page with a simple button.
class ConnectionError<T extends BaseRepository> extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<T>(
      builder: (context, model, child) => BigTip(
        title: Text(
          'При загрузке данных что-то пошло не так',
          style:
              GoogleFonts.rubikTextTheme(Theme.of(context).textTheme).subtitle1,
        ),
        subtitle: TextButton(
          onPressed: () async => _onRefresh(context, model),
          child: Text(
            'Повторить попытку',
            style: GoogleFonts.rubikTextTheme(Theme.of(context).textTheme)
                .subtitle1
                .copyWith(
                  color: Theme.of(context).accentColor,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        child: const Icon(Icons.cloud_off),
      ),
    );
  }
}

class Message<T extends BaseRepository> extends StatefulWidget {
  @override
  _MessageState<T> createState() => _MessageState<T>();
}

class _MessageState<T extends BaseRepository> extends State<Message<T>> {
  bool isShowing = true;

  @override
  Widget build(BuildContext context) {
    return Consumer<T>(
      builder: (ctx, model, _) => isShowing
          ? MaterialBanner(
              backgroundColor: Theme.of(context).brightness == Brightness.light
                  ? Colors.blue[50]
                  : k04dp,
              leading: Icon(
                MdiIcons.cloudOffOutline,
                size: 20,
                color: Theme.of(context).disabledColor,
              ),
              actions: [
                TextButton(
                  onPressed: () => setState(() => isShowing = false),
                  child: Text(
                    'СКРЫТЬ',
                    style: GoogleFonts.rubikTextTheme(
                      Theme.of(context).textTheme,
                    ).overline.copyWith(
                          color: Theme.of(context).accentColor,
                          fontWeight: FontWeight.w400,
                        ),
                    textScaleFactor: 1.5,
                  ),
                ),
              ],
              content: FittedBox(
                child: Text(
                  'Сохраненная копия за ${DateFormat('yyyy.MM.dd - HH:mm', 'Ru').format(model.timestamp)}',
                  style: Theme.of(context).textTheme.caption,
                ),
              ),
            )
          : SizedBox(),
    );
  }
}
