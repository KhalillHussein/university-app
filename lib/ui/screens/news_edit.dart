import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:markdown_editable_textinput/markdown_text_input.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mtusiapp/repositories/news_edit.dart';
import 'package:mtusiapp/ui/widgets/custom_page.dart';
import 'package:mtusiapp/ui/widgets/index.dart';
import 'package:provider/provider.dart';

import 'package:row_collection/row_collection.dart';
import '../../util/extensions.dart';

class CreateNewsScreen extends StatefulWidget {
  static const route = 'news_create';

  @override
  _CreateNewsScreenState createState() => _CreateNewsScreenState();
}

class _CreateNewsScreenState extends State<CreateNewsScreen> {
  final format = DateFormat("yyyy-MM-dd HH:mm");

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SimplePage(
      title: 'Создание',
      actions: [
        Consumer<NewsEditRepository>(
          builder: (ctx, model, _) => IconButton(
            icon: const Icon(Icons.check),
            splashRadius: 20,
            tooltip: 'Публикация',
            onPressed: () async {
              if (_formKey.currentState.validate()) {
                await context.read<NewsEditRepository>().postData();
                if (model.postingFailed) {
                  _showSnackBar(context, model.errorMessage);
                } else {
                  Navigator.pop(context);
                }
              }
            },
          ),
        ),
      ],
      body: Theme(
        data: Theme.of(context).copyWith(
          primaryColor: Theme.of(context).accentColor,
          accentColor: Theme.of(context).dividerColor,
        ),
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10.0),
            children: [
              Consumer<NewsEditRepository>(
                builder: (ctx, model, _) => TextFormField(
                  onChanged: model.changeTitle,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Укажите заголовок';
                    }
                    return null;
                  },
                  style: TextStyle(
                      fontSize: 17,
                      color: Theme.of(context).textTheme.bodyText1.color),
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    errorMaxLines: 2,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(
                          color: Theme.of(context).dividerColor, width: 2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(
                          color: Theme.of(context).dividerColor, width: 2),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(
                          color: Theme.of(context).dividerColor, width: 2),
                    ),
                    hintText: 'Заголовок',
                    hintStyle: Theme.of(context)
                        .textTheme
                        .subtitle1
                        .copyWith(color: Theme.of(context).disabledColor),
                    filled: true,
                    fillColor: Theme.of(context).cardColor,
                  ),

                  // onChanged: (value) => validate.changeCompanyName(value),
                ),
              ),
              Separator.spacer(),
              Consumer<NewsEditRepository>(
                builder: (ctx, model, _) => DateTimeField(
                  initialValue: model.createdAt,
                  format: format,
                  validator: (value) {
                    if (value == null) {
                      return 'Укажите дату';
                    }
                    return null;
                  },
                  onChanged: model.changeDate,
                  decoration: InputDecoration(
                    errorMaxLines: 2,
                    suffixIcon: Icon(Icons.today),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(
                          color: Theme.of(context).dividerColor, width: 2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(
                          color: Theme.of(context).dividerColor, width: 2),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(
                          color: Theme.of(context).dividerColor, width: 2),
                    ),
                    hintText: format.pattern,
                    hintStyle: Theme.of(context)
                        .textTheme
                        .subtitle1
                        .copyWith(color: Theme.of(context).disabledColor),
                    filled: true,
                    fillColor: Theme.of(context).cardColor,
                  ),
                  onShowPicker: (context, currentValue) async {
                    final date = await showDatePicker(
                        context: context,
                        firstDate: DateTime(1900),
                        initialDate: currentValue ?? DateTime.now(),
                        lastDate: DateTime(2100));

                    if (date != null) {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(
                            currentValue ?? DateTime.now()),
                      );
                      return DateTimeField.combine(date, time);
                    } else {
                      return currentValue;
                    }
                  },
                ),
              ),
              Separator.spacer(),
              Consumer<NewsEditRepository>(
                builder: (ctx, model, _) => MarkdownTextInput(
                  model.changeIntoText,
                  model.introText,
                  label: 'Вступление',
                  maxLines: 2,
                  validators: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Поле "Вступление" не должно быть пустым';
                    }
                    return null;
                  },
                ),
              ),
              Separator.spacer(),
              DottedBorder(
                dashPattern: const [6, 6],
                color: Theme.of(context).dividerColor,
                radius: Radius.circular(10),
                padding: EdgeInsets.all(5),
                strokeWidth: 2,
                child: Consumer<NewsEditRepository>(
                    builder: (ctx, model, _) => _buildGridView(model)),
              ),
              Separator.spacer(),
              Consumer<NewsEditRepository>(
                builder: (ctx, model, _) => MarkdownTextInput(
                  model.changeFullText,
                  model.fullText,
                  label: 'Основной текст',
                  maxLines: 8,
                  validators: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Поле "Основной текст" не должно быть пустым';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGridView(NewsEditRepository model) {
    if (model.images.isNotEmpty) {
      return GridView.count(
        shrinkWrap: true,
        crossAxisCount: 6,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
        physics: NeverScrollableScrollPhysics(),
        children: List.generate(
            model.images.length > 30
                ? model.images.length
                : model.images.length + 1, (index) {
          return index >= model.images.length
              ? GestureDetector(
                  onTap: model.getImage,
                  child: Container(
                    width: 300,
                    height: 300,
                    color: Theme.of(context).cardColor,
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.add,
                      color: Theme.of(context).textTheme.caption.color,
                    ),
                  ),
                )
              : Stack(
                  children: [
                    Image.file(
                      model.images[index],
                      fit: BoxFit.cover,
                      width: 300,
                      height: 300,
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () => setState(() {
                          model.images.removeWhere((element) =>
                              element.path == model.images[index].path);
                        }),
                        child: Container(
                          color: Colors.black38,
                          child: Icon(
                            Icons.close,
                            size: 15,
                            color: Theme.of(context).textTheme.caption.color,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
        }),
      );
    } else {
      return InkWell(
        onTap: model.getImage,
        child: Container(
          height: 50,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(
              MdiIcons.fileImageOutline,
              color: Theme.of(context).textTheme.caption.color,
            ),
            Separator.spacer(space: 6),
            Text(
              'Изображения не выбраны',
              style: Theme.of(context).textTheme.caption,
            ).scalable()
          ]),
        ),
      );
    }
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
          duration: const Duration(seconds: 3),
        ),
      );
  }
}
