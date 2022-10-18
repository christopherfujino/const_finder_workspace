import 'dart:io' as io;
import 'dart:convert';

final String HOME = io.Platform.environment['HOME']!;
final String ENGINE_ROOT = '$HOME/git/engine/src';
final String DART = '$ENGINE_ROOT/out/host_debug_unopt/dart-sdk/bin/dart';
final String CONST_FINDER =
    '$ENGINE_ROOT/flutter/tools/const_finder/bin/main.dart';

Future<void> main(List<String> args) async {
  if (args.length != 1) {
    throw StateError('Usage: dart const_finder.dart <path/to/dill>');
  }

  final ConstBlob blob =
      await findConsts(args.first, (String msg) => print(msg));

  print(blob.toString());

  final io.File outputFile = io.File('./const_finder.out.json')..writeAsStringSync(blob.blob!);
  print('wrote file ${outputFile.path} to disk.');
}

Future<ConstBlob> findConsts(
    String appDillPath, void Function(String) debugger) async {
  if (!io.File(appDillPath).existsSync()) {
    throw StateError('$appDillPath did not exist on disk!');
  }
  final io.Process process = await io.Process.start(
    DART,
    <String>[
      '--disable-dart-dev',
      CONST_FINDER,
      '--kernel-file',
      appDillPath,
      '--class-library-uri',
      'package:flutter/src/widgets/icon_data.dart',
      //'file:///usr/local/google/home/fujino/git/const_finder_workspace/tools/lib.dart',
      '--class-name',
      'IconData',
      //'FooBar',
    ],
  );

  process.stderr.transform(utf8.decoder).transform(const LineSplitter()).listen(
        debugger,
      );
  final stdout = (await process.stdout.transform(utf8.decoder).toList()).join();
  final int exitCode = await process.exitCode;

  if (exitCode != 0) {
    throw 'const_finder bin exited non-zero';
  }

  return ConstBlob.fromString(stdout);
}

class ConstBlob {
  ConstBlob(this.constantInstances, this.nonConstantLocations,
      {this.blob});

  final List<Object?> constantInstances;
  final List<Object?> nonConstantLocations;
  final String? blob;

  factory ConstBlob.fromString(String serialized) {
    final json = jsonDecode(serialized);

    return ConstBlob(
      json['constantInstances'] as List<Object?>,
      json['nonConstantLocations'] as List<Object?>,
      blob: JsonEncoder.withIndent('  ').convert(json),
    );
  }

  @override
  String toString() {
    final buffer = StringBuffer();
    int constInstances = constantInstances.length;

    //for (final instance in constantExpressions) {
    //  constExpressions += 1;
    //  buffer.write('\tlocation: ${(instance as Map<String, Object?>)['location']}');
    //  buffer.write('\tcodePoint: ${(instance as Map<String, Object?>)['codePoint']!}');
    //  buffer.write('\tfontFamily: ${instance['fontFamily']!}');
    //  buffer.write('\tfontPackage: ${instance['fontPackage']}');
    //  buffer.write('\tmatchTextDirection: ${instance['matchTextDirection']}');
    //  buffer.writeln();
    //}
    //for (final instance in constantInstances) {
    //  constInstances += 1;
    //  buffer.write('\tcodePoint: ${(instance as Map<String, Object?>)['codePoint']!}');
    //  buffer.write('\tfontFamily: ${instance['fontFamily']!}');
    //  buffer.write('\tfontPackage: ${instance['fontPackage']}');
    //  buffer.write('\tmatchTextDirection: ${instance['matchTextDirection']}');
    //  buffer.writeln();
    //}

    //if (nonConstantLocations.isNotEmpty) {
    //  buffer.writeln('nonConstantLocations');
    //  for (final instance in nonConstantLocations) {
    //    buffer.write('\t${(instance as Map<String, Object?>)['file']!}');
    //    buffer.write('\tline: ${instance['line']!}');
    //    buffer.write('\tcol: ${instance['column']!}');
    //  }
    //}

    buffer.writeln(blob!.toString());

    buffer.writeln('\n\nFound $constInstances ConstantInstances.');
    return buffer.toString();
  }
}
