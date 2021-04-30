import 'dart:async';

final activateLogColors = true; // Set to false to remove log colors

final log = Logger();

enum Level {
  debug,
  info,
  warning,
  error,
}

class Logger {
  Logger() {
    _controller.stream.listen(_handleRecord).onError((error) => print('Logger error : $error'));
  }

  final _controller = StreamController<LogRecord>();

  void d(String message) => _log(Level.debug, message);

  void i(String message) => _log(Level.info, message);

  void w(String message, [Object? error, StackTrace? trace]) => _log(Level.error, message, error, trace);

  void e(String message, [Object? error, StackTrace? trace]) => _log(Level.error, message, error, trace);

  void _log(Level level, String message, [Object? error, StackTrace? trace]) {
    final record = LogRecord(level, message, error, trace);
    _controller.add(record);
  }

  void _handleRecord(LogRecord record) {
    final prefix = _prefix(record.level);
    final error = record.error ?? '';
    print('$prefix ${record.message} $error');
    if (record.trace != null) {
      print('${record.trace}');
    }
  }

  String _prefix(Level level) {
    switch (level) {
      case Level.debug:
        return '🐛';
      case Level.info:
        return 'ℹ️';
      case Level.warning:
        return '⚠️';
      case Level.error:
        return '⛔️';
    }
  }

  void dispose() {
    _controller.close();
  }
}

class LogRecord {
  final Level level;
  final String message;
  final Object? error;
  final StackTrace? trace;

  LogRecord(this.level, this.message, this.error, this.trace);
}
