/// Offers the mock server returns. Times are relative to when the app
/// started, so countdowns always look live.
/// Columns: id, brand, title, store, price, mrp, started minutes ago,
/// ends in seconds (-1 means next Sunday 11:59 PM), category,
/// subcategory, group, icon, tint, is new.
class MockOffers {
  static const List<List<Object>> rows = [
    ['levis-oxford', "Levi's", 'Slim Fit Oxford Shirt', 'myntra', 1199, 2499, 18, 8076, 'fashion', 'men-shirts', 'men', 'shirt', 'green', true],
    ['nike-casual', 'Nike', 'Nike Casual Shirt', 'flipkart', 1199, 1999, 140, 8076, 'fashion', 'men-shirts', 'men', 'shirt', 'blue', false],
    ['uspolo-linen', 'U.S. Polo', 'Linen Blend Shirt', 'ajio', 879, 2199, 70, 20530, 'fashion', 'men-shirts', 'men', 'shirt', 'peach', false],
    ['hm-denim', 'H&M', 'Regular Fit Denim Shirt', 'amazon', 1099, 1999, 160, -1, 'fashion', 'men-shirts', 'men', 'shirt', 'pink', false],
    ['sony-ch720n', 'Sony', 'Sony WH-CH720N', 'amazon', 7990, 12990, 25, 93600, 'electronics', 'electronics-audio', '', 'headphones', 'blue', true],
    ['puma-running', 'Puma', 'Puma Running Shoes', 'ajio', 2349, 4899, 300, 180000, 'fashion', 'men-shoes', 'men', 'shoe', 'pink', false],
    ['fastrack-watch', 'Fastrack', 'Fastrack Smartwatch', 'flipkart', 1799, 3995, 200, 270000, 'mobiles', 'mobiles-smartwatch', '', 'watch', 'green', false],
    ['lakme-sunscreen', 'Lakmé', 'Sun Expert Sunscreen SPF 50', 'purplle', 299, 460, 40, 32400, 'beauty', 'beauty-skincare', '', 'droplet', 'pink', true],
    ['boat-airdopes', 'boAt', 'Airdopes 141 Earbuds', 'amazon', 1099, 1999, 90, 108000, 'mobiles', 'mobiles-earbuds', '', 'headphones', 'blue', false],
    ['w-kurti', 'W', 'Printed Cotton Kurti', 'myntra', 749, 2499, 55, 25200, 'fashion', 'women-kurtis', 'women', 'shirt', 'pink', true],
    ['levis-511', "Levi's", '511 Slim Fit Jeans', 'myntra', 1599, 3299, 130, 180000, 'fashion', 'men-jeans', 'men', 'jeans', 'blue', false],
    ['allensolly-polo', 'Allen Solly', 'Polo Collar T-Shirt', 'ajio', 599, 1299, 35, 14400, 'fashion', 'men-tshirts', 'men', 'tshirt', 'peach', true],
    ['roadster-tee', 'Roadster', 'Graphic Print T-Shirt', 'myntra', 349, 999, 65, 61200, 'fashion', 'men-tshirts', 'men', 'tshirt', 'blue', false],
    ['titan-neo', 'Titan', 'Neo Analog Watch', 'amazon', 2495, 3995, 400, 270000, 'fashion', 'men-watches', 'men', 'watch', 'green', false],
    ['redmi-note13', 'Redmi', 'Redmi Note 13 5G', 'amazon', 16999, 20999, 600, 180000, 'mobiles', 'mobiles-phones', '', 'phone', 'peach', false],
    ['maybelline-fitme', 'Maybelline', 'Fit Me Matte Foundation', 'purplle', 399, 599, 220, 72000, 'beauty', 'beauty-makeup', '', 'palette', 'pink', false],
    ['hidesign-tote', 'Hidesign', 'Leather Tote Bag', 'myntra', 2899, 5799, 80, 100800, 'fashion', 'women-handbags', 'women', 'handbag', 'peach', false],
    ['only-top', 'ONLY', 'Ribbed Crop Top', 'myntra', 499, 1299, 15, 21600, 'fashion', 'women-tops', 'women', 'shirt', 'pink', true],
    ['bata-sandals', 'Bata', 'Comfit Sandals', 'ajio', 699, 1499, 150, 154800, 'fashion', 'women-footwear', 'women', 'shoe', 'pink', false],
    ['giva-pendant', 'Giva', 'Silver Heart Pendant', 'amazon', 1299, 2599, 240, 190800, 'fashion', 'women-jewellery', 'women', 'gem', 'peach', false],
    ['hp-15s', 'HP', 'HP 15s Laptop, Ryzen 5', 'flipkart', 38990, 52990, 500, 345600, 'electronics', 'electronics-laptop', '', 'laptop', 'blue', false],
    ['xiaomi-tv', 'Xiaomi', 'Smart TV X 43 inch', 'amazon', 24999, 42999, 260, 86400, 'electronics', 'electronics-tv', '', 'tv', 'green', false],
    ['canon-1500d', 'Canon', 'EOS 1500D DSLR Camera', 'flipkart', 34990, 41995, 700, 259200, 'electronics', 'electronics-camera', '', 'camera', 'peach', false],
    ['bellavita-set', 'Bella Vita', 'Luxury Perfume Gift Set', 'purplle', 449, 999, 100, 172800, 'beauty', 'beauty-fragrance', '', 'spray', 'blue', false],
    ['loreal-shampoo', "L'Oréal", 'Total Repair 5 Shampoo', 'amazon', 349, 599, 180, 259200, 'beauty', 'beauty-haircare', '', 'droplet', 'green', false],
    ['galaxy-tab', 'Samsung', 'Galaxy Tab A9', 'flipkart', 11999, 18999, 320, 216000, 'mobiles', 'mobiles-tablets', '', 'tablet', 'blue', false],
  ];

  /// Hand-written comparisons that match the designs.
  /// Columns: store, price, mrp, ends in seconds.
  static const Map<String, Map<String, Object>> comparisons = {
    'nike-casual': {
      'variant': 'Size M · Navy',
      'viewing': 'flipkart',
      'prices': [
        ['myntra', 999, 1999, 19200],
        ['ajio', 1049, 1999, 93600],
        ['flipkart', 1199, 1999, 8076],
        ['amazon', 1299, 1999, 262800],
      ],
    },
    'sony-ch720n': {
      'variant': 'Black · Wireless',
      'viewing': 'flipkart',
      'prices': [
        ['amazon', 7990, 12990, 93600],
        ['croma', 8490, 12990, 180000],
        ['flipkart', 8990, 12990, 43200],
      ],
    },
    'puma-running': {
      'variant': 'UK 9 · Black',
      'viewing': 'amazon',
      'prices': [
        ['ajio', 2349, 4899, 180000],
        ['myntra', 2599, 4899, 93600],
        ['flipkart', 2799, 4899, 50400],
        ['amazon', 2999, 4899, 262800],
      ],
    },
    'fastrack-watch': {
      'variant': 'Black strap',
      'viewing': 'flipkart',
      'prices': [
        ['flipkart', 1799, 3995, 270000],
        ['amazon', 1799, 3995, 180000],
      ],
    },
  };
}
