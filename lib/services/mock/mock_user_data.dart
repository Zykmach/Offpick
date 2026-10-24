/// Starter data for a new account, so the Compare and Alerts tabs
/// match the designs on first launch.
class MockUserData {
  static List<Map<String, dynamic>> get trackedProducts => [
        {'offerId': 'nike-casual'},
        {'offerId': 'sony-ch720n'},
        {'offerId': 'puma-running'},
        {'offerId': 'fastrack-watch'},
      ];

  static List<Map<String, dynamic>> get alerts => [
        {
          'id': 'alert-nike',
          'target': 'product',
          'targetId': 'nike-casual',
          'title': 'Nike Casual Shirt',
          'detail': 'all stores',
          'icon': 'shirt',
          'tint': 'blue',
          'triggers': ['priceDrop', 'discount50'],
          'isActive': true,
        },
        {
          'id': 'alert-men-shirts',
          'target': 'category',
          'targetId': 'men-shirts',
          'title': "Men's Shirts",
          'detail': '2 new today',
          'icon': 'grid',
          'tint': 'green',
          'triggers': ['newOffer', 'discount30'],
          'isActive': true,
        },
        {
          'id': 'alert-audio',
          'target': 'category',
          'targetId': 'electronics-audio',
          'title': 'Electronics › Audio',
          'detail': '',
          'icon': 'headphones',
          'tint': 'peach',
          'triggers': ['endingSoon'],
          'isActive': true,
        },
        {
          'id': 'alert-handbags',
          'target': 'category',
          'targetId': 'women-handbags',
          'title': 'Women › Handbags',
          'detail': '',
          'icon': 'bag',
          'tint': 'pink',
          'triggers': ['newOffer'],
          'isActive': false,
        },
      ];

  static List<Map<String, dynamic>> notifications(DateTime now) {
    final yesterday = DateTime(now.year, now.month, now.day - 1, 16, 20);
    return [
      {
        'id': 'note-1',
        'type': 'newOffer',
        'title': "New offer in Men's Shirts",
        'body': "Levi's shirt — 52% OFF · ₹2,499 → ₹1,199 on Myntra",
        'createdAt': now.subtract(const Duration(minutes: 18)).toIso8601String(),
        'isRead': false,
        'offerId': 'levis-oxford',
      },
      {
        'id': 'note-2',
        'type': 'priceDrop',
        'title': 'Price drop',
        'body': 'Nike Casual Shirt is now ₹999 on Myntra (was ₹1,199)',
        'createdAt': now.subtract(const Duration(hours: 1)).toIso8601String(),
        'isRead': false,
        'offerId': 'nike-casual',
      },
      {
        'id': 'note-3',
        'type': 'endingSoon',
        'title': 'Ending soon',
        'body': 'Sony WH-CH720N deal on Amazon ends in 1 hour',
        'createdAt': now.subtract(const Duration(hours: 3)).toIso8601String(),
        'isRead': true,
        'offerId': 'sony-ch720n',
      },
      {
        'id': 'note-4',
        'type': 'discount50',
        'title': 'Discount above 50%',
        'body': 'Puma Running Shoes — 52% OFF on AJIO',
        'createdAt': yesterday.toIso8601String(),
        'isRead': true,
        'offerId': 'puma-running',
      },
    ];
  }
}
