import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:provider/provider.dart';
import 'package:row_collection/row_collection.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../providers/index.dart';
import '../../repositories/index.dart';
import '../../util/index.dart';
import '../widgets/index.dart';

class InquiriesScreen extends StatelessWidget {
  static const route = '/inquiries';

  final _RuNumberTextInputFormatter _phoneNumberFormatter =
      _RuNumberTextInputFormatter();

  @override
  Widget build(BuildContext context) {
    return SimplePage(
      title: 'Заказ справок',
      fab: FloatingActionButton(
        onPressed: () => _showForm(context, null, isUserInquiry: true),
        tooltip: 'Моя справка',
        child: Icon(Icons.edit_outlined),
      ),
      body: Scrollbar(
        child: GroupedListView<Map, String>(
          separator: Separator.divider(indent: 15),
          addAutomaticKeepAlives: false,
          elements: Doc.doc.inquiries,
          groupBy: (element) => element['department'],
          groupSeparatorBuilder: _buildSeparator,
          itemBuilder: _buildListTile,
        ),
      ),
    );
  }

  Widget _buildSeparator(String groupByValue) {
    return HeaderText(
      groupByValue,
      head: groupByValue == Doc.doc.inquiries.first['department'],
    );
  }

  Widget _buildListTile(BuildContext context, Map record) {
    return ListTile(
      onTap: () {
        context.read<ValidationProvider>().changeCompanyName(record['title']);
        _showForm(context, record['title']);
      },
      title: Padding(
        padding: const EdgeInsets.only(right: 50),
        child: Text(
          record['title'],
          style: GoogleFonts.rubikTextTheme(
            Theme.of(context).textTheme,
          ).bodyText1,
          textScaleFactor: 1.1,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios_outlined,
        size: 16,
      ),
      // subtitle: record['fullName'] != null
      //     ? Padding(
      //         padding: const EdgeInsets.only(right: 50),
      //         child: Text(
      //           record['fullName'],
      //           style: Theme.of(context).textTheme.caption,
      //         ),
      //       )
      //     : null,
    );
  }

  ///Метод, реализующий построение всплывающего диалога с формой,
  ///для ввода новых данных.
  void _showForm(BuildContext context, String inquiry,
      {bool isUserInquiry = false}) {
    showBottomRoundDialog(
      context: context,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Separator.spacer(space: 25),
            if (isUserInquiry)
              Text(
                'МОЯ СПРАВКА'.toUpperCase(),
                maxLines: 1,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.headline6.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
              ),
            Separator.spacer(space: 20),
            Theme(
              data: Theme.of(context).copyWith(
                primaryColor: Theme.of(context).brightness == Brightness.light
                    ? kLightPrimaryColor
                    : kDarkPrimaryColor,
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      if (isUserInquiry)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 15.0),
                          child: Consumer<ValidationProvider>(
                            builder: (ctx, validate, _) => TextFormField(
                              style: TextStyle(
                                  fontSize: 17,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .color),
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                labelText: 'Наименование учреждения*',
                                filled: true,
                                errorText: validate.organizationName.error,
                                helperText:
                                    'Название учреждения, которому требуется предоставить документ.',
                                helperMaxLines: 2,
                                errorMaxLines: 2,
                              ),
                              onChanged: (value) =>
                                  validate.changeCompanyName(value),
                            ),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: Consumer<ValidationProvider>(
                          builder: (ctx, validate, _) => TextFormField(
                            style: TextStyle(
                                fontSize: 17,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .color),
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              labelText: 'Район, город, область*',
                              filled: true,
                              errorText: validate.location.error,
                              helperText:
                                  'Территориальное расположение организации, для которой требуется документ.',
                              helperMaxLines: 2,
                              errorMaxLines: 2,
                            ),
                            onChanged: (value) =>
                                validate.changeLocation(value),
                          ),
                        ),
                      ),
                      Consumer<ValidationProvider>(
                        builder: (ctx, validate, _) => TextFormField(
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            filled: true,
                            hintText: '(___) ___-__-__',
                            labelText: 'Номер телефона*',
                            prefixText: '+7 ',
                            errorText: validate.phoneNumber.error,
                          ),
                          keyboardType: TextInputType.phone,
                          onChanged: validate.changePhoneNumber,
                          maxLength: 15,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                            _phoneNumberFormatter,
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 10.0, top: 10.0),
                            child: Text(
                              'Способ получения',
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                          ),
                          Row(
                            children: [
                              Consumer<RadioProvider>(
                                builder: (ctx, radioState, _) =>
                                    RadioCell<DocType>(
                                  value: DocType.realDoc,
                                  groupValue: radioState.doc,
                                  onChanged: (value) => radioState.doc = value,
                                  label: 'Лично',
                                ),
                              ),
                              const SizedBox(width: 20),
                              Consumer<RadioProvider>(
                                builder: (ctx, radioState, _) =>
                                    RadioCell<DocType>(
                                  value: DocType.eDoc,
                                  groupValue: radioState.doc,
                                  onChanged: (value) => radioState.doc = value,
                                  label: 'По электронной почте',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(
                                Theme.of(context).accentColor,
                              ),
                            ),
                            child: const Text('Отмена'),
                          ),
                          const SizedBox(width: 15),
                          Consumer2<ValidationProvider, RadioProvider>(
                            builder: (ctx, validate, radio, _) =>
                                ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.resolveWith(
                                  (states) {
                                    if (!states
                                        .contains(MaterialState.disabled)) {
                                      return Theme.of(context).accentColor;
                                    }
                                  },
                                ),
                              ),
                              onPressed: validate.isInquiryFormValid
                                  ? () async {
                                      _launchURL(
                                        context,
                                        Doc.doc
                                            .emailForm(
                                              group: 'ДИ-11',
                                              userName: context
                                                  .read<AuthRepository>()
                                                  .user
                                                  .userName,
                                              location: validate.location.value,
                                              inquiry: inquiry ??
                                                  validate
                                                      .organizationName.value,
                                              phoneNumber:
                                                  validate.phoneNumber.value,
                                              docType: radio.doc,
                                            )
                                            .toString()
                                            .replaceAll("+", "%20"),
                                      );
                                      Navigator.pop(context);
                                    }
                                  : null,
                              child: const Text('Подтвердить'),
                            ),
                          ),
                        ],
                      ),
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchURL(BuildContext context, String url) async {
    try {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'На Вашем устройстве не найден почтовый клиент для отправки';
      }
    } catch (error) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Theme.of(context).errorColor,
            content: Text(
              error.toString(),
              style: Theme.of(context).snackBarTheme.contentTextStyle,
            ),
            duration: const Duration(seconds: 1),
          ),
        );
    }
  }
}

/// Format incoming numeric text to fit the format of (###) ###-##-##
class _RuNumberTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final newTextLength = newValue.text.length;
    final newText = StringBuffer();
    var selectionIndex = newValue.selection.end;
    var usedSubstringIndex = 0;
    if (newTextLength >= 1) {
      newText.write('(');
      if (newValue.selection.end >= 1) selectionIndex++;
    }
    if (newTextLength >= 4) {
      newText.write('${newValue.text.substring(0, usedSubstringIndex = 3)}) ');
      if (newValue.selection.end >= 3) selectionIndex += 2;
    }
    if (newTextLength >= 7) {
      newText.write('${newValue.text.substring(3, usedSubstringIndex = 6)}-');
      if (newValue.selection.end >= 6) selectionIndex++;
    }
    if (newTextLength >= 9) {
      newText.write('${newValue.text.substring(6, usedSubstringIndex = 8)}-');
      if (newValue.selection.end >= 8) selectionIndex++;
    }
    if (newTextLength >= usedSubstringIndex) {
      newText.write(newValue.text.substring(usedSubstringIndex));
    }
    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
