import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guitar_tuning_app/screens/home_screen/bloc/home_screen_bloc.dart';
import 'package:guitar_tuning_app/screens/home_screen/bloc/home_screen_event.dart';
import 'package:guitar_tuning_app/screens/home_screen/bloc/home_screen_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
              child: BlocBuilder<HomeScreenBloc, HomeScreenState>(
                  builder: (context, state) {
                if (state is HomeScreenNotRecordingState) {
                  return Text(
                    state.state,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold),
                  );
                } else if (state is HomeScreenRecordingState) {
                  return Text(
                    state.state,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold),
                  );
                } else if (state is HomeScreenIdleRecordingState) {
                  return Text(
                    state.state,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold),
                  );
                } else {
                  return Container();
                }
              }),
            ),
            Center(
              child: BlocBuilder<HomeScreenBloc, HomeScreenState>(
                  builder: (context, state) {
                if (state is HomeScreenNotRecordingState) {
                  return Text(
                    state.note,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold),
                  );
                } else if (state is HomeScreenRecordingState) {
                  return Text(
                    state.note,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold),
                  );
                } else if (state is HomeScreenIdleRecordingState) {
                  return Text(
                    state.note,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold),
                  );
                } else {
                  return Container();
                }
              }),
            ),
            const Spacer(),
            Expanded(
                child: Row(
              children: [
                Expanded(
                    child: FloatingActionButton(
                  onPressed: () => BlocProvider.of<HomeScreenBloc>(context)
                      .add(HomeScreenStartRecordingEvent()),
                  child: const Text("Start"),
                )),
                Expanded(
                    child: FloatingActionButton(
                  onPressed: () => BlocProvider.of<HomeScreenBloc>(context)
                      .add(HomeScreenStopRecordingEvent()),
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
