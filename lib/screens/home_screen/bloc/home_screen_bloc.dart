import 'dart:typed_data';

import 'package:flutter_audio_capture/flutter_audio_capture.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guitar_tuning_app/screens/home_screen/bloc/home_screen_event.dart';
import 'package:guitar_tuning_app/screens/home_screen/bloc/home_screen_state.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pitch_detector_dart/pitch_detector.dart';
import 'package:pitchupdart/instrument_type.dart';
import 'package:pitchupdart/pitch_handler.dart';

class HomeScreenBloc extends Bloc<HomeScreenEvent, HomeScreenState> {
  final _audioRecorder = FlutterAudioCapture();
  final pitchDetectorDart = PitchDetector(44100, 2000);
  final pitchupDart = PitchHandler(InstrumentType.guitar);

  Future<bool> isPermissionGranted() async {
    var status = await Permission.microphone.status;
    if (status.isDenied) {
      var audioPermission = await Permission.microphone.request();
      if (audioPermission.isDenied || audioPermission.isPermanentlyDenied) {
        openAppSettings();
        return false;
      }
    }
    return true;
  }

  Future<void> _startRecord() async {}

  void listener(dynamic obj) {
    var buffer = Float64List.fromList(obj.cast<double>());
    final List<double> audioSample = buffer.toList();

    final result = pitchDetectorDart.getPitch(audioSample);

    if (result.pitched) {
      final handledPitchResult = pitchupDart.handlePitch(result.pitch);
      emit(HomeScreenRecordingState(
          handledPitchResult.tuningStatus.toString(), handledPitchResult.note));
    }
  }

  void error(Object e) {
    print(e);
  }

  HomeScreenBloc() : super(HomeScreenNotRecordingState("Start Recording", "")) {
    on<HomeScreenStartRecordingEvent>((event, emit) async {
      if (await isPermissionGranted()) {
        await _audioRecorder.start(listener, error,
            sampleRate: 44100, bufferSize: 3000);
        emit(HomeScreenIdleRecordingState("Play Something", ""));
      }
    });

    on<HomeScreenStopRecordingEvent>((event, emit) async {
      await _audioRecorder.stop();
      emit(HomeScreenNotRecordingState("Start Recording", ""));
    });
  }
}
