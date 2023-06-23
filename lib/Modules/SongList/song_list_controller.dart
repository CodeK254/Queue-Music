import "package:get/get.dart";

class SonglistController extends GetxController{
  final songList = [].obs;

  void setSongList(List data){
    songList.value = data;
  }
}