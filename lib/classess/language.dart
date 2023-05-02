class Language {
  final int id;
  final String flag;
  final String name;
  final String languageCode;

  Language(this.id, this.flag, this.name, this.languageCode);

  static List<Language> languageList() {
    return <Language>[
      Language(1, "🇫🇷", "Français", "fr"),
      Language(2, "🇺🇸", "English", "en"),
      Language(3, "🇸🇦", "اَلْعَرَبِيَّةُ", "ar"),
      Language(4, "🇮🇳", "हिंदी", "hi"),
      Language(5, "🇪🇸", "Español", "es"),
      Language(6, "🇩🇪", "Deutsch", "de"),
      Language(7, "🇨🇳", "中国人", "zh"),
      Language(8, "🇧🇷", "Português", "pt"),
      Language(9, "🇧🇩", "বাংলা", "bn"),
    ];
  }
}