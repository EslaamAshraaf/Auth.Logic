import 'package:phone_numbers_parser/phone_numbers_parser.dart';

class PhoneNumberHelper {
  static String normalizePhoneNumber(String rawNumber, String isoCode) {
    if (rawNumber.isEmpty) return '';

    String digitsOnly = rawNumber.replaceAll(RegExp(r'\D'), '');

    try {
      final parsed = PhoneNumber.parse(
        digitsOnly,
        callerCountry: IsoCode.values.firstWhere(
          (e) => e.name == isoCode.toUpperCase(),
        ),
      );

      return '+${parsed.countryCode}${parsed.nsn}';
    } catch (e) {
      return digitsOnly;
    }
  }

  static bool isValidPhoneNumber(String rawNumber, String isoCode) {
    if (rawNumber.isEmpty) return false;

    String digitsOnly = rawNumber.replaceAll(RegExp(r'\D'), '');

    try {
      final parsed = PhoneNumber.parse(
        digitsOnly,
        callerCountry: IsoCode.values.firstWhere(
          (e) => e.name == isoCode.toUpperCase(),
        ),
      );
      return parsed.isValid();
    } catch (e) {
      return false;
    }
  }

  static String? getValidationMessage(String rawNumber, String isoCode) {
    if (rawNumber.isEmpty) return 'Phone number is required';
    if (!isValidPhoneNumber(rawNumber, isoCode)) {
      return 'Invalid phone number for this country';
    }
    return null;
  }

  static String getNationalNumber(String fullNumber) {
    if (fullNumber.isEmpty) return '';
    try {
      final parsed = PhoneNumber.parse(fullNumber);
      return parsed.nsn;
    } catch (e) {
      return fullNumber.replaceAll('+', '');
    }
  }
}
