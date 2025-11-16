class SampleItem {
  final int id;
  final String title;
  final String description;
  SampleItem({required this.id, required this.title, required this.description});
  factory SampleItem.fromJson(Map<String, dynamic> j) => SampleItem(id: j['id'], title: j['title'], description: j['description']);
}