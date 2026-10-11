import "dart:convert" show utf8;
import "dart:typed_data" show Uint8List;

import "package:csv/csv.dart";

Uint8List toCsv(List<List<dynamic>> rows) {
  final csvCodec = Csv(addBom: true);
  String csvString = csvCodec.encode(rows);

  List<int> csvBytes = utf8.encode(csvString);
  return Uint8List.fromList(csvBytes);
}
