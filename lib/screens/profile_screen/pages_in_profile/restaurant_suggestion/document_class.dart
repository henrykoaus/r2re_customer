class DocumentData {
  final String name;
  final String addressName;
  final String category;

  DocumentData({
    required this.name,
    required this.addressName,
    required this.category,
  });

  factory DocumentData.fromJson(Map<String, dynamic> json) {
    return DocumentData(
      name: json['place_name'],
      addressName: json['address_name'],
      category: json['category_name'],
    );
  }
}