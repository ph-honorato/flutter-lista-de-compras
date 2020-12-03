import 'package:audioplayers/audioplayers.dart';

class Audio {

  AudioPlayer audioPlayer = AudioPlayer();

  void tocar( String url ) async {
      print("audio deve iniciar");
      await audioPlayer.play(url);
  }

  void pausar() {
    print("audio deve ser parado");
    audioPlayer.stop();
  }

}
