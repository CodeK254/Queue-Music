// ignore_for_file: must_be_immutable
import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:queue_music/Modules/Playing/playing_controller.dart';
import 'package:queue_music/Modules/SongList/song_list_controller.dart';
import 'package:queue_music/Modules/layouts.dart';
import 'package:just_audio/just_audio.dart';

class NowPlaying extends StatefulWidget {

  @override
  State<NowPlaying> createState() => _NowPlayingState();
}

class _NowPlayingState extends State<NowPlaying> {
  final playingController = Get.find<PlayingController>();
  final songlistController = Get.find<SonglistController>();

  void playAudio(String? url){
    try{
      Get.arguments["audioPlayer"].setAudioSource(
        AudioSource.uri(
          Uri.parse(url!),
          // tag: MediaItem(
          //   // Specify a unique ID for each media item:
          //   id: widget.songToPlay.id.toString(),
          //   // Metadata to display in the notification:
          //   album: widget.songToPlay.album,
          //   title: widget.songToPlay.displayNameWOExt,
          //   artUri: Uri.parse('https://example.com/albumart.jpg'),
          // ),
        ),
      );
      Get.arguments["audioPlayer"].play();
      playingController.playing.value = true;

      Get.arguments["audioPlayer"].durationStream.listen((dur) {
        playingController.duration.value = dur;
      });

      Get.arguments["audioPlayer"].positionStream.listen((pos) {
        playingController.position.value = pos;
      });

      // if(playingController.position.value.toString() != "0:00:00.000000" && (playingController.position.value == playingController.duration.value)){
      //   ++playingController.playingSongIndex.value;
      //   playingController.changeToNextSong(Get.arguments["songList"][playingController.playingSongIndex.value]);
      //   playAudio(playingController.songPlayed.value.uri);
      // }

    } catch(e){
      print(e);
    }
  }

  void pauseAudio(){
    Get.arguments["audioPlayer"].pause();
  }

  // String duraTime(int? milisecs){
  //   DateTime time = DateTime.fromMillisecondsSinceEpoch(widget.songToPlay.duration!, isUtc: true);
  //   String formattedTime = DateFormat.Hms().format(time);
  //   return formattedTime;
  // }
  @override
  void initState(){
    super.initState();
    songlistController.setSongList(Get.arguments["songList"]);
    debugPrint(Get.arguments["songsToPlay"].toString());
    playingController.playingSongIndex.value = Get.arguments["listIndex"];
    playingController.songPlayed.value = Get.arguments["songsToPlay"] as SongModel;
    playAudio(playingController.songPlayed.value.uri);
  }
  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        toolbarHeight: 65,
      ),
      body: Container(
        constraints: BoxConstraints(
          minWidth: double.infinity,
          minHeight: MediaQuery.of(context).size.height,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
                Colors.black,
                Colors.black,
                Colors.grey.shade900,
                Colors.black54,
              ],
          )
        ),
        child: Obx(
          () => SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black,
                          Colors.grey.shade800,
                          Colors.grey,
                          Colors.white60,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.grey.shade200,
                        width: 3,
                      )
                    ),
                    height: MediaQuery.of(context).size.height * 0.4,
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Obx(
                      () => Transform.rotate(
                        angle: playingController.angle.value,
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          radius: MediaQuery.of(context).size.width * 0.18,
                          child: CircleAvatar(
                            radius: MediaQuery.of(context).size.width * 0.185,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              radius: MediaQuery.of(context).size.width * 0.175,
                              backgroundColor: Colors.black,
                              child: const Icon(
                                Icons.queue_music,
                                color: Colors.white,
                                size: 65,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.07),
                Container(
                  height: MediaQuery.of(context).size.height * 0.07,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.05,
                    ),
                    child: Text(
                      playingController.songPlayed.value.displayNameWOExt,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 15,
                        // letterSpacing: 1.2,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.fade,
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                    ),
                    child: Text(
                      playingController.songPlayed.value.artist.toString() == "<unknown>" ? "Unknown Artist" : playingController.songPlayed.value.artist.toString(),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        color: Colors.grey,
                      ),
                      overflow: TextOverflow.fade,
                    ),
                  ),
                ),
                const SizedBox(height:  10),
                Obx(
                  (){
                    return Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text(
                            playingController.position.value.toString().split(".")[0],
                            style: GoogleFonts.rancho(
                              fontSize: 12,
                              letterSpacing: 1.2,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Slider(
                            thumbColor: Colors.white,
                            inactiveColor: Colors.white,
                            value: playingController.position.value.inSeconds.toDouble(),
                            min: const Duration(seconds: 0).inSeconds.toDouble(),
                            max: playingController.duration.value.inSeconds.toDouble(),
                            onChanged: (value){
                              changeToSeconds(value.toInt());
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Text(
                            playingController.duration.value.toString().split(".")[0],
                            style: GoogleFonts.rancho(
                              fontSize: 12,
                              letterSpacing: 1.2,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                ),
                SizedBox(height:  MediaQuery.of(context).size.height * 0.05),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: (){
                        --playingController.playingSongIndex.value;
                        playingController.changeToNextSong(Get.arguments["songList"][playingController.playingSongIndex.value]);
                        playAudio(playingController.songPlayed.value.uri);
                      },
                      child: iconTheme(Icons.skip_previous),
                    ),
                    Obx(
                      () => GestureDetector(
                        onTap: (){
                          if(playingController.playing == false){
                            Get.arguments["audioPlayer"].play();
                            Get.arguments["audioPlayer"].seek(playingController.pausedTime.value);
                            print(playingController.pausedTime.value);
                            playingController.isPlaying();
                            playingController.rotateDisk();
                          } else {
                            playingController.pauseSong();
                            pauseAudio();
                            playingController.stopDisk();
                            playingController.isNotPlaying();
                          }
                        },
                        child: playingController.playing == false ? Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: const Icon(
                              Icons.play_arrow,
                              size: 35,
                              color: Colors.redAccent,
                            ),
                          ),
                        ) : Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: const Icon(
                              Icons.pause,
                              size: 35,
                              color: Colors.orange,
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        ++playingController.playingSongIndex.value;
                        playingController.changeToNextSong(Get.arguments["songList"][playingController.playingSongIndex.value]);
                        playAudio(playingController.songPlayed.value.uri);
                      },
                      child: iconTheme(Icons.skip_next),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  void changeToSeconds(int secs){
    playingController.position.value = Duration(seconds: secs);
    Get.arguments["audioPlayer"].seek(playingController.position.value);
  }
}