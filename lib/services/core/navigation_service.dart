import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tictactoe/views/create_game/create_game_view.dart';
import 'package:tictactoe/views/game/game_view.dart';
import 'package:tictactoe/views/home/home_view.dart';

/// This class used as a data class to store route names.
class Routes {
  const Routes._();

  static const String home = '/';
  static const String createGame = '/create-game';
  static const String game = '/game';
}

/// The reason we created this enum is to store all the pages in one place.
/// This way we can easily access the pages and their properties. And also
/// we will reduce boilerplate code in the [NavigationService.pages] list.
enum Pages {
  home(
    route: Routes.home,
    view: HomeView(),
  ),
  createGame(
    route: Routes.createGame,
    view: CreateGameView(),
  ),
  game(
    route: Routes.game,
    view: GameView(),
  );

  final String route;
  final Widget view;

  const Pages({required this.route, required this.view});
}

class NavigationService {
  const NavigationService._();

  /// We defined static list of pages here to use in GetMaterialApp getPages property
  /// which is a feature thats comes with Getx package.
  static List<GetPage> pages = [
    for (final page in Pages.values)
      GetPage(
        name: page.route,
        curve: Curves.easeInOut,
        transition: Transition.rightToLeftWithFade,
        transitionDuration: kThemeAnimationDuration,
        page: () => page.view,
      ),
  ];
}
