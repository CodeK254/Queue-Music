import 'dart:async';

import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlayingController extends GetxController{
  final angle = 0.0.obs;
  final duration = Duration().obs;
  final position = Duration().obs;
  final playing = false.obs;
  final songPlayed = SongModel({}).obs;
  final playingSongIndex = 0.obs;
  final pausedTime = Duration().obs;

  // final songCont = Get.find<SonglistController>();
  void pauseSong(){
    pausedTime.value = position.value;
  }

  void setPlayingSongIndex(int index){
    playingSongIndex.value = index;
  }

  void isNotPlaying(){
    playing.value = false;
  }

  void isPlaying(){
    playing.value = true;
  }

  void changeToNextSong(SongModel song){
    songPlayed.value = song;
  }

  void rotateDisk(){
    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      angle.value += 0.1;
    });
  }

  void stopDisk(){
    angle.value = 0.0;
  }

  @override
  void onInit() {
    super.onInit();
    rotateDisk();
  }
}