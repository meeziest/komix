class PageData {
  PageData({
    required this.imagePath,
    this.isTranslated = false,
  });

  String imagePath;
  bool isTranslated;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PageData && runtimeType == other.runtimeType && imagePath == other.imagePath;

  @override
  int get hashCode => Object.hash(runtimeType, imagePath);

  factory PageData.fromJson(Map<String, dynamic> json) => PageData(
        imagePath: json['page_image_path'],
        isTranslated: json['is_translated'] ?? false,
      );

  Map<String, dynamic> toJson() => {
        'page_image_path': imagePath,
        'is_translated': isTranslated,
      };
}
