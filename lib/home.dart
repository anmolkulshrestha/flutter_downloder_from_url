import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ReceivePort _port = ReceivePort();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    IsolateNameServer.registerPortWithName(_port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];
      setState((){ });
    });

    FlutterDownloader.registerCallback(downloadCallback);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();

  }
  static void downloadCallback(String id, DownloadTaskStatus status, int progress) {
    final SendPort? send = IsolateNameServer.lookupPortByName('downloader_send_port');
    send?.send([id, status, progress]);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FlatButton(onPressed: ()  async{
      final externalDir=await getExternalStorageDirectory();
print("hello");
      final status=await Permission.storage.request();
      print("hello");
      if(status.isGranted==true) {
        print("hello");
      var taskid=  await FlutterDownloader.enqueue(

url: "https://cdn.britannica.com/97/1597-050-008F30FA/Flag-India.jpg",
        savedDir: externalDir!.path,

          showNotification: true, // show download progress in status bar (for Android)
          openFileFromNotification: true, // click on notification to open downloaded file (for Android)
        );

          }}, child: Text("Start Downloading"))
        ],
      ),
    );
  }
}
