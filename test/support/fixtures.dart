/// Sample data shaped like the Supabase views and the "offers" function.
/// Titles are long on purpose so layout problems show up in tests.
class Fixtures {
  static Map<String, dynamic> sub(String id, String name, String categoryId, String groupId, String icon) {
    return {'id': id, 'name': name, 'categoryId': categoryId, 'groupId': groupId, 'icon': icon, 'tint': 'green'};
  }

  static List<Map<String, dynamic>> get categories => [
        {
          'id': 'fashion',
          'name': 'Fashion',
          'icon': 'shirt',
          'tint': 'green',
          'groups': ['men', 'women'],
          'subcategories': [
            sub('men-shirts', 'Shirts', 'fashion', 'men', 'shirt'),
            sub('men-tshirts', 'T-Shirts', 'fashion', 'men', 'tshirt'),
            sub('men-shoes', 'Shoes', 'fashion', 'men', 'shoe'),
            sub('women-kurtis', 'Kurtis', 'fashion', 'women', 'shirt'),
            sub('women-jewellery', 'Jewellery', 'fashion', 'women', 'gem'),
          ],
        },
        {
          'id': 'beauty',
          'name': 'Beauty',
          'icon': 'sparkles',
          'tint': 'pink',
          'subcategories': [sub('beauty-skincare', 'Skincare', 'beauty', '', 'droplet')],
        },
        {
          'id': 'electronics',
          'name': 'Electronics',
          'icon': 'laptop',
          'tint': 'blue',
          'subcategories': [sub('electronics-audio', 'Audio', 'electronics', '', 'headphones')],
        },
        {
          'id': 'mobiles',
          'name': 'Mobiles & Gadgets',
          'icon': 'phone',
          'tint': 'peach',
          'subcategories': [sub('mobiles-earbuds', 'Earbuds', 'mobiles', '', 'headphones')],
        },
      ];

  static List<Map<String, dynamic>> get stores => [
        for (final name in ['Amazon', 'Flipkart', 'Myntra', 'AJIO', 'Purplle', 'Croma'])
          {
            'id': name.toLowerCase(),
            'name': name,
            'monogram': name[0],
            'featured': true,
            'searchUrl': 'https://example.com/search?q={q}',
          },
      ];

  static List<Map<String, dynamic>> get interests => [
        {'id': 'men', 'label': "Men's fashion", 'icon': 'shirt', 'matchKeys': ['fashion:men']},
        {'id': 'women', 'label': "Women's fashion", 'icon': 'bag', 'matchKeys': ['fashion:women']},
        {'id': 'beauty', 'label': 'Beauty', 'icon': 'sparkles', 'matchKeys': ['beauty']},
        {'id': 'electronics', 'label': 'Electronics', 'icon': 'laptop', 'matchKeys': ['electronics']},
        {'id': 'mobiles', 'label': 'Mobiles & gadgets', 'icon': 'phone', 'matchKeys': ['mobiles']},
        {'id': 'watches', 'label': 'Watches', 'icon': 'watch', 'matchKeys': ['men-watches']},
      ];

  static List<Map<String, dynamic>> get trending => [
        {'rank': 1, 'title': "Men's casual shirts and linen summer wear", 'query': 'shirt', 'maxDiscount': 60},
        {'rank': 2, 'title': 'Wireless earbuds', 'query': 'earbuds', 'maxDiscount': 45},
        {'rank': 3, 'title': 'Sunscreen SPF 50', 'query': 'sunscreen', 'maxDiscount': 35},
      ];

  static Map<String, dynamic> offer(
    String id,
    String store,
    String title,
    String subcategoryId, {
    int? price,
    int? mrp,
    int discount = 0,
    String code = '',
    Duration endsIn = const Duration(hours: 5),
  }) {
    final category = subcategoryId.split('-').first;
    return {
      'id': id,
      'brand': store,
      'title': title,
      'storeId': store.toLowerCase().replaceAll(' ', '-'),
      'storeName': store,
      'price': price,
      'mrp': mrp,
      'discount': discount,
      'couponCode': code,
      'description': 'Get extra savings on the whole range. Valid on orders above Rs. 999, once per user.',
      'terms': 'Applicable only on the app for new users. Cannot be combined with other offers.',
      'url': 'https://example.com/deal/$id',
      'startedAt': DateTime.now().subtract(const Duration(hours: 1)).toIso8601String(),
      'endsAt': DateTime.now().add(endsIn).toIso8601String(),
      'categoryId': category == 'men' || category == 'women' ? 'fashion' : category,
      'subcategoryId': subcategoryId,
      'groupId': category == 'men' || category == 'women' ? category : '',
      'icon': 'shirt',
      'tint': 'blue',
      'isNew': true,
    };
  }

  static List<Map<String, dynamic>> get offers => [
        offer('cl-1', 'Pantaloons', 'Unmatched Deals on Men\'s Ethnic Fashion and Festive Kurtas – Shop Now!',
            'men-shirts', discount: 60, code: 'FESTIVE60'),
        offer('cl-2', 'Myntra', 'Slim Fit Oxford Shirt', 'men-shirts', price: 1199, mrp: 2499),
        offer('cl-3', 'Sugar Cosmetics International', 'Flat 20% off on the complete matte lipstick collection',
            'beauty-skincare', discount: 20, endsIn: const Duration(days: 12)),
        offer('cl-4', 'boAt', 'Airdopes 141 with 42 hours playback, ENx noise cancellation and fast charge',
            'mobiles-earbuds', price: 124999, mrp: 249999, endsIn: const Duration(minutes: 40)),
        offer('cl-5', 'Khadim', 'Score incredible deals on loafers', 'men-shoes'),
        offer('cl-6', 'Biba', 'Women kurtis festive edit', 'women-kurtis', discount: 45, code: 'BIBAFESTIVEMEGA2026'),
      ];

  static Map<String, dynamic> get alert => {
        'id': 'alert-1',
        'target': 'category',
        'targetId': 'men-shirts',
        'title': "Men's Shirts and Casual Summer Linen Wear",
        'detail': '2 new today',
        'icon': 'grid',
        'tint': 'green',
        'triggers': ['newOffer', 'discount30', 'priceDrop', 'endingSoon'],
        'isActive': true,
      };
}
