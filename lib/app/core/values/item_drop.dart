import 'dart:math';

import 'package:SoloLife/app/core/utils/items_archive.dart';

// Define a function to select one item based on its probability
String selectItemByProbability(Map<String, double> itemProbabilities,) {
  List<String> items = archive.keys.toList();
  items.removeWhere((element)=> element.contains("Box"));
  if (items.isEmpty || itemProbabilities.isEmpty || items.length != itemProbabilities.length) {
    throw ArgumentError('List lengths must be non-zero and equal.');
  }
  
  final rand = Random();
  double cumulativeProbability = 0;

  for (var item in items) {
    cumulativeProbability += itemProbabilities[item]!;
    if (rand.nextDouble() < cumulativeProbability) {
      return item;
    }
  }

  // This should never be reached, but return the last item just in case.
  return items.last;
}