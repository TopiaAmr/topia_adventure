import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:topia_adventure/topia_adventrure.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    Flame.device.fullScreen();
    Flame.device.setLandscape();
  }
  final TopiaAdventrue game = TopiaAdventrue();
  // Using [kDebugMode] to keep creating new instances
  // of the game
  runApp(
    GameWidget(
      game: kDebugMode ? TopiaAdventrue() : game,
    ),
  );
}
