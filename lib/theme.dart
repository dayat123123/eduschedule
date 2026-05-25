import 'package:flutter/material.dart';

class AppColors {
  // Primary colors
  static const Color primary = Color(0xFF6366F1);
  static const Color primaryLight = Color(0xFF818CF8);
  static const Color primaryDark = Color(0xFF4C1D95);

  // Background colors
  static const Color scaffoldBackground = Color(0xFFF8F9FF);
  static const Color heroBackground = Color(0xFF0F0728);
  static const Color heroBackgroundSecondary = Color(0xFF1A0B3D);
  static const Color heroBackgroundDark = Color(0xFF0A041F);
  static const Color heroCardBackground = Color(0xFF241B4D);
  static const Color heroStepCardBackground = Color(0xFF2D1B69);
  static const Color heroGradientStart = Color(0xFF1E0B5E);
  static const Color heroGradientMiddle = Color(0xFF2D1B8E);
  static const Color heroGradientEnd = Color(0xFF4C1D95);

  // Accent colors
  static const Color accentPurple = Color(0xFF8B5CF6);
  static const Color accentPurpleLight = Color(0xFFA78BFA);
  static const Color accentPurpleDark = Color(0xFF7E22CE);
  static const Color accentPurpleVeryLight = Color(0xFFC4B5FD);
  static const Color accentPurpleUltraLight = Color(0xFFFDF4FF);

  // Text colors
  static const Color textPrimary = Color(0xFF0F0728);
  static const Color textSecondary = Color(0xFFC4B5FD);
  static const Color textMuted = Color(0xFF9CA3AF);
  static const Color textLight = Color(0xFFE0E7FF);

  // Neutral colors
  static const Color neutral900 = Color(0xFF111827);
  static const Color neutral500 = Color(0xFF6B7280);
  static const Color neutral300 = Color(0xFFD1D5DB);
  static const Color neutral200 = Color(0xFFE5E7EB);
  static const Color neutral100 = Color(0xFFF3F4F6);
  static const Color neutral50 = Color(0xFFF9FAFB);

  // Toast colors
  static const Color toastSuccessBackground = Color(0xFFF0FDF4);
  static const Color toastSuccessBorder = Color(0xFF86EFAC);
  static const Color toastSuccessText = Color(0xFF166534);

  static const Color toastErrorBackground = Color(0xFFFFF1F2);
  static const Color toastErrorBorder = Color(0xFFFDA4AF);
  static const Color toastErrorText = Color(0xFFBE123C);

  static const Color heroBackgroundPrimary = Color(0xFF070214);
  static const Color accentIndigo = Color(0xFF6366F1);
}

class SubjectColorTheme extends ThemeExtension<SubjectColorTheme> {
  final Map<String, Map<String, Color>> subjectColors;

  const SubjectColorTheme({required this.subjectColors});

  static const Map<String, Map<String, Color>> defaultSubjectColors = {
    'matematika': {
      'bg': Color(0xFFEEF2FF),
      'text': Color(0xFF4338CA),
      'border': Color(0xFFA5B4FC),
    },
    'bahasa_indonesia': {
      'bg': Color(0xFFF0FDF4),
      'text': Color(0xFF166534),
      'border': Color(0xFF86EFAC),
    },
    'bahasa_inggris': {
      'bg': Color(0xFFFFF7ED),
      'text': Color(0xFFC2410C),
      'border': Color(0xFFFCA5A5),
    },
    'ipa': {
      'bg': Color(0xFFFDF4FF),
      'text': Color(0xFF7E22CE),
      'border': Color(0xFFD8B4FE),
    },
    'ips': {
      'bg': Color(0xFFF0FDFF),
      'text': Color(0xFF0C4A6E),
      'border': Color(0xFF7DD3FC),
    },
    'seni_budaya': {
      'bg': Color(0xFFF3F4F6),
      'text': Color(0xFF374151),
      'border': Color(0xFFD1D5DB),
    },
    'penjas': {
      'bg': Color(0xFFFEF3C7),
      'text': Color(0xFF92400E),
      'border': Color(0xFFFCD34D),
    },
    'agama': {
      'bg': Color(0xFFFCE7F3),
      'text': Color(0xFFBE185D),
      'border': Color(0xFFF9A8D4),
    },
  };

  @override
  ThemeExtension<SubjectColorTheme> copyWith({
    Map<String, Map<String, Color>>? subjectColors,
  }) {
    return SubjectColorTheme(
      subjectColors: subjectColors ?? this.subjectColors,
    );
  }

  @override
  ThemeExtension<SubjectColorTheme> lerp(
    ThemeExtension<SubjectColorTheme>? other,
    double t,
  ) {
    if (other is! SubjectColorTheme) {
      return this;
    }
    return SubjectColorTheme(
      subjectColors: subjectColors, // For simplicity, not lerping the map
    );
  }

  static SubjectColorTheme of(BuildContext context) {
    return Theme.of(context).extension<SubjectColorTheme>() ??
        const SubjectColorTheme(subjectColors: defaultSubjectColors);
  }
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      fontFamily: 'Inter',
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.scaffoldBackground,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.accentPurple,
      ),
      extensions: const [
        SubjectColorTheme(
          subjectColors: SubjectColorTheme.defaultSubjectColors,
        ),
      ],
      // Add more theme properties as needed
      textTheme: const TextTheme(
        // Define text styles if needed
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      // Add more component themes as needed
    );
  }
}
