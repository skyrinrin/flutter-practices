import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:task_app/provider/provider.dart';
import 'package:task_app/repository/repository.dart';
import 'package:task_app/repository/repository_impl.dart';
import 'presentation/task_card.dart';
import 'domain/task_domain.dart';
import 'presentation/task_date_views.dart';
import 'presentation/add_task_window.dart';
import 'application/application.dart';
import 'presentation/homepage.dart';
// import 'package:provider/provider.dart';
import 'Infrastructure/storage.dart';
import 'Infrastructure/storage_impl.dart';
import 'core/notification/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init(); //通知の初期化

  final container = ProviderContainer();
  final app = container.read(applicationProvider);
  await app.init(); //初期化

  runApp(UncontrolledProviderScope(container: container, child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        textTheme: GoogleFonts.ibmPlexSansJpTextTheme(
          Theme.of(context).textTheme,
        ),
      ),

      home: HomePage(),
    );
  }
}
