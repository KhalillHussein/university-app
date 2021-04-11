import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:mtusiapp/providers/index.dart';

import 'package:mtusiapp/providers/radio.dart';
import 'package:mtusiapp/repositories/auth.dart';
import 'package:mtusiapp/ui/widgets/custom_page.dart';
import 'package:mtusiapp/ui/widgets/dialogs.dart';
import 'package:mtusiapp/ui/widgets/header_text.dart';
import 'package:mtusiapp/ui/widgets/radio_cell.dart';
import 'package:mtusiapp/util/colors.dart';
import 'package:mtusiapp/util/doc.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class InquiriesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SimplePage(
      title: 'Справки',
      fab: FloatingActionButton(
        onPressed: () => _showForm(context, null, isUserInquiry: true),
        tooltip: 'Моя справка',
        child: Icon(Icons.edit_outlined),
      ),
      body: GroupedListView<Map, String>(
          separator: Divider(height: 1, indent: 15),
          addAutomaticKeepAlives: false,
          elements: Doc.doc.inquiries,
          groupBy: (element) => element['department'],
          groupSeparatorBuilder: (groupByValue) => HeaderText(
                groupByValue,
                head: true,
              ),
          itemBuilder: (context, record) {
            return ExpansionTile(
              title: Padding(
                padding: const EdgeInsets.only(right: 50, top: 8, bottom: 8),
                child: Text(
                  record['title'],
                  style: GoogleFonts.rubikTextTheme(
                    Theme.of(context).textTheme,
                  ).bodyText2.copyWith(height: 1.4),
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios_outlined,
                size: 16,
              ),
              childrenPadding: const EdgeInsets.only(left: 10.0, right: 35),
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (record['fullName'] != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          record['fullName'],
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                              fontWeight: FontWeight.w400, height: 1.4),
                          textScaleFactor: 0.9,
                        ),
                      ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () {
                          context
                              .read<ValidationProvider>()
                              .changeCompanyName(record['title']);
                          _showForm(context, record['title']);
                        },
                        child: Text(
                          'ЗАКАЗАТЬ',
                          style: GoogleFonts.rubikTextTheme(
                            Theme.of(context).textTheme,
                          ).overline.copyWith(
                              color: Theme.of(context).accentColor,
                              fontWeight: FontWeight.w600),
                          textScaleFactor: 1.4,
                          // style: TextStyle(
                          //   letterSpacing: 0.9,
                          //   fontSize: 15,
                          //   fontWeight: FontWeight.w600,
                          // ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          }),
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
            const SizedBox(height: 20),
            Container(
              width: 80.0,
              height: 5.0,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Theme.of(context).dividerColor,
              ),
            ),
            Theme(
              data: Theme.of(context).copyWith(
                primaryColor: Theme.of(context).brightness == Brightness.light
                    ? kLightPrimaryColor
                    : kDarkPrimaryColor,
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      const SizedBox(height: 15),
                      if (isUserInquiry)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 15.0),
                          child: Consumer<ValidationProvider>(
                            builder: (ctx, validate, _) => TextFormField(
                              initialValue: validate.organizationName.value,
                              style: TextStyle(
                                  fontSize: 17,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .color),
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                labelText: 'Наименование учреждения *',
                                filled: true,
                                errorText: validate.organizationName.error,
                                helperText:
                                    'Название учреждения, которому требуется предоставить документ',
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
                            initialValue: validate.location.value,
                            style: TextStyle(
                                fontSize: 17,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .color),
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              labelText: 'Район, город, область *',
                              filled: true,
                              errorText: validate.location.error,
                              helperText:
                                  'Территориальное расположение организации, для которой требуется документ',
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
                          keyboardType: TextInputType.phone,
                          initialValue: validate.phoneNumber.value,
                          style: TextStyle(
                              fontSize: 17,
                              color:
                                  Theme.of(context).textTheme.bodyText1.color),
                          inputFormatters: [validate.maskFormatter],
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintText: '+7 (___) ___-__-__',
                            labelText: 'Номер мобильного телефона *',
                            filled: true,
                            errorText: validate.phoneNumber.error,
                            helperText:
                                'На указанный номер придет оповещение, когда документ будет готов',
                            helperMaxLines: 2,
                            errorMaxLines: 2,
                          ),
                          onChanged: (value) =>
                              validate.changePhoneNumber(value),
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
