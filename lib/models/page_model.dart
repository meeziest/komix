class PageModel {
  final int pageId;
  String filePath;
  bool isTranslated;

  PageModel({required this.pageId, required this.filePath, this.isTranslated = false});
}
