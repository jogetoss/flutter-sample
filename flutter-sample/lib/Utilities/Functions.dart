import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/change_notifier.dart';

class ElementController {
  void Function() refresh = () {};
  void setRefresh(void Function() refreshFunction) {
    refresh = refreshFunction;
  }
}

class CustomColorSelectionHandle extends TextSelectionControls {
  CustomColorSelectionHandle(this.handleColor)
      : _controls = materialTextSelectionControls;
  final Color handleColor;
  final TextSelectionControls _controls;
  Widget _wrapWithThemeData(Widget Function(BuildContext) builder) =>
      TextSelectionTheme(
          data: TextSelectionThemeData(selectionHandleColor: handleColor),
          child: Builder(builder: builder));
  @override
  Widget buildHandle(BuildContext context, TextSelectionHandleType type,
          double textLineHeight, [VoidCallback? onTap]) =>
      _wrapWithThemeData((BuildContext context) =>
          _controls.buildHandle(context, type, textLineHeight, onTap));
  @override
  Offset getHandleAnchor(TextSelectionHandleType type, double textLineHeight) {
    return _controls.getHandleAnchor(type, textLineHeight);
  }

  @override
  Size getHandleSize(double textLineHeight) {
    return _controls.getHandleSize(textLineHeight);
  }

  @override
  Widget buildToolbar(
      BuildContext context,
      Rect globalEditableRegion,
      double textLineHeight,
      Offset selectionMidpoint,
      List<TextSelectionPoint> endpoints,
      TextSelectionDelegate delegate,
      ValueListenable<ClipboardStatus>? clipboardStatus,
      Offset? lastSecondaryTapDownPosition) {
    // ignore: deprecated_member_use
    return _controls.buildToolbar(
        context,
        globalEditableRegion,
        textLineHeight,
        selectionMidpoint,
        endpoints,
        delegate,
        clipboardStatus,
        lastSecondaryTapDownPosition);
  }
}

String extractInnerTextFromHtml(String a) {
  String innerText = Bidi.stripHtmlIfNeeded(a);
  innerText = innerText.trim();
  return innerText;
}

Future<void> clearStorage() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('username');
  await prefs.remove('email');
  await prefs.remove('loginCookie');
}

setIsUserAdmin(bool isUserAdmin) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool(
    'isUserAdmin',
    isUserAdmin,
  );
}

getIsUserAdmin() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.getBool('isUserAdmin') != null) {
    return prefs.getBool('isUserAdmin');
  } else {
    return false;
  }
}

Future<bool> getIsUserLoggedIn() async {
  String? username = await getUsernameFromStorage();
  if (username == null) {
    return false;
  } else {
    return true;
  }
}

Future<String?> getAccountUrlFromStorage() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.getString('accountUrl') == null) {
    return "";
  } else {
    return prefs.getString('accountUrl');
  }
}

setAccountUrlToStorage(String accountUrl) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(
    'accountUrl',
    accountUrl,
  );
}

Future<String?> getUsernameFromStorage() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('username');
}

setUsernameToStorage(String username) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(
    'username',
    username,
  );
}

Future<String?> getPasswordFromStorage() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('password');
}

setPasswordToStorage(String password) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(
    'password',
    password,
  );
}

Future<String?> getEmailFromStorage() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('email');
}

setEmailToStorage(String email) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(
    'email',
    email,
  );
}

Future<String?> getFullNameFromStorage() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('fullName');
}

setFullNameToStorage(String name) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(
    'fullName',
    name,
  );
}

Future<String?> getFirstNameFromStorage() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('firstName');
}

setFirstNameToStorage(String name) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(
    'firstName',
    name,
  );
}

Future<String?> getLastNameFromStorage() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('lastName');
}

setLastNameToStorage(String name) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(
    'lastName',
    name,
  );
}

setApiIdAndApiKeyToStorage(String apiId, String apiKey) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(
    'apiId',
    apiId,
  );
  prefs.setString(
    'apiKey',
    apiKey,
  );
}

Future<String?> getApiIdFromStorage() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.getString('apiId') == null) {
    return "";
  } else {
    return prefs.getString('apiId');
  }
}

Future<String?> getApiKeyFromStorage() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.getString('apiKey') == null) {
    return "";
  } else {
    return prefs.getString('apiKey');
  }
}

Future<String?> getLoginCookieFromStorage() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('loginCookie');
}

setLoginCookieToStorage(String loginCookie) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(
    'loginCookie',
    loginCookie,
  );
}
