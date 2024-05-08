import 'dart:typed_data';
import 'dart:io';

Future<File> byteDataToFile(ByteData byteData, String filename) async {
  // Convert ByteData to Uint8List
  Uint8List bytes = byteData.buffer
      .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);

  // Create a File object in memory
  File file = File(filename);

  // Write the bytes to the file
  await file.writeAsBytes(bytes);

  // Return the File object
  return file;
}

 ByteData uint8ListToByteData(Uint8List uint8List) {
  // Create a ByteBuffer from the Uint8List
  ByteBuffer buffer = uint8List.buffer;

  // Create a ByteData view of the ByteBuffer
  ByteData byteData = ByteData.view(buffer);

  return byteData;
}