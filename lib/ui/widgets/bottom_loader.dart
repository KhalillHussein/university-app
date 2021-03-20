import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../repositories/index.dart';

class BottomLoader<T extends BaseRepository> extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      elevation: 1,
      margin: const EdgeInsets.all(10.0),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Consumer<T>(
            builder: (ctx, model, child) => model.loadingFailed
                ? GestureDetector(
                    onTap: () => model.loadData(),
                    child: const Text('Повторите попытку'),
                  )
                : child,
            child: const SizedBox(
              width: 20,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: CircularProgressIndicator(
                  strokeWidth: 6,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
