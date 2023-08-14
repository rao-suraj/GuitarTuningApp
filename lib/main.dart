import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_audio_capture/flutter_audio_capture.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pitch_detector_dart/pitch_detector.dart';
import 'package:pitchupdart/instrument_type.dart';
import 'package:pitchupdart/pitch_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Guitar Tuner App",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<StatefulWidget> createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  final _audioRecorder = FlutterAudioCapture();
  final pitchDetectorDart = PitchDetector(44100, 2000);
  final pitchupDart = PitchHandler(InstrumentType.guitar);

  var status = "click on start";
  var note = "";

  Future<void> _startRecord() async {
    if (await isPermissionGranted()) {
      await _audioRecorder.start(listener, onError,
          sampleRate: 44100, bufferSize: 3000);

      setState(() {
        note = "";
        status = "Play something";
      });
    }
  }

  Future<void> _stopRecord() async {
    await _audioRecorder.stop();

    setState(() {
      note = "";
      status = "Click on start";
    });
  }

  void listener(dynamic obj) {
    var buffer = Float64List.fromList(obj.cast<double>());
    final List<double> audioSample = buffer.toList();

    final result = pitchDetectorDart.getPitch(audioSample);

    if (result.pitched) {
      final handledPitchResult = pitchupDart.handlePitch(result.pitch);

      setState(() {
        note = handledPitchResult.note;
        status = handledPitchResult.tuningStatus.toString();
      });
    }
  }

  void onError(Object e) {
    print(e);
  }

  Future<bool> isPermissionGranted() async {
    // var audioPermission = await Permission.microphone.request();

    var status = await Permission.audio.status;
    if (status.isDenied) {
      var audioPermission = await Permission.microphone.request();
      if (audioPermission.isDenied || audioPermission.isPermanentlyDenied) {
        openAppSettings();
        return false;
      }
    }
    return true;

    // if (audioPermission.isGranted) {
    //   return true;
    // } else {
    //   return false;
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Guitar Tuning App"),
      ),
      body: Center(
        child: Column(
          children: [
            Center(
              child: Text(
                status,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Center(
              child: Text(
                note,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const Spacer(),
            Expanded(
                child: Row(
              children: [
                Expanded(
                    child: FloatingActionButton(
                  onPressed: _startRecord,
                  child: const Text("Start"),
                )),
                Expanded(
                    child: FloatingActionButton(
                  onPressed: _stopRecord,
                  child: const Text("Stop"),
                )),
              ],
            )),
          ],
        ),
      ),
    );
  }
}
