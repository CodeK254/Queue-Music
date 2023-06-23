import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

AppBar appBarTheme(String text, IconData icn, bool ishome, context){
  return AppBar(
    toolbarHeight: 65,
    backgroundColor: Colors.black,
    elevation: 1,
    shadowColor: Colors.white,
    iconTheme: IconThemeData(
      color: Colors.grey[300],
      size: 28,
    ),
    title: Row(
      children: [
        Text(
          "$text ",
          style: TextStyle(
            fontSize: 23,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(width: 5),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: const Icon(FontAwesomeIcons.list, size: 22),
        ),
      ],
    ),
    actions: [
      ishome == true ? Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: GestureDetector(
              onTap: (){
                Navigator.pushNamed(context, "/search");
              },
              child: const Icon(Icons.search),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: PopupMenuButton(
              itemBuilder: (context){
                return [];
              }
            ),
          ),
        ],
      ) : Container(),
    ],
  );
}

//---------------------------------- NOW PLAYING ----------------------------------------
Container iconTheme(IconData icn, {Color col = Colors.white}){
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      border: Border.all(color: Colors.grey.shade400, width: 2)
    ),
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Icon(
        icn,
        color: col,
        size: 35,
      ),
    ),
  );
}