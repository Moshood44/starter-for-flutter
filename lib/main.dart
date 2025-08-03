import 'package:taskpay/app.dart';
import 'package:taskpay/utils/app_initializer.dart';
import 'package:flutter/material.dart';

void main() async {
  await AppInitializer.initialize();
  runApp(const TaskPayApp());
}
