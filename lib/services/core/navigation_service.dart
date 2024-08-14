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

enum Pages {
  home(
    route: Routes.home,
    title: 'Home',
    view: HomeView(),
  ),
  createGame(
    route: Routes.createGame,
    title: 'Create Game',
    view: CreateGameView(),
  ),
  game(
    route: Routes.game,
    title: 'Game',
    view: GameView(),
  );

  final String route;
  final String title;
  final Widget view;

  const Pages({required this.route, required this.title, required this.view});
}

class NavigationService {
  static List<GetPage> pages = [
    for (final page in Pages.values)
      GetPage(
        name: page.route,
        title: page.title,
        curve: Curves.easeInOut,
        transition: Transition.rightToLeftWithFade,
        transitionDuration: kThemeAnimationDuration,
        page: () => page.view,
      ),
  ];
}
