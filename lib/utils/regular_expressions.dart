const String usernameExpression =r'[a-zA-Z]';
const String emailExpressions =
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
const String emailEditingExpression = "^[a-zA-Z0-9]*(@([a-zA-Z0-9-]*(\\.[a-zA-Z0-9-]*)?)?)?";
extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(emailExpressions)
        .hasMatch(this);
  }
}
