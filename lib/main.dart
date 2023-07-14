import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app_1/data/api/api_service.dart';
import 'package:story_app_1/provider/auth_provider.dart';
import 'package:story_app_1/provider/image_provider.dart';
import 'package:story_app_1/provider/list_story_provider.dart';
import 'package:story_app_1/provider/upload_provider.dart';
import 'package:story_app_1/routes/router_delegate.dart';

import 'db/auth_repository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late MyRouterDelegate myRouterDelegate;
  late AuthProvider authProvider;
  late ListStoryProvider listSoryProvider;
  late UploadProvider uploadProvider;

  @override
  void initState() {
    super.initState();

    final authRepository = AuthRepository();
    authProvider = AuthProvider(authRepository, ApiService());
    listSoryProvider = ListStoryProvider(
        apiService: ApiService(), authRepository: authRepository);
    uploadProvider = UploadProvider(
        apiService: ApiService(), authRepository: authRepository);
    myRouterDelegate = MyRouterDelegate(authRepository);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => authProvider,
        ),
        ChangeNotifierProvider(
          create: (context) => listSoryProvider,
        ),
        ChangeNotifierProvider(
          create: (context) => AddImageProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => uploadProvider,
        ),
      ],
      child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: Router(
            routerDelegate: myRouterDelegate,
            backButtonDispatcher: RootBackButtonDispatcher(),
          )),
    );
  }
}
