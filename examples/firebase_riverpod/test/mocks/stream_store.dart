import 'package:rxdart/rxdart.dart';

final class StreamStore<T> {
  final BehaviorSubject<T> _subject;

  Stream<T> get stream => _subject.stream;
  T get value => _subject.value;
  set value(T value) => _subject.add(value);
  void close() => _subject.close();

  StreamStore(T value) : _subject = BehaviorSubject<T>.seeded(value);
}
