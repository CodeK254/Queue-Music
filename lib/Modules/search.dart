import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController _searchKey = TextEditingController();
  final OnAudioQuery _audioQuery = OnAudioQuery();
  List songs = [];
  bool search = false;

  void searchSongs(String search, List<SongModel> items){
    // print(search);
    // print(items.toString());
    for(int index = 0; index < items.length; index++){
      if(/*items[index].artist.toString() == _searchKey.text || */items[index].title == _searchKey.text){
        print(index);
        print(items[index].displayName);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.white,
        centerTitle: true,
        backgroundColor: Colors.black,
        // leading: Container(),
        title: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.0,
          ),
          child: TextFormField(
            controller: _searchKey,
            decoration: InputDecoration(
              fillColor: Colors.black54,
              hintText: "Search...",
              hintStyle: GoogleFonts.rancho(
                fontSize: 15,
                color: Colors.grey[400],
                letterSpacing: 1.5,
              ),
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    search == true;
                  });
                },
                child: Icon(
                  Icons.search,
                  size: 25,
                  color: Colors.white,
                ),
              ),
              contentPadding: EdgeInsets.only(left: 20),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Colors.white,
                  width: 0.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Colors.white,
                  width: 0.5,
                ),
              ),
            ),
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ),
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
              itemBuilder:(context, index) {
                return ListTile(
                  onTap: (){
                    // Navigator.push(
                    //   context, 
                    //   MaterialPageRoute(builder: (context)=> NowPlaying(songToPlay: items.data![index], audioPlayer: _audioPlayer))
                    // );
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