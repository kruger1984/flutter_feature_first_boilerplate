import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class Cache {
  String tag;

  Cache({
    this.tag = '',
  });

  /// Папка для кэша под конкретный tag
  Future<Directory> _getCacheDir() async {
    // можно использовать getApplicationSupportDirectory / getApplicationDocumentsDirectory
    final baseDir = await getApplicationSupportDirectory();
    final dir = Directory(p.join(baseDir.path, 'cache_$tag'));

    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }

    return dir;
  }

  String _generateFilename({String? key}) {
    return '1__${tag}__$key.json';
  }

  /// Полный путь к файлу кэша для ключа
  Future<File> _getFile(String key) async {
    final dir = await _getCacheDir();
    final filename = _generateFilename(key: key);
    return File(p.join(dir.path, filename));
  }

  /// Удалить все записи этого tag
  Future<void> flush() async {
    final dir = await _getCacheDir();

    if (!await dir.exists()) return;

    await for (final entity in dir.list()) {
      if (entity is File) {
        try {
          await entity.delete();
        } catch (_) {
          // игнорируем ошибки удаления
        }
      }
    }
  }

  /// Удалить конкретный ключ или весь tag, если key пустой/нет
  Future<void> forget({String? key}) async {
    // Поведение как раньше: если key пустой -> удалить все данные этого tag
    if (key == null || key.isEmpty) {
      await flush();
      return;
    }

    final file = await _getFile(key);
    if (await file.exists()) {
      try {
        await file.delete();
      } catch (_) {
        // игнорируем
      }
    }
  }

  /// Получить данные по ключу
  Future<dynamic> get({required String key}) async {
    final file = await _getFile(key);

    if (!await file.exists()) {
      return null;
    }

    try {
      final content = await file.readAsString();
      final data = jsonDecode(content) as Map<String, dynamic>;

      final expiredAt = data['expired_at'] as int?;
      final now = DateTime.now().millisecondsSinceEpoch;

      if (expiredAt != null && now < expiredAt) {
        return data['data'];
      } else {
        // просрочено или нет поля — удаляем
        try {
          await file.delete();
        } catch (_) {}
        return null;
      }
    } catch (_) {
      // файл битый — удаляем
      try {
        await file.delete();
      } catch (_) {}
      return null;
    }
  }

  /// Добавить/обновить запись в кэше
  Future<void> add({
    required String key,
    required dynamic value,
    int? seconds,
    DateTime? expiredAt,
  }) async {
    final file = await _getFile(key);

    int expiredAtMilliseconds;
    if (expiredAt != null) {
      expiredAtMilliseconds = expiredAt.millisecondsSinceEpoch;
    } else if (seconds != null) {
      expiredAtMilliseconds =
          DateTime.now().millisecondsSinceEpoch + seconds * 1000;
    } else {
      expiredAtMilliseconds = DateTime(2100).millisecondsSinceEpoch;
    }

    final data = {
      'expired_at': expiredAtMilliseconds,
      'data': value,
    };

    final jsonStr = jsonEncode(data);

    // Дополнительно можно поставить лимит на размер, чтобы не кэшировать гигантские объекты
    const maxSizeBytes = 5 * 1024 * 1024; // например, 5 МБ
    if (jsonStr.length > maxSizeBytes) {
      // слишком большой объект — не кэшируем, но и не падаем
      return;
    }

    await file.writeAsString(jsonStr, flush: true);
  }

  /// Запомнить результат callback
  Future<dynamic> remember({
    required String key,
    required Function() callback,
    int? seconds,
    DateTime? expiredAt,
  }) async {
    dynamic data = await get(key: key);

    if (data == null) {
      // поддерживаем и sync, и async callback
      data = await Future.value(callback());
      await add(
        key: key,
        value: data,
        seconds: seconds,
        expiredAt: expiredAt,
      );
    }

    return data;
  }
}
