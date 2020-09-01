import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/news_provider.dart';
import '../models/http_exception.dart';
import '../widgets/reusable_widgets.dart';
import '../providers/schedule_provider.dart';
import '../providers/teacher_provider.dart';

class ErrorScreen extends StatefulWidget {
  final dynamic providerClass;

  ErrorScreen(this.providerClass);

  @override
  _ErrorScreenState createState() => _ErrorScreenState();

  factory ErrorScreen.news(BuildContext context) {
    return ErrorScreen(Provider.of<NewsProvider>(context, listen: false));
  }
  factory ErrorScreen.teacher(BuildContext context) {
    return ErrorScreen(Provider.of<TeacherProvider>(context, listen: false));
  }
  factory ErrorScreen.schedule(BuildContext context) {
    return ErrorScreen(Provider.of<ScheduleProvider>(context, listen: false));
  }
}

class _ErrorScreenState extends State<ErrorScreen> {
  bool _refresh = false;

  Future<void> _reload() async {
    setState(() {
      _refresh = true;
    });
    try {
      await widget.providerClass.fetchAndSetResult();
    } on HttpException catch (error) {
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
//          Icon(
//            CommunityMaterialIcons.cloud_off_outline,
//            color: Colors.grey,
//            size: 90,
//          ),
//          const SizedBox(
//            height: 20,
//          ),
          Text('При загрузке данных произошла ошибка'),
          const SizedBox(
            height: 5,
          ),
          if (_refresh)
            const Padding(
              padding: const EdgeInsets.only(top: 23.0),
              child: const SizedBox(
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
