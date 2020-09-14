import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/news_provider.dart';
import '../../models/http_exception.dart';
import '../widgets/reusable_widgets.dart';
import '../../providers/schedule_provider.dart';
import '../../providers/lecturer_provider.dart';

class ErrorPage extends StatefulWidget {
  final dynamic providerClass;

  ErrorPage(this.providerClass);

  @override
  _ErrorPageState createState() => _ErrorPageState();

  factory ErrorPage.news(BuildContext context) {
    return ErrorPage(Provider.of<NewsProvider>(context, listen: false));
  }

  factory ErrorPage.teacher(BuildContext context) {
    return ErrorPage(Provider.of<LecturerProvider>(context, listen: false));
  }

  factory ErrorPage.schedule(BuildContext context) {
    return ErrorPage(Provider.of<ScheduleProvider>(context, listen: false));
  }
}

class _ErrorPageState extends State<ErrorPage> {
  bool _refresh = false;

  Future<void> _reload() async {
    setState(() {
      _refresh = true;
    });
    try {
      await widget.providerClass.fetchAndSetResult();
    } on HttpException catch (_) {
      Scaffold.of(context).hideCurrentSnackBar();
      Scaffold.of(context).showSnackBar(buildSnackBar(context));
    } catch (error) {
      Scaffold.of(context).hideCurrentSnackBar();
      Scaffold.of(context).showSnackBar(buildSnackBar(context));
    }
    setState(() {
      _refresh = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text('При загрузке данных произошла ошибка'),
          const SizedBox(height: 5),
          if (_refresh)
            const Padding(
              padding: EdgeInsets.only(top: 23.0),
              child: SizedBox(
                height: 25.0,
                width: 25.0,
                child: CircularProgressIndicator(strokeWidth: 3.0),
              ),
            ),
          if (!_refresh)
            FlatButton(
              onPressed: _reload,
              textColor: Theme.of(context).accentColor,
              child: const Text('Повторить'),
            ),
        ],
      ),
    );
  }
}
