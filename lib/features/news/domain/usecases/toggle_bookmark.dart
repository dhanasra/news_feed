// Stub — extend with Hive persistence as needed
class ToggleBookmark {
  final Set<String> _bookmarked = {};

  bool toggle(String articleUrl) {
    if (_bookmarked.contains(articleUrl)) {
      _bookmarked.remove(articleUrl);
      return false;
    }
    _bookmarked.add(articleUrl);
    return true;
  }

  bool isBookmarked(String articleUrl) => _bookmarked.contains(articleUrl);
}