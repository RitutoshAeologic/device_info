import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DeviceInfoPlus(),
    );
  }
}

class DeviceInfoPlus extends StatefulWidget {
  const DeviceInfoPlus({Key? key}) : super(key: key);

  @override
  State<DeviceInfoPlus> createState() => _DeviceInfoPlusState();
}

class _DeviceInfoPlusState extends State<DeviceInfoPlus> {
  String text = "Loading...";


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Device Info"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(20.0),
            child: ElevatedButton(
              child: Text('get info', style: TextStyle(fontSize: 18),
              ),
              onPressed: (){
                loadInfo();
                final snackBar = SnackBar(
                  content:  Text(text, style: TextStyle(fontSize: 18),),
                  action: SnackBarAction(
                    label: 'Undo',
                    onPressed: () {
                    },
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);

              },
            ),

          ),

        ],
      ),
    );
  }

  /// loads device info
  void loadInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      print('iOS - Running on ${iosInfo.utsname.machine}');  // e.g. "iPod7,1"
      setState(() {text = iosInfo.toMap().toString();});
    }
    else if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      print('Android - Running on ${androidInfo.model}');  // e.g. "Moto G (4)"
      setState(() {text = androidInfo.toMap().toString();});
    }
    else if (Platform.isMacOS) {
      MacOsDeviceInfo macOSInfo = await deviceInfo.macOsInfo;
      print(macOSInfo.toMap().toString());
      setState(() {text = macOSInfo.toMap().toString();});
    }
  }

}
class PhoneInfo{
  static final _phoneInfo = DeviceInfoPlugin();
  static Future<String> getPhoneInfo() async{

    if (Platform.isAndroid){
      final info = await _phoneInfo.androidInfo;
      return '${info.id} - ${info.model}';
    }
    else if (Platform.isIOS){
      final info = await _phoneInfo.iosInfo;
      return '${info.name} - ${info.model}';
    }
    else{
      throw UnimplementedError();
    }
  }
}