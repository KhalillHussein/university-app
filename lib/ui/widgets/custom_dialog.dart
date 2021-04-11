import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final Map<String, Object> description;

  const CustomDialog({
    @required this.title,
    @required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            AutoSizeText(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 15),
            ListView.separated(
              separatorBuilder: (context, index) => Divider(
                height: 1.0,
              ),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: description.length,
              itemBuilder: (BuildContext context, int index) {
                final String key = description.keys.elementAt(index);
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: AutoSizeText(
                          key,
                          style: Theme.of(context).dialogTheme.contentTextStyle,
                        ),
                      ),
                      Expanded(
                        child: AutoSizeText(
                          '${description[key]}',
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
