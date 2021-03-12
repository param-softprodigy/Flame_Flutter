import 'dart:math';

import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame_app/components/enemy.dart';
import 'package:flame_app/components/heath_bar.dart';
import 'package:flame_app/components/highscore_text.dart';
import 'package:flame_app/components/player.dart';
import 'package:flame_app/components/score_text.dart';
import 'package:flame_app/components/start_button.dart';
import 'package:flame_app/enemy_spawner.dart';
import 'package:flame_app/state.dart';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameController extends Game {
  final SharedPreferences storage;
  Random rand;
  Size screenSize;
  double tileSize;

  Player player;
  EnemySpawner enemySpawner;
  List<Enemy> enemies;
  HealthBar heathbar;
  int score;
  ScoreText scoreText;
  State1 state1;
  HighscoreText highscoreText;
  StartText startText;

  GameController(this.storage) {
    initialize();
  }

  void initialize() async {
    resize(await Flame.util.initialDimensions());
    state1 = State1.menu;

    rand = Random();
    player = Player(this);

    // enemy = Enemy(this, 200, 200);
    enemies = List<Enemy>();
    enemySpawner = EnemySpawner(this);
    heathbar = HealthBar(this);
    score = 0;
    scoreText = ScoreText(this);
    highscoreText = HighscoreText(this);
    startText = StartText(this);

    spawnEnemy();
  }

  void render(Canvas c) {
    Rect background = Rect.fromLTWH(0, 0, screenSize.width, screenSize.height);
    Paint backgroundPaint = Paint()..color = Color(0xFFFAFAFA);
    c.drawRect(background, backgroundPaint);

    player.render(c);

    if (state1 == State1.menu) {
      highscoreText.render(c);
      startText.render(c);
    } else if (state1 == State1.playing) {
      // enemy.render(c);
      enemies.forEach((Enemy enemy) => enemy.render(c));
      scoreText.render(c);
      heathbar.render(c);
    }
  }

  void update(double t) {
    if (state1 == State1.menu) {
      highscoreText.update(t);
      startText.update(t);
    } else if (state1 == State1.playing) {
// enemy.update(t);
      enemySpawner.update(t);
      enemies.forEach((Enemy enemy) => enemy.update(t));
      enemies.removeWhere((Enemy enemy) => enemy.isDead);
      player.update(t);
      scoreText.update(t);
      heathbar.update(t);
    }
  }

  void resize(Size size) {
    screenSize = size;

    tileSize = screenSize.width / 10;
  }

  void onTapDown(TapDownDetails d) {
    if (state1 == State1.menu) {
      state1 = State1.playing;
    } else if (state1 == State1.playing) {
      //print(d.globalPosition);
      // enemy.health--;
      enemies.forEach((Enemy enemy) {
        if (enemy.enemyRect.contains(d.globalPosition)) {
          enemy.onTapDown();
        }
      });
    }
  }

  void spawnEnemy() {
    double x, y;
    switch (rand.nextInt(4)) {
      case 0:
        //top
        x = rand.nextDouble() * screenSize.width;
        y = -tileSize * 2.5;
        break;
      case 1:
        //right
        x = screenSize.width + tileSize * 2.5;
        y = rand.nextDouble() * screenSize.height;
        break;
      case 2:
        //bottam
        x = rand.nextDouble() * screenSize.width;
        y = screenSize.width + tileSize * 2.5;
        break;
      case 3:
        //left
        x = -tileSize * 2.5;
        y = rand.nextDouble() * screenSize.height;
        break;
    }
    enemies.add(Enemy(this, x, y));
  }
}
