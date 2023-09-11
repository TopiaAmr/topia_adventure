import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:topia_adventure/actors/player.dart';

/// Represents a level in the game world.
class Level extends World {
  final String levelName;

  late TiledComponent level;

  /// Constructs a [Level] object with the given [levelName].
  Level(this.levelName);

  @override
  FutureOr<void> onLoad() async {
    // Load the level from a Tiled file
    level = await TiledComponent.load(
      '$levelName.tmx',
      Vector2.all(16),
    );
    add(level);

    // Retrieve the object layer containing spawnpoints
    final spLayer = level.tileMap.getLayer<ObjectGroup>('Spawnpoints');

    // Iterate through each spawnpoint object
    for (final sp in spLayer!.objects) {
      switch (sp.class_) {
        case 'Player':
          // Create a player object and add it to the level
          final player = Player(
            characterName: 'Virtual Guy',
            position: Vector2(
              sp.x.toDouble(),
              sp.y.toDouble(),
            ),
          );
          add(player);
          break;
        default:
        // Handle other types of spawnpoints
      }
    }

    return super.onLoad();
  }
}
