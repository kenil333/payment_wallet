import 'dart:async';

class BoolStream {

  final _bool = StreamController<bool>.broadcast();
  StreamSink<bool> get boolsink => _bool.sink;
  Stream<bool> get boolstream => _bool.stream;

  void dispose() {
    _bool.close();
  }
}