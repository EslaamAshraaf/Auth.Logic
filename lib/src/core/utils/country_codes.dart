class CountryCode {
  final String name;
  final String dialCode;
  final String code;
  final String flagEmoji;

  const CountryCode({
    required this.name,
    required this.dialCode,
    required this.code,
    required this.flagEmoji,
  });
}

abstract class AppCountryCodes {
  static const List<CountryCode> all = [
    CountryCode(name: "Egypt", dialCode: "+20", code: "EG", flagEmoji: "🇪🇬"),
    CountryCode(name: "Saudi Arabia", dialCode: "+966", code: "SA", flagEmoji: "🇸🇦"),
    CountryCode(name: "United Arab Emirates", dialCode: "+971", code: "AE", flagEmoji: "🇦🇪"),
    CountryCode(name: "United States", dialCode: "+1", code: "US", flagEmoji: "🇺🇸"),
    CountryCode(name: "United Kingdom", dialCode: "+44", code: "GB", flagEmoji: "🇬🇧"),
    CountryCode(name: "India", dialCode: "+91", code: "IN", flagEmoji: "🇮🇳"),
    CountryCode(name: "Germany", dialCode: "+49", code: "DE", flagEmoji: "🇩🇪"),
    CountryCode(name: "France", dialCode: "+33", code: "FR", flagEmoji: "🇫🇷"),
    CountryCode(name: "Canada", dialCode: "+1", code: "CA", flagEmoji: "🇨🇦"),
    CountryCode(name: "Australia", dialCode: "+61", code: "AU", flagEmoji: "🇦🇺"),
    CountryCode(name: "Turkey", dialCode: "+90", code: "TR", flagEmoji: "🇹🇷"),
    CountryCode(name: "Brazil", dialCode: "+55", code: "BR", flagEmoji: "🇧🇷"),
    CountryCode(name: "Japan", dialCode: "+81", code: "JP", flagEmoji: "🇯🇵"),
    CountryCode(name: "China", dialCode: "+86", code: "CN", flagEmoji: "🇨🇳"),
    CountryCode(name: "Russia", dialCode: "+7", code: "RU", flagEmoji: "🇷🇺"),
    CountryCode(name: "Italy", dialCode: "+39", code: "IT", flagEmoji: "🇮🇹"),
    CountryCode(name: "Spain", dialCode: "+34", code: "ES", flagEmoji: "🇪🇸"),
    CountryCode(name: "Netherlands", dialCode: "+31", code: "NL", flagEmoji: "🇳🇱"),
    CountryCode(name: "Sweden", dialCode: "+46", code: "SE", flagEmoji: "🇸🇪"),
    CountryCode(name: "Norway", dialCode: "+47", code: "NO", flagEmoji: "🇳🇴"),
    CountryCode(name: "Kuwait", dialCode: "+965", code: "KW", flagEmoji: "🇰🇼"),
    CountryCode(name: "Qatar", dialCode: "+974", code: "QA", flagEmoji: "🇶🇦"),
    CountryCode(name: "Bahrain", dialCode: "+973", code: "BH", flagEmoji: "🇧🇭"),
    CountryCode(name: "Oman", dialCode: "+968", code: "OM", flagEmoji: "🇴🇲"),
    CountryCode(name: "Jordan", dialCode: "+962", code: "JO", flagEmoji: "🇯🇴"),
    CountryCode(name: "Lebanon", dialCode: "+961", code: "LB", flagEmoji: "🇱🇧"),
    CountryCode(name: "Iraq", dialCode: "+964", code: "IQ", flagEmoji: "🇮🇶"),
    CountryCode(name: "Morocco", dialCode: "+212", code: "MA", flagEmoji: "🇲🇦"),
    CountryCode(name: "Tunisia", dialCode: "+216", code: "TN", flagEmoji: "🇹🇳"),
    CountryCode(name: "Algeria", dialCode: "+213", code: "DZ", flagEmoji: "🇩🇿"),
    CountryCode(name: "South Africa", dialCode: "+27", code: "ZA", flagEmoji: "🇿🇦"),
    CountryCode(name: "Nigeria", dialCode: "+234", code: "NG", flagEmoji: "🇳🇬"),
    CountryCode(name: "Kenya", dialCode: "+254", code: "KE", flagEmoji: "🇰🇪"),
    CountryCode(name: "Pakistan", dialCode: "+92", code: "PK", flagEmoji: "🇵🇰"),
    CountryCode(name: "Bangladesh", dialCode: "+880", code: "BD", flagEmoji: "🇧🇩"),
    CountryCode(name: "Indonesia", dialCode: "+62", code: "ID", flagEmoji: "🇮🇩"),
    CountryCode(name: "Malaysia", dialCode: "+60", code: "MY", flagEmoji: "🇲🇾"),
    CountryCode(name: "Philippines", dialCode: "+63", code: "PH", flagEmoji: "🇵🇭"),
    CountryCode(name: "Singapore", dialCode: "+65", code: "SG", flagEmoji: "🇸🇬"),
    CountryCode(name: "Thailand", dialCode: "+66", code: "TH", flagEmoji: "🇹🇭"),
    CountryCode(name: "Vietnam", dialCode: "+84", code: "VN", flagEmoji: "🇻🇳"),
    CountryCode(name: "South Korea", dialCode: "+82", code: "KR", flagEmoji: "🇰🇷"),
    CountryCode(name: "Mexico", dialCode: "+52", code: "MX", flagEmoji: "🇲🇽"),
    CountryCode(name: "Argentina", dialCode: "+54", code: "AR", flagEmoji: "🇦🇷"),
    CountryCode(name: "Colombia", dialCode: "+57", code: "CO", flagEmoji: "🇨🇴"),
    CountryCode(name: "Chile", dialCode: "+56", code: "CL", flagEmoji: "🇨🇱"),
    CountryCode(name: "Peru", dialCode: "+51", code: "PE", flagEmoji: "🇵🇪"),
    CountryCode(name: "New Zealand", dialCode: "+64", code: "NZ", flagEmoji: "🇳🇿"),
    CountryCode(name: "Ireland", dialCode: "+353", code: "IE", flagEmoji: "🇮🇪"),
    CountryCode(name: "Portugal", dialCode: "+351", code: "PT", flagEmoji: "🇵🇹"),
  ];
}
