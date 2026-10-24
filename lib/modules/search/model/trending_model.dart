class TrendingModel {
  final int rank;
  final String title;
  final String query;
  final int maxDiscount;

  const TrendingModel({
    required this.rank,
    required this.title,
    required this.query,
    required this.maxDiscount,
  });

  factory TrendingModel.fromJson(Map<String, dynamic> json) {
    return TrendingModel(
      rank: json['rank'] as int,
      title: json['title'] as String,
      query: json['query'] as String,
      maxDiscount: json['maxDiscount'] as int,
    );
  }
}
