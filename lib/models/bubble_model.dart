class BubbleModel {
  final int bubbleId;
  double dx;
  double dy;
  String originalText;
  String translationText;
  bool isTranslated;

  BubbleModel(
      {required this.bubbleId,
      required this.dx,
      required this.dy,
      this.originalText = '',
      this.translationText = '',
      this.isTranslated = false});
}
