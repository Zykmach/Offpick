/// Static catalog data the mock server returns:
/// categories, stores, interests and trending searches.
class MockCatalog {
  static Map<String, dynamic> sub(String id, String name, String categoryId, String groupId, String icon, String tint, int count) {
    return {
      'id': id,
      'name': name,
      'categoryId': categoryId,
      'groupId': groupId,
      'icon': icon,
      'tint': tint,
      'offerCount': count,
    };
  }

  static List<Map<String, dynamic>> get categories => [
        {
          'id': 'fashion',
          'name': 'Fashion',
          'icon': 'shirt',
          'tint': 'green',
          'liveOffers': 412,
          'groups': ['men', 'women'],
          'subcategories': [
            sub('men-shirts', 'Shirts', 'fashion', 'men', 'shirt', 'green', 86),
            sub('men-tshirts', 'T-Shirts', 'fashion', 'men', 'tshirt', 'blue', 124),
            sub('men-jeans', 'Jeans', 'fashion', 'men', 'jeans', 'peach', 58),
            sub('men-shoes', 'Shoes', 'fashion', 'men', 'shoe', 'pink', 73),
            sub('men-watches', 'Watches', 'fashion', 'men', 'watch', 'green', 41),
            sub('women-kurtis', 'Kurtis', 'fashion', 'women', 'shirt', 'pink', 96),
            sub('women-tops', 'Tops', 'fashion', 'women', 'shirt', 'blue', 88),
            sub('women-handbags', 'Handbags', 'fashion', 'women', 'handbag', 'peach', 54),
            sub('women-footwear', 'Footwear', 'fashion', 'women', 'shoe', 'pink', 61),
            sub('women-jewellery', 'Jewellery', 'fashion', 'women', 'gem', 'green', 47),
          ],
        },
        {
          'id': 'beauty',
          'name': 'Beauty',
          'icon': 'sparkles',
          'tint': 'pink',
          'liveOffers': 186,
          'subcategories': [
            sub('beauty-skincare', 'Skincare', 'beauty', '', 'droplet', 'green', 64),
            sub('beauty-makeup', 'Makeup', 'beauty', '', 'palette', 'pink', 52),
            sub('beauty-haircare', 'Haircare', 'beauty', '', 'scissors', 'peach', 38),
            sub('beauty-fragrance', 'Fragrance', 'beauty', '', 'spray', 'blue', 32),
          ],
        },
        {
          'id': 'electronics',
          'name': 'Electronics',
          'icon': 'laptop',
          'tint': 'blue',
          'liveOffers': 97,
          'subcategories': [
            sub('electronics-tv', 'TV', 'electronics', '', 'tv', 'blue', 18),
            sub('electronics-laptop', 'Laptop', 'electronics', '', 'laptop', 'green', 27),
            sub('electronics-camera', 'Camera', 'electronics', '', 'camera', 'peach', 14),
            sub('electronics-audio', 'Audio', 'electronics', '', 'headphones', 'pink', 38),
          ],
        },
        {
          'id': 'mobiles',
          'name': 'Mobiles & Gadgets',
          'icon': 'phone',
          'tint': 'peach',
          'liveOffers': 143,
          'subcategories': [
            sub('mobiles-phones', 'Phones', 'mobiles', '', 'phone', 'peach', 41),
            sub('mobiles-earbuds', 'Earbuds', 'mobiles', '', 'headphones', 'blue', 36),
            sub('mobiles-smartwatch', 'Smartwatch', 'mobiles', '', 'watch', 'green', 29),
            sub('mobiles-tablets', 'Tablets', 'mobiles', '', 'tablet', 'pink', 15),
            sub('mobiles-powerbanks', 'Power banks', 'mobiles', '', 'battery', 'green', 12),
            sub('mobiles-accessories', 'Accessories', 'mobiles', '', 'cable', 'blue', 10),
          ],
        },
      ];

  static List<Map<String, dynamic>> get stores => [
        {'id': 'amazon', 'name': 'Amazon', 'monogram': 'A', 'featured': true, 'searchUrl': 'https://www.amazon.in/s?k={q}'},
        {'id': 'flipkart', 'name': 'Flipkart', 'monogram': 'F', 'featured': true, 'searchUrl': 'https://www.flipkart.com/search?q={q}'},
        {'id': 'myntra', 'name': 'Myntra', 'monogram': 'M', 'featured': true, 'searchUrl': 'https://www.myntra.com/{q}'},
        {'id': 'ajio', 'name': 'AJIO', 'monogram': 'Aj', 'featured': true, 'searchUrl': 'https://www.ajio.com/search/?text={q}'},
        {'id': 'purplle', 'name': 'Purplle', 'monogram': 'P', 'featured': true, 'searchUrl': 'https://www.purplle.com/search?q={q}'},
        {'id': 'croma', 'name': 'Croma', 'monogram': 'C', 'featured': false, 'searchUrl': 'https://www.croma.com/searchB?q={q}'},
      ];

  static List<Map<String, dynamic>> get interests => [
        {'id': 'men', 'label': "Men's fashion", 'icon': 'shirt', 'matchKeys': ['fashion:men']},
        {'id': 'women', 'label': "Women's fashion", 'icon': 'bag', 'matchKeys': ['fashion:women']},
        {'id': 'beauty', 'label': 'Beauty', 'icon': 'sparkles', 'matchKeys': ['beauty']},
        {'id': 'electronics', 'label': 'Electronics', 'icon': 'laptop', 'matchKeys': ['electronics']},
        {'id': 'mobiles', 'label': 'Mobiles & gadgets', 'icon': 'phone', 'matchKeys': ['mobiles']},
        {'id': 'watches', 'label': 'Watches', 'icon': 'watch', 'matchKeys': ['men-watches', 'mobiles-smartwatch']},
      ];

  static List<Map<String, dynamic>> get trending => [
        {'rank': 1, 'title': "Men's casual shirts", 'query': 'shirt', 'maxDiscount': 60},
        {'rank': 2, 'title': 'Wireless earbuds', 'query': 'earbuds', 'maxDiscount': 45},
        {'rank': 3, 'title': 'Sunscreen SPF 50', 'query': 'sunscreen', 'maxDiscount': 35},
        {'rank': 4, 'title': 'Smartwatches', 'query': 'smartwatch', 'maxDiscount': 50},
        {'rank': 5, 'title': 'Kurtis', 'query': 'kurti', 'maxDiscount': 70},
      ];
}
