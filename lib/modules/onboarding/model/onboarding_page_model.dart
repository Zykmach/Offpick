class OnboardingPageModel {
  final String titleLineOne;
  final String titleLineTwo;
  final String message;

  const OnboardingPageModel({
    required this.titleLineOne,
    required this.titleLineTwo,
    required this.message,
  });

  static const List<OnboardingPageModel> pages = [
    OnboardingPageModel(
      titleLineOne: 'Every live deal.',
      titleLineTwo: 'One place.',
      message: "See offers the moment they start, compare the same product across stores, and buy where it's cheapest.",
    ),
    OnboardingPageModel(
      titleLineOne: 'Same product.',
      titleLineTwo: 'Best price.',
      message: 'We check Myntra, AJIO, Flipkart, Amazon and more, then put the cheapest store first.',
    ),
    OnboardingPageModel(
      titleLineOne: 'Never miss',
      titleLineTwo: 'a drop.',
      message: 'Set alerts for price drops, big discounts and deals that are about to end.',
    ),
  ];
}
