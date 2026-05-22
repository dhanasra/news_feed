extension DateTimeAgoExtension on DateTime {
  String get timeAgo {
    final diff = DateTime.now().difference(this);

    if (diff.inSeconds < 60) {
      return '${diff.inSeconds} seconds ago';
    }

    if (diff.inMinutes < 60) {
      return '${diff.inMinutes} minute${diff.inMinutes > 1 ? 's' : ''} ago';
    }

    if (diff.inHours < 24) {
      return '${diff.inHours} hour${diff.inHours > 1 ? 's' : ''} ago';
    }

    if (diff.inDays < 30) {
      return '${diff.inDays} day${diff.inDays > 1 ? 's' : ''} ago';
    }

    if (diff.inDays < 365) {
      final months = (diff.inDays / 30).floor();
      return '$months month${months > 1 ? 's' : ''} ago';
    }

    final years = (diff.inDays / 365).floor();
    return '$years year${years > 1 ? 's' : ''} ago';
  }
}