import 'package:advapp/app/dependency_injection.dart';
import 'package:flutter/material.dart';

import 'app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initAppModule();
  initLoginModule();
  runApp(MyApp());
}
