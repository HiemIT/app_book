class Validation {
  static isPhoneValid(String phone) {
    final regexPhone = RegExp(r'^[0-9]{10}$');
    return regexPhone.hasMatch(phone);
  }

  static isPasswordValid(String password) {
    final regexPassword = RegExp(r'^[a-zA-Z0-9]{6,}$');
    return regexPassword.hasMatch(password);
  }
}
