import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:queue_music/Modules/Playing/now_playing.dart';
import 'package:queue_music/Modules/Playing/playing.dart';
import 'package:queue_music/Modules/Playing/playing_controller.dart';
import 'package:queue_music/Modules/SongList/music.dart';
import 'package:queue_music/Modules/SongList/song_list_controller.dart';


void main() {
  // await JustAudioBackground.init(
  //   androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
  //   androidNotificationChannelName: 'Audio playback',
  //   androidNotificationOngoing: true,
  // );
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      getPages: [
        GetPage(
          name: "/", 
          page: () => const Music(),
          binding: BindingsBuilder(
            () {
              Get.lazyPut<PlayingController>(() => PlayingController(), fenix: true);
              Get.lazyPut<SonglistController>(() => SonglistController(), fenix: true);
            }
          )
        ),
        GetPage(
          name: "/player", 
          page: () => NowPlaying(),
          binding: BindingsBuilder(
            () {
              Get.lazyPut<PlayingController>(() => PlayingController());
              Get.lazyPut<SonglistController>(() => SonglistController());
            },
          ),
        ),
        GetPage(
          name: "/playing", 
          page: () => PlayingScreen(),
          binding: BindingsBuilder(
            () {
              Get.lazyPut<PlayingController>(() => PlayingController());
              Get.lazyPut<SonglistController>(() => SonglistController());
            },
          ),
        ),
      ],
    ),
  );
}