import 'package:intl/intl.dart';

/// Turns numbers and dates into the text shown in the designs.
class Formatters {
  static final NumberFormat indianNumber = NumberFormat.decimalPattern('en_IN');

  /// 1199 -> ₹1,199
  static String price(int amount) => '₹${indianNumber.format(amount)}';

  static String twoDigits(int value) => value.toString().padLeft(2, '0');

  /// 02:14:36 (hours can go above 24)
  static String clock(Duration remaining) {
    if (remaining.isNegative) return '00:00:00';
    final hours = remaining.inHours;
    final minutes = remaining.inMinutes % 60;
    final seconds = remaining.inSeconds % 60;
    return '${twoDigits(hours)}:${twoDigits(minutes)}:${twoDigits(seconds)}';
  }

  /// 2h 14m left / 45m left
  static String timeLeft(Duration remaining) {
    if (remaining.inSeconds <= 0) return 'Ended';
    final hours = remaining.inHours;
    final minutes = remaining.inMinutes % 60;
    if (hours == 0) return '${minutes}m left';
    return '${hours}h ${minutes}m left';
  }

  /// Ends in 5h 20m / Ends in 1 day / Ends in 3 days
  static String endsIn(Duration remaining) {
    if (remaining.inSeconds <= 0) return 'Ended';
    if (remaining.inHours < 24) {
      final hours = remaining.inHours;
      final minutes = remaining.inMinutes % 60;
      return hours == 0 ? 'Ends in ${minutes}m' : 'Ends in ${hours}h ${minutes}m';
    }
    final days = remaining.inDays;
    return days == 1 ? 'Ends in 1 day' : 'Ends in $days days';
  }

  /// Long-running offers: "Ends in 2 days" or "Ends Sun, 11:59 PM"
  static String endsLabel(DateTime endsAt, DateTime now) {
    final remaining = endsAt.difference(now);
    if (remaining.inDays <= 2) return endsIn(remaining);
    return 'Ends ${DateFormat('EEE, h:mm a').format(endsAt)}';
  }

  /// Today, 9:00 AM / Yesterday, 6:00 PM / Sun, 11:59 PM
  static String dayAndTime(DateTime date, DateTime now) {
    final time = DateFormat('h:mm a').format(date);
    final today = DateTime(now.year, now.month, now.day);
    final day = DateTime(date.year, date.month, date.day);
    final difference = day.difference(today).inDays;
    if (difference == 0) return 'Today, $time';
    if (difference == -1) return 'Yesterday, $time';
    if (difference == 1) return 'Tomorrow, $time';
    return '${DateFormat('EEE').format(date)}, $time';
  }

  /// 18 min ago / 2 hr ago / 1 day ago
  static String ago(DateTime date, DateTime now) {
    final passed = now.difference(date);
    if (passed.inMinutes < 1) return 'just now';
    if (passed.inMinutes < 60) return '${passed.inMinutes} min ago';
    if (passed.inHours < 24) return '${passed.inHours} hr ago';
    return passed.inDays == 1 ? '1 day ago' : '${passed.inDays} days ago';
  }

  /// Short time used on notifications: 18m / 1h / Thu
  static String shortAgo(DateTime date, DateTime now) {
    final passed = now.difference(date);
    if (passed.inMinutes < 1) return 'now';
    if (passed.inMinutes < 60) return '${passed.inMinutes}m';
    if (passed.inHours < 24) return '${passed.inHours}h';
    return DateFormat('EEE').format(date);
  }

  /// Rahul Mehta -> RM
  static String initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+')).where((part) => part.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  /// 9876543210 -> 98765 43210
  static String phone(String digits) {
    if (digits.length != 10) return digits;
    return '${digits.substring(0, 5)} ${digits.substring(5)}';
  }
}
