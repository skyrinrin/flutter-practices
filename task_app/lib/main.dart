import 'package:flutter/material.dart';
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
  // final storage = StorageImpl();
  // final repository = RepositoryImpl(storage: storage);
  // final application = Application(repository);

  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init(); //通知の初期化

  // // 保存されているデータを読み込む
  // final container = ProviderContainer();
  // await container.read(tasksProvider.notifier).loadTasks;
  // await container.read(labelsProvider.notifier).loadLabels; //今のところ解決していない

  final container = ProviderContainer();
  final app = container.read(applicationProvider);
  await app.init(); //初期化

  runApp(
    UncontrolledProviderScope(container: container, child: MyApp()),
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
