import 'package:audioplayers/audioplayers.dart';

class TimerSounds {
  static final _player = AudioPlayer();

  static Future<void> beep() async {
    await _player.play(AssetSource('sounds/beep.wav'));
  }

  static Future<void> buzzer() async {
    await _player.play(AssetSource('sounds/buzzer.wav'));
  }
}
