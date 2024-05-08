
import 'package:flutter/services.dart';

Future<Uint8List> getImageBytes(String gender, int number) async {
  String assetPath = 'assets/images/$gender$number.png';
  ByteData byteData = await rootBundle.load(assetPath);
  List<int> imageData = byteData.buffer.asUint8List();
  return Uint8List.fromList(imageData);
}

String getImagePath(String gender, int number) {
  return 'assets/images/$gender$number.png';
}
