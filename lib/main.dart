import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:topia_adventure/topia_adventrure.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    await Flame.device.fullScreen();
    await Flame.device.setLandscape();
  }
  final TopiaAdventure game = TopiaAdventure();
  // Using [kDebugMode] to keep creating new instances
  // of the game
  runApp(
    GameWidget(
      game: kDebugMode ? TopiaAdventure() : game,
    ),
  );
}
