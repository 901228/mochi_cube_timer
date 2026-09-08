import "package:args/args.dart";
import "package:nocterm/nocterm.dart";

import "pubspec.yaml.g.dart";
import "timer.dart";

void printUsage(ArgParser argParser) {
  print("Usage: dart tui.dart <flags> [arguments]");
  print(argParser.usage);
}

ArgResults? parseArgs(List<String> arguments) {
  final ArgParser argParser = ArgParser()
    ..addFlag("help", abbr: "h", negatable: false, help: "Print this usage information.")
    ..addFlag("version", negatable: false, help: "Print the tool version.");

  try {
    final ArgResults results = argParser.parse(arguments);

    // Process the parsed arguments.
    if (results.flag("help")) {
      printUsage(argParser);
      return null;
    }
    if (results.flag("version")) {
      print("${Pubspec.name} version: ${Pubspec.version.representation}");
      return null;
    }

    return results;
  } on FormatException catch (e) {
    // Print usage information if an invalid argument was provided.
    print(e.message);
    print("");
    printUsage(argParser);
  }

  return null;
}

void main(List<String> arguments) {
  final results = parseArgs(arguments);

  runApp(const Timer());
}
