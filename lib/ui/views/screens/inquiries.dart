import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:row_collection/row_collection.dart';

import '../../../providers/index.dart';
import '../../../repositories/index.dart';
import '../../../util/index.dart';
import '../../widgets/index.dart';
import 'index.dart';

class InquiriesScreen extends StatelessWidget {
  static const route = '/inquiries';

  final RuNumberTextInputFormatter _phoneNumberFormatter =
      RuNumberTextInputFormatter();

  @override
  Widget build(BuildContext context) {
    return BasicPage(
      title: 'Заказ справок',
      fab: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MyInquiry(),
            fullscreenDialog: true,
          ),
        ),
        tooltip: 'Моя справка',
        child: Icon(Icons.edit_outlined),
      ),
      body: RawScrollbar(
        thickness: 3,
        child: GroupedListView<Map, String>(
          separator: Separator.divider(indent: 15),
          addAutomaticKeepAlives: false,
          elements: inquiries,
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
      head: groupByValue == inquiries.first['department'],
    );
  }

  Widget _buildListTile(BuildContext context, Map record) {
    return ListTile(
      onTap: () {
        context.read<ValidationProvider>().changeCompanyName(record['title']);
        _showForm(context, record['title']);
      },
      minLeadingWidth: 0,
      leading: const Icon(
        MdiIcons.fileDocumentOutline,
      ),
      title: Padding(
        padding: const EdgeInsets.only(right: 50),
        child: Text(
          record['title'],
          maxLines: 2,
          // textScaleFactor: 0.8,
          style: Theme.of(context).textTheme.bodyText1.copyWith(
                color: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .color
                    .withOpacity(0.9),
                height: 1.4,
              ),
        ).scalable(),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios_outlined,
        size: 16,
        color: Theme.of(context).textTheme.caption.color,
      ),
    );
  }

  ///Метод, реализующий построение всплывающего диалога с формой,
  ///для ввода новых данных.
  void _showForm(BuildContext context, String inquiry) {
    showBottomDialog(
      context: context,
      enableDrag: false,
      children: [
        Theme(
          data: Theme.of(context).copyWith(
            primaryColor: Theme.of(context).brightness == Brightness.light
                ? kLightAccentColor
                : kDarkAccentColor,
          ),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: Consumer<ValidationProvider>(
                    builder: (ctx, validate, _) => TextFormField(
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
                      onChanged: (value) => validate.changeLocation(value),
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
                      padding: const EdgeInsets.only(left: 10.0, top: 10.0),
                      child: Text(
                        'Способ получения',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ),
                    Row(
                      children: [
                        Consumer<InquiryProvider>(
                          builder: (ctx, radioState, _) => RadioCell<DocType>(
                            value: DocType.realDoc,
                            groupValue: radioState.doc,
                            onChanged: (value) => radioState.doc = value,
                            label: 'Лично',
                          ),
                        ),
                        Separator.spacer(space: 20),
                        Consumer<InquiryProvider>(
                          builder: (ctx, radioState, _) => RadioCell<DocType>(
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
                Separator.spacer(space: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        context.read<ValidationProvider>().clearFields();
                        Navigator.pop(context);
                      },
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all<Color>(
                          Theme.of(context).accentColor,
                        ),
                      ),
                      child: const Text('Отмена').scalable(),
                    ),
                    const SizedBox(width: 15),
                    Consumer2<ValidationProvider, InquiryProvider>(
                      builder: (ctx, validate, radio, _) => ElevatedButton(
                        onPressed: validate.isInquiryFormValid
                            ? () async {
                                _launchURL(
                                  context,
                                  emailForm(
                                    group: 'ДИ-11',
                                    userName: context
                                        .read<AuthRepository>()
                                        .user
                                        .userName,
                                    location: validate.location.value,
                                    inquiry: validate.organizationName.value,
                                    phoneNumber: validate.phoneNumber.value,
                                    docType: radio.doc,
                                  ).toString().replaceAll("+", "%20"),
                                );
                                validate.clearFields();
                                Navigator.pop(context);
                              }
                            : null,
                        child: const Text('Подтвердить').scalable(),
                      ),
                    ),
                  ],
                ),
              ]),
        ),
      ],
    ).whenComplete(() {
      context.read<ValidationProvider>().clearFields();
    });
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
