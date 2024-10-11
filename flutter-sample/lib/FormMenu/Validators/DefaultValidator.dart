class DefaultValidator {
  Map<String, dynamic> jsonDefinition;
  DefaultValidator(this.jsonDefinition);
  Map<String, dynamic> validate(String value) {
    String message = "";
    bool isValidationError = false;
    Map<String, dynamic> validationInfo = {};
    if (jsonDefinition['className'] != "") {
      if (value == "" && jsonDefinition['properties']['mandatory'] == "true") {
        isValidationError = true;
        message = "Missing required value";
      }
      validationInfo['isValidationError'] = isValidationError;
      validationInfo['message'] = message;
      return validationInfo;
    } else {
      validationInfo['isValidationError'] = isValidationError;
      validationInfo['message'] = message;
      return validationInfo;
    }
  }
}
