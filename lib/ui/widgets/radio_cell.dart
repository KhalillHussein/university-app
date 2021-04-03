import 'package:flutter/material.dart';

class RadioCell<T> extends StatelessWidget {
  final T value;
  final T groupValue;
  final String label;
  final ValueChanged<T> onChanged;

  const RadioCell({
    Key key,
    @required this.value,
    @required this.groupValue,
    @required this.label,
    @required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Radio(
          value: value,
          activeColor: Theme.of(context).primaryColor,
          hoverColor: Theme.of(context).primaryColor,
          groupValue: groupValue,
          onChanged: (value) => onChanged(value),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.subtitle1,
        ),
      ],
    );
  }
}
