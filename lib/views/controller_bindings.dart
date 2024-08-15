import 'package:get/get.dart';
import 'package:tictactoe/views/create_game/create_game_controller.dart';
import 'package:tictactoe/views/game/game_controller.dart';
import 'package:tictactoe/views/home/home_controller.dart';

/// This [ControllerBindings] class holds all of the Controllers of the
/// our views.
class ControllerBindings extends Bindings {
  @override
  void dependencies() {
    /// Fenix means, controller can be re-used. If we don't need it,
    /// it will remove from memory. If we need it, it will re-created.
    /// The reason we used [Get.lazyPut] instead of [Get.put] is to
    /// prevent the controller from being created when the app starts.
    /// When we need it, it'll be created.
    Get.lazyPut(() => HomeController(), fenix: true);
    Get.lazyPut(() => CreateGameController(), fenix: true);
    Get.lazyPut(() => GameController(), fenix: true);
  }
}
