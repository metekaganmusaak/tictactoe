import 'package:get/get.dart';
import 'package:tictactoe/views/create_game/create_game_controller.dart';
import 'package:tictactoe/views/game/game_controller.dart';
import 'package:tictactoe/views/home/home_controller.dart';

class ControllerBindings extends Bindings {
  @override
  void dependencies() {
    /// Fenix means, controller can be re-used. If we don't need it,
    /// it will removed from memory. If we need it, it will re-created.
    Get.lazyPut(() => HomeController(), fenix: true);
    Get.lazyPut(() => CreateGameController(), fenix: true);
    Get.lazyPut(() => GameController(), fenix: true);
  }
}
