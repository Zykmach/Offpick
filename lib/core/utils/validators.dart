class Validators {
  static String? name(String value) {
    if (value.trim().length < 2) return 'Enter your name';
    return null;
  }
}
