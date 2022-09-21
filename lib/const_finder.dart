import 'dart:io' as io;
import 'dart:convert' show jsonDecode, utf8;

final String HOME = io.Platform.environment['HOME']!;
final String ENGINE_ROOT = '$HOME/git/engine/src';
final String DART = '$ENGINE_ROOT/out/host_debug_unopt/dart-sdk/bin/dart';
final String CONST_FINDER = '$ENGINE_ROOT/flutter/tools/const_finder/bin/main.dart';

Future<void> main(List<String> args) async {

  if (args.length != 1) {
    throw StateError('Usage: dart const_finder.dart <Path/to/hash>');
  }

  final ConstBlob blob = await _findConsts(args.first);

  print(blob);
}

Future<ConstBlob> _findConsts(String revision) async {
  final String APP_DILL = '$HOME/git/tmp/delete_me_flutter/.dart_tool/flutter_build/$revision/app.dill';
  if (!io.File(APP_DILL).existsSync()) {
    throw StateError('$APP_DILL did not exist on disk!');
  }
  final io.Process process = await io.Process.start(
    DART,
    <String>[
      '--disable-dart-dev',
      CONST_FINDER,
      '--kernel-file', APP_DILL,
      '--class-library-uri', 'package:flutter/src/widgets/icon_data.dart',
      '--class-name', 'IconData',
    ],
  );

  final stdout = (await process.stdout.transform(utf8.decoder).toList()).join();
  final stderrSub = process.stderr.transform(utf8.decoder).listen(
    (String msg) => print('[STDERR] $msg'),
  );
  await stderrSub.asFuture();
  final int exitCode = await process.exitCode;

  if (exitCode != 0) {
    throw 'foo bar!';
  }

  return ConstBlob.fromString(stdout);
}

class ConstBlob {
  ConstBlob(this.constantInstances, this.nonConstantLocations);

  final List<Object?> constantInstances;
  final List<Object?> nonConstantLocations;

  factory ConstBlob.fromString(String serialized) {
    final json = jsonDecode(serialized);

    return ConstBlob(
      json['constantInstances'] as List<Object?>,
      json['nonConstantLocations'] as List<Object?>,
    );
  }

  @override
  String toString() {
    final buffer = StringBuffer();

    buffer.writeln('constantInstances:');
    for (final instance in constantInstances) {
      buffer.write('\tcodePoint: ${(instance as Map<String, Object?>)['codePoint']!}');
      buffer.write('\tfontFamily: ${instance['fontFamily']!}');
      buffer.write('\tfontPackage: ${instance['fontPackage']}');
      buffer.write('\tmatchTextDirection: ${instance['matchTextDirection']}');
      buffer.writeln();
    }

    if (nonConstantLocations.isNotEmpty) {
      buffer.writeln('nonConstantLocations');
      for (final instance in nonConstantLocations) {
        buffer.write('\t${(instance as Map<String, Object?>)['file']!}');
        buffer.write('\tline: ${instance['line']!}');
        buffer.write('\tcol: ${instance['column']!}');
      }
    }

    return buffer.toString();
  }
}
