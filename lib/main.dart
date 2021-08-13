import 'package:alice/alice.dart';
import 'package:fgcart/hrv/api.dart';
import 'package:fgcart/test_cases/test_cases.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

late Alice alice;

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  alice = Alice(showNotification: false);
  HrvApi.logInterceptor = alice.getDioInterceptor();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider.value(
      value: alice,
      child: MaterialApp(
        title: 'Flutter Demo',
        home: const TestCases(),
        navigatorKey: alice.getNavigatorKey(),
      ),
    );
  }
}
