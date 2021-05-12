import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:mtusiapp/providers/index.dart';
import 'package:mtusiapp/util/colors.dart';

import 'package:provider/provider.dart';

extension Scalable on Text {
  Widget scalable() {
    return Consumer<TextScaleProvider>(
      builder: (ctx, scale, _) => Text(
        data,
        style: style,
        maxLines: maxLines,
        softWrap: softWrap,
        textAlign: textAlign,
        overflow: overflow,
        textScaleFactor: textScaleFactor != null
            ? textScaleFactor * scale.scaleFactor
            : 1 * scale.scaleFactor,
      ),
    );
  }
}

extension ScalableMarkdown on MarkdownBody {
  Widget scalable() {
    return Consumer<TextScaleProvider>(
      builder: (ctx, scale, _) => MarkdownBody(
        data: data,
        shrinkWrap: shrinkWrap,
        selectable: selectable,
        fitContent: fitContent,
        styleSheet: MarkdownStyleSheet(
          p: styleSheet.p,
          textScaleFactor: styleSheet.textScaleFactor != null
              ? styleSheet.textScaleFactor * scale.scaleFactor
              : 1 * scale.scaleFactor,
        ),
      ),
    );
  }
}

extension ScalableSelectableText on SelectableText {
  Widget scalable() {
    return Consumer<TextScaleProvider>(
      builder: (ctx, scale, _) => SelectableText(
        data,
        style: style,
        maxLines: maxLines,
        textAlign: textAlign,
        scrollPhysics: scrollPhysics,
        textScaleFactor: textScaleFactor != null
            ? textScaleFactor * scale.scaleFactor
            : 1 * scale.scaleFactor,
      ),
    );
  }
}

extension ScalableRichText on RichText {
  Widget scalable() {
    return Consumer<TextScaleProvider>(
      builder: (ctx, scale, _) => RichText(
        text: text,
        textScaleFactor: textScaleFactor != null
            ? textScaleFactor * scale.scaleFactor
            : 1 * scale.scaleFactor,
      ),
    );
  }
}

extension CustomColorScheme on ColorScheme {
  Color get success =>
      brightness == Brightness.light ? kLightBasilColor : kDarkBasilColor;
  Color get successAlt => brightness == Brightness.light
      ? kLightEucalyptusColor
      : kDarkEucalyptusColor;

  Color get info =>
      brightness == Brightness.light ? kLightLavenderColor : kDarkLavenderColor;

  Color get warning =>
      brightness == Brightness.light ? kLightCitronColor : kDarkCitronColor;

  Color get danger =>
      brightness == Brightness.light ? kLightTomatoColor : kDarkTomatoColor;

  Color get weak =>
      brightness == Brightness.light ? kLightPumpkinColor : kDarkPumpkinColor;

  Color get lecture =>
      brightness == Brightness.light ? kLightPeacockColor : kDarkPeacockColor;

  Color get practice =>
      brightness == Brightness.light ? kLightLavenderColor : kDarkLavenderColor;

  Color get laboratory =>
      brightness == Brightness.light ? kLightSageColor : kDarkSageColor;

  Color get consultation =>
      brightness == Brightness.light ? kLightFlamingoColor : kDarkFlamingoColor;

  Color get exam => brightness == Brightness.light
      ? kLightCherryBlossomColor
      : kDarkCherryBlossomColor;
}

extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}
