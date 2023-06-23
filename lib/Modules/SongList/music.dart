import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:queue_music/Modules/Playing/playing_controller.dart';
import 'package:queue_music/Modules/SongList/song_list_controller.dart';
import 'package:queue_music/Modules/layouts.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Music extends StatefulWidget {
  const Music({super.key});

  @override
  State<Music> createState() => _MusicState();
}

class _MusicState extends State<Music> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  final AudioPlayer _audioPlayer = AudioPlayer();
  
  final playingController = Get.find<PlayingController>();

  final songListontroller = Get.find<SonglistController>();

  String toDate(int? milisecs){
    var date = DateTime.fromMicrosecondsSinceEpoch(milisecs!);

    return date.toString();
  }

  void requestPermission() async{
    // await Permission.storage.isDenied ? requestPermission() : super.initState();
    Permission.storage.request();
  }

  @override
  void initState(){
    super.initState();
    debugPrint("Is music playing? "+playingController.playing.value.toString());
    requestPermission();
  }
  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: appBarTheme("Queue_music", Icons.queue_music, true, context),
      body: Stack(
        children: [
          FutureBuilder<List<SongModel>>(
            future: _audioQuery.querySongs(
              sortType: null,
              orderType: OrderType.ASC_OR_SMALLER,
              uriType: UriType.EXTERNAL,
              ignoreCase: true,
            ),
            builder: (context, items) {
              if(items.data == null){
                return Container(
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
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                );
              }

              if(items.data!.isEmpty){
                return Container(
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
                  child: Center(
                    child: Text(
                      "Ooops!!! No songs found...",
                      style: GoogleFonts.rancho(
                        fontSize: 18,
                        color: Colors.grey,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                );
              }

              return Container(
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
                child: ListView.builder(
                  itemCount: items.data!.length,
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemBuilder:(context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          contentPadding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                          onTap: (){
                            Get.toNamed(
                              "/player",
                              arguments: {
                                "songsToPlay": items.data![index],
                                "audioPlayer": _audioPlayer,
                                "songList": items.data,
                                "listIndex": index,
                              },
                            );
                          },
                          leading: Icon(
                            Icons.music_note,
                            color: Colors.grey.shade300,
                          ),
                          title: Text(
                            items.data![index].displayNameWOExt,
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              letterSpacing: 1.2
                            ),
                          ),
                          subtitle: Text(
                            items.data![index].artist.toString() == "<unknown>" ? "Unknown Artist" : items.data![index].artist.toString(),
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.rancho(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                              letterSpacing: 1.2
                            ),
                          ),
                          trailing: const Icon(
                            Icons.more_horiz,
                            color: Colors.white,
                            size: 25,
                          ),
                        ),
                        Container(
                          height: 0.5,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.white,
                                Colors.black,
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                          ),
                        )
                      ],
                    );
                  },
                ),
              );
            },
          ),
          Positioned(
            bottom: 10,
            left: 10,
            child: ChoiceChip(
              selectedColor: Colors.grey[900],
              avatar: CircleAvatar(
                radius: 15,
                backgroundColor: Colors.black,
                child: Icon(
                  Icons.music_note,
                  size: 20,
                  color: Colors.white,
                ),
              ), 
              selected: true,
              label: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Music label without extension.",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "01:00:34",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[300],
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}