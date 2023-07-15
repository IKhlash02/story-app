import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app_1/data/api/api_service.dart';

import 'package:story_app_1/data/model/story_element.dart';
import 'package:story_app_1/db/auth_repository.dart';
import 'package:story_app_1/provider/list_story_provider.dart';

import 'package:story_app_1/screen/add_story_page.dart';
import 'package:story_app_1/screen/detail_story.dart';
import 'package:story_app_1/screen/list_story.dart';
import 'package:story_app_1/screen/login_page.dart';
import 'package:story_app_1/screen/register_page.dart';
import 'package:story_app_1/screen/splash_screen.dart';

class MyRouterDelegate extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final GlobalKey<NavigatorState> _navigatorKey;
  final AuthRepository authRepository;

  MyRouterDelegate(
    this.authRepository,
  ) : _navigatorKey = GlobalKey<NavigatorState>() {
    _init();
  }

  _init() async {
    isLoggedIn = await authRepository.isLoggedIn();

    notifyListeners();
  }

  StoryElement? storyElement;

  List<Page> historyStack = [];
  bool? isLoggedIn;
  bool? isRegister = false;
  bool? isAddStory = false;

  @override
  Widget build(BuildContext context) {
    if (isLoggedIn == true) {
      historyStack = _loggedInStack;
    } else if (isLoggedIn == false) {
      historyStack = _loggedOutStack;
    } else if (isLoggedIn == null) {
      historyStack = _splashScreen;
    }

    return Navigator(
      key: navigatorKey,
      pages: historyStack,
      onPopPage: (route, result) {
        final didPop = route.didPop(result);
        if (!didPop) {
          return false;
        }
        storyElement = null;
        isAddStory = false;
        isRegister = false;
        notifyListeners();

        return true;
      },
    );
  }

  @override
  GlobalKey<NavigatorState>? get navigatorKey => _navigatorKey;

  @override
  Future<void> setNewRoutePath(configuration) {
    throw UnimplementedError();
  }

  List<Page> get _splashScreen => const [
        MaterialPage(
          key: ValueKey("SplashScreen"),
          child: SplashScreen(),
        ),
      ];

  List<Page> get _loggedOutStack => [
        MaterialPage(
          key: const ValueKey("LoginPage"),
          child: LoginPage(
            /// todo 17: add onLogin and onRegister method to update the state
            onLogin: () {
              isLoggedIn = true;
              notifyListeners();
            },
            onRegister: () {
              isRegister = true;
              notifyListeners();
            },
          ),
        ),
        if (isRegister == true)
          MaterialPage(
            key: const ValueKey("RegisterPage"),
            child: RegisterPage(
              onRegister: () {
                isRegister = false;
                notifyListeners();
              },
              onLogin: () {
                isRegister = false;
                notifyListeners();
              },
            ),
          ),
      ];
  List<Page> get _loggedInStack => [
        MaterialPage(
          key: const ValueKey("QuotesListPage"),
          child: ListStory(
            onTapped: (StoryElement story) {
              storyElement = story;
              notifyListeners();
            },
            onLogout: () {
              isLoggedIn = false;
              notifyListeners();
            },
            isAddStory: () {
              isAddStory = true;
              notifyListeners();
            },
          ),
        ),
        if (storyElement != null)
          MaterialPage(
            key: const ValueKey("DetailStory"),
            child: DetailStory(
              storyElement: storyElement!,
            ),
          ),
        if (isAddStory == true)
          MaterialPage(
            key: const ValueKey("AddStoryPage"),
            child: AddStoryPage(
              onSend: () {
                isAddStory = false;
                notifyListeners();
              },
            ),
          )
      ];
}
