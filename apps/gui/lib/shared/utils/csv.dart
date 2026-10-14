import "dart:convert" show utf8;
import "dart:typed_data" show Uint8List;

import "package:csv/csv.dart";

List<List<dynamic>> fromCsv(String text) {
  // The BOM `toCsv` writes, for Excel; it would otherwise stick to the first header.
  return Csv().decode(text.startsWith("\uFEFF") ? text.substring(1) : text);
}

Uint8List toCsv(List<List<dynamic>> rows) {
  final csvCodec = Csv(addBom: true);
  String csvString = csvCodec.encode(rows);

  List<int> csvBytes = utf8.encode(csvString);
  return Uint8List.fromList(csvBytes);
}
