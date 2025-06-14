import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:task_app/repository/repository.dart';
import 'package:task_app/repository/repository_impl.dart';
import 'presentation/task_card.dart';
import 'domain/task_domain.dart';
import 'presentation/task_genre.dart';
import 'presentation/add_task_window.dart';
import 'application/application.dart';
import 'presentation/homepage.dart';
// import 'package:provider/provider.dart';
import 'Infrastructure/storage.dart';
import 'Infrastructure/storage_impl.dart';

void main() {
  // final storage = StorageImpl();
  // final repository = RepositoryImpl(storage: storage);
  // final application = Application(repository);

  runApp(
    ProviderScope(child: MyApp()),
    // MultiProvider(
    //   providers: [
    //     Provider<Repository>.value(value: repository),
    //     Provider<Application>.value(value: application),
    //   ],
    // child: MyApp(),
  );
  // );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: HomePage());
  }
}
