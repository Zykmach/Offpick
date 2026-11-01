-- Reference data: stores, categories, interests and trending searches.

insert into public.categories (id, name, icon, tint, groups, sort_order) values
  ('fashion', 'Fashion', 'shirt', 'green', '{men,women}', 0),
  ('beauty', 'Beauty', 'sparkles', 'pink', '{}', 1),
  ('electronics', 'Electronics', 'laptop', 'blue', '{}', 2),
  ('mobiles', 'Mobiles & Gadgets', 'phone', 'peach', '{}', 3);

insert into public.subcategories (id, name, category_id, group_id, icon, tint, sort_order) values
  ('men-shirts', 'Shirts', 'fashion', 'men', 'shirt', 'green', 0),
  ('men-tshirts', 'T-Shirts', 'fashion', 'men', 'tshirt', 'blue', 1),
  ('men-jeans', 'Jeans', 'fashion', 'men', 'jeans', 'peach', 2),
  ('men-shoes', 'Shoes', 'fashion', 'men', 'shoe', 'pink', 3),
  ('men-watches', 'Watches', 'fashion', 'men', 'watch', 'green', 4),
  ('women-kurtis', 'Kurtis', 'fashion', 'women', 'shirt', 'pink', 5),
  ('women-tops', 'Tops', 'fashion', 'women', 'shirt', 'blue', 6),
  ('women-handbags', 'Handbags', 'fashion', 'women', 'handbag', 'peach', 7),
  ('women-footwear', 'Footwear', 'fashion', 'women', 'shoe', 'pink', 8),
  ('women-jewellery', 'Jewellery', 'fashion', 'women', 'gem', 'green', 9),
  ('beauty-skincare', 'Skincare', 'beauty', '', 'droplet', 'green', 10),
  ('beauty-makeup', 'Makeup', 'beauty', '', 'palette', 'pink', 11),
  ('beauty-haircare', 'Haircare', 'beauty', '', 'scissors', 'peach', 12),
  ('beauty-fragrance', 'Fragrance', 'beauty', '', 'spray', 'blue', 13),
  ('electronics-tv', 'TV', 'electronics', '', 'tv', 'blue', 14),
  ('electronics-laptop', 'Laptop', 'electronics', '', 'laptop', 'green', 15),
  ('electronics-camera', 'Camera', 'electronics', '', 'camera', 'peach', 16),
  ('electronics-audio', 'Audio', 'electronics', '', 'headphones', 'pink', 17),
  ('mobiles-phones', 'Phones', 'mobiles', '', 'phone', 'peach', 18),
  ('mobiles-earbuds', 'Earbuds', 'mobiles', '', 'headphones', 'blue', 19),
  ('mobiles-smartwatch', 'Smartwatch', 'mobiles', '', 'watch', 'green', 20),
  ('mobiles-tablets', 'Tablets', 'mobiles', '', 'tablet', 'pink', 21),
  ('mobiles-powerbanks', 'Power banks', 'mobiles', '', 'battery', 'green', 22),
  ('mobiles-accessories', 'Accessories', 'mobiles', '', 'cable', 'blue', 23);

insert into public.stores (id, name, monogram, featured, search_url, sort_order) values
  ('amazon', 'Amazon', 'A', true, 'https://www.amazon.in/s?k={q}', 0),
  ('flipkart', 'Flipkart', 'F', true, 'https://www.flipkart.com/search?q={q}', 1),
  ('myntra', 'Myntra', 'M', true, 'https://www.myntra.com/{q}', 2),
  ('ajio', 'AJIO', 'Aj', true, 'https://www.ajio.com/search/?text={q}', 3),
  ('purplle', 'Purplle', 'P', true, 'https://www.purplle.com/search?q={q}', 4),
  ('croma', 'Croma', 'C', false, 'https://www.croma.com/searchB?q={q}', 5);

insert into public.interests (id, label, icon, match_keys, sort_order) values
  ('men', 'Men''s fashion', 'shirt', '{fashion:men}', 0),
  ('women', 'Women''s fashion', 'bag', '{fashion:women}', 1),
  ('beauty', 'Beauty', 'sparkles', '{beauty}', 2),
  ('electronics', 'Electronics', 'laptop', '{electronics}', 3),
  ('mobiles', 'Mobiles & gadgets', 'phone', '{mobiles}', 4),
  ('watches', 'Watches', 'watch', '{men-watches,mobiles-smartwatch}', 5);

insert into public.trending_searches (rank, title, query, max_discount) values
  (1, 'Men''s casual shirts', 'shirt', 60),
  (2, 'Wireless earbuds', 'earbuds', 45),
  (3, 'Sunscreen SPF 50', 'sunscreen', 35),
  (4, 'Smartwatches', 'smartwatch', 50),
  (5, 'Kurtis', 'kurti', 70);
