class BubbleData {
  BubbleData({
    required this.code,
    required this.originalText,
    this.translatedText = '',
  });

  String code;
  String originalText;
  String translatedText;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BubbleData &&
          runtimeType == other.runtimeType &&
          code == other.code &&
          originalText == other.originalText;

  @override
  int get hashCode => Object.hash(runtimeType, originalText, code);

  factory BubbleData.fromJson(Map<String, dynamic> json) => BubbleData(
        code: json['code'] ?? '',
        originalText: json['text'] ?? '',
        translatedText: json['translation'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'code': code,
        'originalText': originalText,
        'translation': translatedText,
      };
}
