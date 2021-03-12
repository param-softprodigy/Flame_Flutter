import 'package:flame_app/components/enemy.dart';
import 'package:flame_app/game_controller.dart';

class EnemySpawner {
  final GameController gameController;
  final int maxSpawnInterval = 3000;
  final int minSpawnInterval = 700;
  final int intervalChnage = 3;
  final int maxEnimes = 7;
  int currentInterval;
  int nextSpawn;

  EnemySpawner(this.gameController) {
    initialize();
  }

  void initialize() {
    killAllEnamies();
    currentInterval = maxSpawnInterval;
    nextSpawn = DateTime.now().millisecondsSinceEpoch + currentInterval;
  }

  void killAllEnamies() {
    gameController.enemies.forEach((Enemy enemy) => enemy.isDead = true);
  }

  void update(double t) {
    int now = DateTime.now().millisecondsSinceEpoch;
    if (gameController.enemies.length < maxEnimes && now >= nextSpawn) {
      gameController.spawnEnemy();
      if (currentInterval > minSpawnInterval) {
        currentInterval -= intervalChnage;
        currentInterval -= (currentInterval * 0.1).toInt();
      }
      nextSpawn = now + currentInterval;
    }
  }
}
