import 'dart:math';
import 'dart:ui';

class UIHelper{
  static Color generateRandomColor() {
    final Random _random = Random();
    return Color.fromARGB(
      255,
      _random.nextInt(200) + 30,
      _random.nextInt(200) + 30,
      _random.nextInt(200) + 30,
    );
  }
}