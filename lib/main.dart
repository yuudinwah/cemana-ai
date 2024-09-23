import 'package:cemana/providers/provider.dart';
import 'package:cemana/screens/screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AppProvider())],
      builder: (_, __) {
        return MaterialApp(
          title: 'Cemana',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const MyHomePage(null),
          onGenerateRoute: (_) {
            String? q;
            try {
              q = _.name?.split("q=")[1];
            } catch (e) {
              //
            }
            return PageRouteBuilder(
              settings: _,
              pageBuilder: (context, animation1, animation2) => MyHomePage(q),
              transitionDuration: const Duration(
                seconds: 0,
              ),
            );
          },
        );
      },
    );
  }
}
