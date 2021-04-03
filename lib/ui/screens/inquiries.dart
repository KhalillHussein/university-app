import 'package:auto_size_text/auto_size_text.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mtusiapp/providers/index.dart';

import 'package:mtusiapp/providers/radio.dart';
import 'package:mtusiapp/repositories/auth.dart';
import 'package:mtusiapp/ui/widgets/custom_page.dart';
import 'package:mtusiapp/ui/widgets/dialogs.dart';
import 'package:mtusiapp/ui/widgets/radio_cell.dart';
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Text(
                'Отдел кадров',
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    .copyWith(fontWeight: FontWeight.w800),
                textScaleFactor: 1.1,
              ),
            ),
            const SizedBox(height: 8),
            _buildList(context, Doc.inquiriesOtdelKadrov),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Text(
                'Деканат',
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    .copyWith(fontWeight: FontWeight.w800),
                textScaleFactor: 1.1,
              ),
            ),
            const SizedBox(height: 8),
            _buildList(context, Doc.inquiriesDekanat),
          ],
        ),
      ),
    );
  }

  Widget _buildList(BuildContext context, List<Map> docs) {
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: docs.length,
      itemBuilder: (ctx, index) => ExpandableNotifier(
        child: ScrollOnExpand(
          child: Card(
            child: ExpandablePanel(
              theme: ExpandableThemeData(
                hasIcon: false,
                tapBodyToCollapse: true,
                useInkWell: false,
              ),
              collapsed: SizedBox(),
              header: Builder(builder: (context) {
                final controller = ExpandableController.of(context);
                return InkWell(
                  onTap: () => controller.toggle(),
                  borderRadius: BorderRadius.circular(2.0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20.0),
                    child: Row(
                      children: [
                        Container(
                          width: 250,
                          height: 60,
                          alignment: Alignment.centerLeft,
                          child: AutoSizeText(
                            docs[index]['title'],
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(fontWeight: FontWeight.w500),
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            textScaleFactor: 0.95,
                          ),
                        ),
                        Spacer(),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                );
              }),
              expanded: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (docs[index]['fullName'] != null)
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 35, bottom: 15),
                      child: Text(
                        docs[index]['fullName'],
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(fontWeight: FontWeight.w400),
                        textScaleFactor: 0.85,
                      ),
                    ),
                  Divider(height: 1.0, thickness: 1.2),
                  FlatButton(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 20),
                    onPressed: () {
                      context
                          .read<ValidationProvider>()
                          .changeCompanyName(docs[index]['title']);
                      _showForm(context, docs[index]['title']);
                    },
                    textColor: Theme.of(context).primaryColor,
                    child: Text(
                      'ЗАКАЗАТЬ',
                      style: TextStyle(
                        letterSpacing: 0.9,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      separatorBuilder: (ctx, index) => const SizedBox(height: 2),
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
            Padding(
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
                              color:
                                  Theme.of(context).textTheme.bodyText1.color),
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: 'Район, город, область *',
                            filled: true,
                            errorText: validate.location.error,
                            helperText:
                                'Территориальное расположение организации, для которой требуется документ',
                            helperMaxLines: 2,
                            errorMaxLines: 2,
                          ),
                          onChanged: (value) => validate.changeLocation(value),
                        ),
                      ),
                    ),
                    Consumer<ValidationProvider>(
                      builder: (ctx, validate, _) => TextFormField(
                        initialValue: validate.phoneNumber.value,
                        style: TextStyle(
                            fontSize: 17,
                            color: Theme.of(context).textTheme.bodyText1.color),
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
                        onChanged: (value) => validate.changePhoneNumber(value),
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
                            textScaleFactor: 0.9,
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
                    Consumer2<ValidationProvider, RadioProvider>(
                      builder: (ctx, validate, radio, _) => ElevatedButton(
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
                                        inquiry: inquiry,
                                        phoneNumber: validate.phoneNumber.value,
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
                  ]),
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
