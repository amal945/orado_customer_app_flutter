import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension StringUtils on String {
  bool caseIgnoreContains(String text) => toLowerCase().contains(text.toLowerCase());

  DateTime toDate() => DateFormat.yMd().parse(this);

  DateTime toDateOnly() => DateFormat('yyyy-MM-dd').parse(this);

  DateTime toDateTime() => DateFormat('dd-MM-yyyy hh:mm a').parse(this);

  DateTime parseFromIsoDate() => DateFormat('yyyy-MM-ddTHH:mm').parse(this);

  DateTime parseFromLocal() => DateFormat('yyyy-MM-dd hh:mm a').parse(this);
  DateTime parseFrom24Hours() => DateFormat('yyyy-MM-dd HH:mm').parse(this);
  DateTime parseFromYear() => DateFormat('yyyy-MM-dd').parse(this);

  DateTime parseLocalTime() => DateFormat('hh:mm a').parse(this);

  String removeHtmlTags() {
    final RegExp exp = RegExp(r'<[^>]*>', multiLine: true);
    return replaceAll(exp, '');
  }

  Color toColor() {
    return Color(int.parse(substring(1), radix: 16) + 0xFF000000);
  }
}
