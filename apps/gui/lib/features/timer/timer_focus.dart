import "package:cube_timer/cube_timer.dart";
import "package:flutter_bloc/flutter_bloc.dart";

/// Whether a solve is running, so the shell around the timer can step aside.
class TimerFocusCubit extends Cubit<bool> {
  TimerFocusCubit() : super(false);

  void follow(TimerState state) => emit(state is TimerRunInInspection || state is TimerRunInProgress);
}
