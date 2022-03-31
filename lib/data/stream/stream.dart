import 'dart:async';

class StringStream {

  final _int = StreamController<int>.broadcast();
  StreamSink<int> get intsink => _int.sink;
  Stream<int> get intstream => _int.stream;

  void dispose() {
    _int.close();
  }
}