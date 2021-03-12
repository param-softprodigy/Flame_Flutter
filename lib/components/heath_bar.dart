import 'dart:ffi';

import 'package:flame_app/game_controller.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui';

class HealthBar {
  final GameController gameController;
  Rect heathBarRect;
  Rect remaningHeathRect;

  HealthBar(this.gameController) {
    double barWidth = gameController.screenSize.width / 1.75;
    heathBarRect = Rect.fromLTWH(
      gameController.screenSize.width / 2 - barWidth / 2,
      gameController.screenSize.height * 0.8,
      barWidth,
      gameController.tileSize * 0.5,
    );

    remaningHeathRect = Rect.fromLTWH(
      gameController.screenSize.width / 2 - barWidth / 2,
      gameController.screenSize.height * 0.8,
      barWidth,
      gameController.tileSize * 0.5,
    );
  }

  Void render(Canvas c) {
    Paint heathBarColor = Paint()..color = Color(0xFFFF0000);
    Paint remaningBarColor = Paint()..color = Color(0xFF00FF00);
    c.drawRect(heathBarRect, heathBarColor);
    c.drawRect(remaningHeathRect, remaningBarColor);
  }

  Void update(double t) {
    double barWidth = gameController.screenSize.width / 1.75;
    double percentageHealth =
        gameController.player.currentHealth / gameController.player.maxHealth;
    remaningHeathRect = Rect.fromLTWH(
      gameController.screenSize.width / 2 - barWidth / 2,
      gameController.screenSize.height * 0.8,
      barWidth * percentageHealth,
      gameController.tileSize * 0.5,
    );
  }
}
