import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class APIServices {
  static Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static Map<String, dynamic> defaultError = {
    "status": "Failed",
    "message": "An error occured, please try again"
  };

  Future<File> downloadFile(String url) async {
    final response = await http.get(Uri.parse(url));
    final directory = await getTemporaryDirectory();

    final file = File('${directory.path}/${url.split("/").last}');

    await file.writeAsBytes(response.bodyBytes);
    print(
        'File downloaded and saved to ${directory.path}/${url.split("/").last}');
    return file;
  }
}
