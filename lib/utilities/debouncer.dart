import 'dart:async';
import 'dart:ui';

class Debouncer {
  Debouncer({required this.delay});
  Duration delay;
  Timer? _timer;
  VoidCallback? _callback;

  void debounce(VoidCallback? callback) {
    _callback = callback;
    cancel();
    _timer = Timer(delay, flush);
  }

  void cancel() {
    if (_timer != null) {
      _timer!.cancel();
    }
  }

  void flush() {
    _callback!();
    cancel();
  }
}
