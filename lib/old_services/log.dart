import 'package:talker/talker.dart';

class Log {
  static final talker = Talker(
    settings: TalkerSettings(
      titles: {
        TalkerKey.error: '❌ ERROR',
        TalkerKey.exception: '🆘 CRITICAL',
        TalkerKey.info: '💡 INFO',
        TalkerKey.debug: '⚙️ DEBUG',
        TalkerKey.warning: '⚠️ WARNING',
        TalkerKey.verbose: '📝 VERBOSE',
      },
    ),
  );

  static void e(dynamic e, [StackTrace? st]) => talker.handle(e, st);

  static void i(String msg) => talker.info(msg);

  static void d(String msg) => talker.debug(msg);

  static void w(String msg) => talker.warning(msg);

  static void v(String msg) => talker.verbose(msg);

  static void log(String msg) => talker.log(msg);
}