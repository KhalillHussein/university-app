import 'dart:convert';

import 'package:delta_markdown/delta_markdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:dotted_border/dotted_border.dart';

import 'package:row_collection/row_collection.dart';
import 'package:provider/provider.dart';

import '../../../providers/index.dart';
import '../../../repositories/index.dart';
import '../../../util/index.dart';
import '../../widgets/index.dart';

class NewsCreateScreen extends StatefulWidget {
  static const route = 'news_create';

  @override
  _NewsCreateScreenState createState() => _NewsCreateScreenState();
}

class _NewsCreateScreenState extends State<NewsCreateScreen> {
  final format = DateFormat("yyyy-MM-dd HH:mm");

  @override
  Widget build(BuildContext context) {
    return BasicPage(
      title: 'Создание новости',
      leading: IconButton(
          icon: Icon(Icons.close),
          splashRadius: 20,
          tooltip: 'Закрыть',
          onPressed: () {
            context.read<NewsCreateProvider>().clearFields();
            Navigator.pop(context);
          }),
      actions: [
        Consumer2<NewsCreateRepository, NewsCreateProvider>(
            builder: (ctx, model, provider, _) => model.isLoading
                ? _buildLoadingSpinner()
                : IconButton(
                    icon: const Icon(Icons.check),
                    splashRadius: 20,
                    tooltip: 'Публикация',
                    onPressed: () async {
                      provider.title = quillDeltaToMarkdown(
                          _titleController.document.toDelta());
                      provider.introText = quillDeltaToMarkdown(
                          _introController.document.toDelta());
                      provider.fullText = quillDeltaToMarkdown(
                          _bodyController.document.toDelta());
                      model.formData =
                          context.read<NewsCreateProvider>().toMap();

                      await model.loadData();
                      if (model.loadingFailed) {
                        _showSnackBar(context, model.errorMessage);
                      } else {
                        context.read<NewsCreateProvider>().clearFields();
                        context.read<NewsRepository>().refreshData();
                        Navigator.pop(context);
                      }
                    })),
      ],
      body: Theme(
        data: Theme.of(context).copyWith(
          primaryColor: Theme.of(context).accentColor,
          accentColor: Theme.of(context).dividerColor,
        ),
        child: KeyboardActions(
          config: _buildConfig(context),
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height -
                  (MediaQuery.of(context).padding.top + kToolbarHeight * 2),
              padding:
                  const EdgeInsets.symmetric(vertical: 15, horizontal: 15.0),
              child: Column(
                children: [
                  Expanded(flex: 2, child: _buildTitleTextField()),
                  Separator.spacer(),
                  _buildDatePickerTextField(),
                  Expanded(flex: 3, child: _buildNewsIntroTextField()),
                  Separator.spacer(),
                  DottedBorder(
                    dashPattern: const [6, 6],
                    color: Theme.of(context).dividerColor,
                    radius: const Radius.circular(10),
                    strokeWidth: 2,
                    child: Consumer<NewsCreateProvider>(
                        builder: (ctx, model, _) =>
                            _buildSelectedImages(model)),
                  ),
                  Separator.spacer(),
                  Expanded(flex: 6, child: _buildNewsFullTextField()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingSpinner() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Center(
        heightFactor: 1,
        widthFactor: 1,
        child: SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).iconTheme.color),
          ),
        ),
      ),
    );
  }

  Widget _buildTitleTextField() {
    return Consumer<NewsCreateProvider>(
      builder: (ctx, model, _) => quill.QuillEditor(
        controller: _titleController,
        scrollController: ScrollController(),
        scrollable: true,
        focusNode: _titleFocusNode,
        autoFocus: false,
        readOnly: false,
        placeholder: 'Заголовок',
        expands: true,
        padding: EdgeInsets.zero,
      ),
    );
  }

  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardBarColor: Colors.grey[200],
      actions: [
        KeyboardActionsItem(
          focusNode: _bodyFocusNode,
          displayActionBar: false,
          footerBuilder: (ctx) => PreferredSize(
            preferredSize: Size.fromHeight(56.0),
            child: Theme(
              data: Theme.of(context).copyWith(
                toggleableActiveColor: Theme.of(context).dividerColor,
                primaryColor: Theme.of(context).accentColor,
                accentColor: Theme.of(context).dividerColor,
              ),
              child: quill.QuillToolbar.basic(
                controller: _bodyController,
                multiRowsDisplay: false,
                toolbarIconSize: 25,
                showStrikeThrough: false,
                showBackgroundColorButton: false,
                showColorButton: false,
                showUnderLineButton: false,
                showListCheck: false,
                showCodeBlock: false,
                showHistory: false,
                showQuote: false,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDatePickerTextField() {
    return Consumer<NewsCreateProvider>(
      builder: (ctx, model, _) => DateTimeField(
        style: Theme.of(context).textTheme.subtitle1.copyWith(fontSize: 20),
        initialValue: model.createdAt = DateTime.now(),
        format: format,
        onChanged: model.changeDate,
        decoration: InputDecoration(
          errorMaxLines: 2,
          contentPadding: EdgeInsets.zero,
          suffixIcon: Icon(
            Icons.today,
            size: 25,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent, width: 0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent, width: 0),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent, width: 0),
          ),
          hintText: format.pattern,
          hintStyle: Theme.of(context)
              .textTheme
              .subtitle1
              .copyWith(color: Theme.of(context).disabledColor),
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
              initialTime:
                  TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
            );
            return DateTimeField.combine(date, time);
          } else {
            return currentValue;
          }
        },
      ),
    );
  }

  final quill.QuillController _titleController = quill.QuillController.basic();
  final quill.QuillController _introController = quill.QuillController.basic();
  final quill.QuillController _bodyController = quill.QuillController.basic();

  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _introFocusNode = FocusNode();
  final FocusNode _bodyFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  String quillDeltaToMarkdown(quill.Delta delta) {
    final convertedValue = jsonEncode(delta.toJson());
    final markdown = deltaToMarkdown(convertedValue);
    return markdown;
  }

  Widget _buildNewsIntroTextField() {
    return Consumer<NewsCreateProvider>(
      builder: (ctx, model, _) => quill.QuillEditor(
        controller: _introController,
        scrollController: ScrollController(),
        scrollable: true,
        focusNode: _introFocusNode,
        autoFocus: false,
        readOnly: false,
        placeholder: 'Вступление',
        expands: true,
        padding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildNewsFullTextField() {
    return Consumer<NewsCreateProvider>(
      builder: (ctx, model, _) => quill.QuillEditor(
        controller: _bodyController,
        scrollController: ScrollController(),
        scrollable: true,
        focusNode: _bodyFocusNode,
        autoFocus: false,
        readOnly: false,
        placeholder: 'Основной текст',
        expands: true,
        padding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildSelectedImages(NewsCreateProvider model) {
    if (model.images.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.all(4.0),
        child: GridView.count(
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
        ),
      );
    } else {
      return InkWell(
        onTap: model.getImage,
        child: Container(
          height: 68,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(
              MdiIcons.fileImageOutline,
              color: Theme.of(context).textTheme.caption.color,
            ),
            Separator.spacer(space: 6),
            Text(
              'Выбрать изображения',
              style: Theme.of(context).textTheme.caption,
              textScaleFactor: 1.2,
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
