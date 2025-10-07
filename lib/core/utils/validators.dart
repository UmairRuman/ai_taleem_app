// lib/core/utils/validators.dart
class Validators {
  // Email validation
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }

    return null;
  }

  // Password validation
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }

    // Optional: Add more complex validation
    // if (!RegExp(r'[A-Z]').hasMatch(value)) {
    //   return 'Password must contain at least one uppercase letter';
    // }
    // if (!RegExp(r'[a-z]').hasMatch(value)) {
    //   return 'Password must contain at least one lowercase letter';
    // }
    // if (!RegExp(r'[0-9]').hasMatch(value)) {
    //   return 'Password must contain at least one number';
    // }

    return null;
  }

  // Name validation
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }

    if (value.length < 3) {
      return 'Name must be at least 3 characters';
    }

    if (value.length > 50) {
      return 'Name must not exceed 50 characters';
    }

    // Check if name contains only letters and spaces
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      return 'Name should only contain letters';
    }

    return null;
  }

  // Phone validation (Pakistani format)
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }

    // Remove spaces and dashes for validation
    final cleanedPhone = value.replaceAll(RegExp(r'[-\s]'), '');

    // Pakistani phone format: 03XX-XXXXXXX or +92-3XX-XXXXXXX
    final phoneRegex = RegExp(r'^(\+92|0)?3[0-9]{9}$');

    if (!phoneRegex.hasMatch(cleanedPhone)) {
      return 'Please enter a valid Pakistani phone number';
    }

    return null;
  }

  // Required field validation
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  // Grade validation (6-8)
  static String? validateGrade(int? value) {
    if (value == null) {
      return 'Grade is required';
    }

    if (value < 6 || value > 8) {
      return 'Grade must be between 6 and 8';
    }

    return null;
  }

  // Username validation
  static String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username is required';
    }

    if (value.length < 3) {
      return 'Username must be at least 3 characters';
    }

    if (value.length > 20) {
      return 'Username must not exceed 20 characters';
    }

    // Username should only contain letters, numbers, and underscores
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
      return 'Username can only contain letters, numbers, and underscores';
    }

    return null;
  }

  // Age validation
  static String? validateAge(String? value) {
    if (value == null || value.isEmpty) {
      return 'Age is required';
    }

    final age = int.tryParse(value);
    if (age == null) {
      return 'Please enter a valid age';
    }

    if (age < 10 || age > 18) {
      return 'Age must be between 10 and 18';
    }

    return null;
  }

  // School/Institution name validation
  static String? validateSchoolName(String? value) {
    if (value == null || value.isEmpty) {
      return 'School name is required';
    }

    if (value.length < 3) {
      return 'School name must be at least 3 characters';
    }

    if (value.length > 100) {
      return 'School name must not exceed 100 characters';
    }

    return null;
  }

  // City validation
  static String? validateCity(String? value) {
    if (value == null || value.isEmpty) {
      return 'City is required';
    }

    if (value.length < 3) {
      return 'City name must be at least 3 characters';
    }

    return null;
  }

  // URL validation
  static String? validateUrl(String? value) {
    if (value == null || value.isEmpty) {
      return null; // URL is optional
    }

    final urlRegex = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    );

    if (!urlRegex.hasMatch(value)) {
      return 'Please enter a valid URL';
    }

    return null;
  }

  // Confirm password validation
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }

    if (value != password) {
      return 'Passwords do not match';
    }

    return null;
  }

  // OTP/Verification code validation
  static String? validateOTP(String? value) {
    if (value == null || value.isEmpty) {
      return 'Verification code is required';
    }

    if (value.length != 6) {
      return 'Verification code must be 6 digits';
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Verification code must contain only numbers';
    }

    return null;
  }

  // CNIC validation (Pakistani National ID)
  static String? validateCNIC(String? value) {
    if (value == null || value.isEmpty) {
      return 'CNIC is required';
    }

    // Remove dashes for validation
    final cleanedCNIC = value.replaceAll('-', '');

    // CNIC format: XXXXX-XXXXXXX-X (13 digits)
    if (cleanedCNIC.length != 13) {
      return 'CNIC must be 13 digits';
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(cleanedCNIC)) {
      return 'CNIC must contain only numbers';
    }

    return null;
  }

  // Prevent instantiation
  Validators._();
}
