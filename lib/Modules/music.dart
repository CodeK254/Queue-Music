import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:queue_music/Modules/layouts.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:queue_music/Modules/Playing/now_playing.dart';

class Music extends StatefulWidget {
  const Music({super.key});

  @override
  State<Music> createState() => _MusicState();
}

class _MusicState extends State<Music> {

  final OnAudioQuery _audioQuery = OnAudioQuery();
  final AudioPlayer _audioPlayer = AudioPlayer();

  String toDate(int? milisecs){
    var date = DateTime.fromMicrosecondsSinceEpoch(milisecs!);

    return date.toString();
  }

  void requestPermission(){
    Permission.storage.request();
  }

  @override
  void initState(){
    super.initState();

    requestPermission();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: appBarTheme("Queue_music", Icons.queue_music, true, context),
      body: FutureBuilder<List<SongModel>>(
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
                return ListTile(
                  onTap: (){
                    Get.toNamed(
                      "/player",
                      arguments: {
                        "songToPlay": items.data![index],
                        "audioPlayer": _audioPlayer,
                        "songList": items.data,
                      },
                    );
                  },
                  leading: Icon(
                    Icons.music_note,
                    color: Colors.grey.shade300,
                  ),
                  title: Text(
                    items.data![index].displayNameWOExt,
                    style: GoogleFonts.rancho(
                      fontSize: 18,
                      color: Colors.white,
                      letterSpacing: 1.2
                    ),
                  ),
                  subtitle: Text(
                    items.data![index].artist.toString() == "<unknown>" ? "Unknown Artist" : items.data![index].artist.toString(),
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.rancho(
                      fontSize: 15,
                      color: Colors.grey.shade500,
                      letterSpacing: 1.2
                    ),
                  ),
                  trailing: const Icon(
                    Icons.more_horiz,
                    color: Colors.white,
                    size: 25,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}