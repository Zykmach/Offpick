/// The filter chips under the search bar on Home.
class HomeChipModel {
  static const String forYou = 'for-you';

  final String id;
  final String label;

  const HomeChipModel(this.id, this.label);

  static const List<HomeChipModel> all = [
    HomeChipModel(forYou, 'For you'),
    HomeChipModel('fashion', 'Fashion'),
    HomeChipModel('beauty', 'Beauty'),
    HomeChipModel('electronics', 'Electronics'),
    HomeChipModel('mobiles', 'Mobiles'),
  ];
}
