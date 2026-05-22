class TtlCache {
  final Map<String, DateTime> _timestamps = {};

  void setTimestamp(String key) {
    _timestamps[key] = DateTime.now();
  }

  bool isExpired(String key, int ttlMinutes) {
    final ts = _timestamps[key];
    if (ts == null) return true;
    return DateTime.now().difference(ts).inMinutes >= ttlMinutes;
  }

  void invalidate(String key) {
    _timestamps.remove(key);
  }
}