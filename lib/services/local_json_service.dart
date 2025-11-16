import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/sample_item.dart';


class LocalJsonService {
  Future<List<SampleItem>> loadSampleItems() async {
    final raw = await rootBundle.loadString('assets/data/sample.json');
    final List data = jsonDecode(raw);
    return data.map((e) => SampleItem.fromJson(e)).toList();
  }
}