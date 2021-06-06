import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:row_collection/row_collection.dart';

import '../../repositories/index.dart';

class BottomLoader<T extends BaseRepository> extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      elevation: 3,
      margin: const EdgeInsets.all(10.0),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Consumer<T>(
            builder: (ctx, model, child) => model.loadingFailed
                ? TextButton(
                    onPressed: () async {
                      await model.loadData();
                      if (model.loadingFailed) {
                        _showSnackBar(context, model.errorMessage);
                      }
                    },
                    child: Text(
                      'Повторите попытку',
                      style: Theme.of(context).textTheme.bodyText2.copyWith(
                            color: Theme.of(context).accentColor,
                          ),
                      textScaleFactor: 1.2,
                    ),
                  )
                : child,
            child: SizedBox(
              width: 20,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation(Theme.of(context).accentColor),
                  strokeWidth: 6,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
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
                  message,
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
}
