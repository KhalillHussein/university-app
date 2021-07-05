import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import 'package:row_collection/row_collection.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../providers/index.dart';
import '../../../repositories/auth.dart';
import '../../../util/index.dart';
import '../../widgets/index.dart';

class MyInquiry extends StatelessWidget {
  MyInquiry({Key key}) : super(key: key);

  final RuNumberTextInputFormatter _phoneNumberFormatter =
      RuNumberTextInputFormatter();

  @override
  Widget build(BuildContext context) {
    return BasicPage(
      title: 'Моя справка',
      body: Theme(
        data: Theme.of(context).copyWith(
          primaryColor: Theme.of(context).brightness == Brightness.light
              ? kLightAccentColor
              : kDarkAccentColor,
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 40),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Consumer<ValidationProvider>(
                    builder: (ctx, validate, _) => TextFormField(
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        fillColor: Theme.of(context).cardColor,
                        labelText: 'Наименование учреждения*',
                        filled: true,
                        errorText: validate.organizationName.error,
                        helperText:
                            'Название учреждения, которому требуется предоставить документ.',
                        helperMaxLines: 2,
                        errorMaxLines: 2,
                      ),
                      onChanged: (value) => validate.changeCompanyName(value),
                    ),
                  ),
                  Separator.spacer(space: 24),
                  Consumer<ValidationProvider>(
                    builder: (ctx, validate, _) => TextFormField(
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        fillColor: Theme.of(context).cardColor,
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
                  Separator.spacer(space: 24),
                  Consumer<ValidationProvider>(
                    builder: (ctx, validate, _) => TextFormField(
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        fillColor: Theme.of(context).cardColor,
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
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
                          Separator.spacer(space: 24),
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
                  Separator.spacer(space: 24),
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
                ]),
          ),
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
