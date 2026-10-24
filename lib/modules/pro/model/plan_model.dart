import '../../../core/constants/app_constants.dart';

enum PlanModel {
  yearly('Yearly', 'Billed once a year', AppConstants.yearlyPrice, '/yr'),
  monthly('Monthly', 'Cancel anytime', AppConstants.monthlyPrice, '/mo');

  final String title;
  final String subtitle;
  final String price;
  final String period;
  const PlanModel(this.title, this.subtitle, this.price, this.period);
}
