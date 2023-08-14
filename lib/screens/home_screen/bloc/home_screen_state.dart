abstract class HomeScreenState {}

class HomeScreenIdleRecordingState extends HomeScreenState {
  final String state;
  final String note;
  HomeScreenIdleRecordingState(this.state, this.note);
}

class HomeScreenNotRecordingState extends HomeScreenState {
  final String state;
  final String note;
  HomeScreenNotRecordingState(this.state, this.note);
}

class HomeScreenRecordingState extends HomeScreenState {
  final String state;
  final String note;
  HomeScreenRecordingState(this.state, this.note);
}
