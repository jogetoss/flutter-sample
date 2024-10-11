import 'dart:convert' as convert;
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:joget/Utilities/Functions.dart';
import 'package:http_parser/http_parser.dart';

// API for Form << START >>

Future<String> getHashValue(String hashVariable, String apiId) async {
  String? url = await getAccountUrlFromStorage();
  String? apiKey = await getApiKeyFromStorage();
  String? cookie = await getLoginCookieFromStorage();
  String encodedHashVariable = Uri.encodeComponent(hashVariable);
  http.Response response = await http.get(
    Uri.parse(
        "https://$url/jw/api/flutter/getHashValue?hashVariable=$encodedHashVariable"),
    headers: <String, String>{
      'api_id': apiId,
      'api_key': apiKey!,
      'cookie': cookie!
    },
  );
  if (response.statusCode == 200) {
    Map<String, dynamic> jsonResponse = json.decode(response.body);
    return jsonResponse['hashValue'];
  } else {
    return "";
  }
}

Future<List<dynamic>> getSelectBoxOptions(
    String formId, String fieldId, String apiId) async {
  String? url = await getAccountUrlFromStorage();
  String? apiKey = await getApiKeyFromStorage();
  http.Response response = await http.get(
    Uri.parse(
        "https://$url/jw/api/flutter/getSelectBoxOptions?formId=$formId&fieldId=$fieldId"),
    headers: <String, String>{
      'api_id': apiId,
      'api_key': apiKey!,
      'cookie': 'JSESSIONID=1.jvm2'
    },
  );
  if (response.statusCode == 200) {
    Map<String, dynamic> jsonResponse = json.decode(response.body);
    return jsonResponse['options'];
  } else {
    return [];
  }
}

Future<String> getFormId(String processDefId, String apiId) async {
  String? url = await getAccountUrlFromStorage();
  String? apiKey = await getApiKeyFromStorage();
  http.Response response = await http.get(
    Uri.parse(
        "https://$url/jw/api/flutter/getFormId?processDefId=$processDefId"),
    headers: <String, String>{
      'api_id': apiId,
      'api_key': apiKey!,
      'cookie': 'JSESSIONID=1.jvm2'
    },
  );
  if (response.statusCode == 200) {
    Map<String, dynamic> jsonResponse = json.decode(response.body);
    return jsonResponse['formId'];
  } else {
    return "";
  }
}

Future<Map<String, dynamic>> downloadFormDefinition(
    String apiId, String formId) async {
  String? url = await getAccountUrlFromStorage();
  String? apiKey = await getApiKeyFromStorage();
  http.Response response = await http.get(
    Uri.parse("https://$url/jw/api/app/form/definition/$formId"),
    headers: <String, String>{
      'api_id': apiId,
      'api_key': apiKey!,
      'cookie': 'JSESSIONID=1.jvm2'
    },
  );
  if (response.statusCode == 200) {
    Map<String, dynamic> jsonResponse = json.decode(response.body);
    if (jsonResponse.isNotEmpty) {
      return jsonResponse;
    } else {
      return {};
    }
  } else {
    return {};
  }
}

Future<bool> updateFormDataWithFiles(Map<String, dynamic> normalFields,
    Map<String, List<File>> fileFields, String apiId, String formId) async {
  String? url = await getAccountUrlFromStorage();
  String? apiKey = await getApiKeyFromStorage();
  final Map<String, String> headers = {
    'accept': 'application/json',
    'api_id': apiId,
    'api_key': apiKey!,
    'Content-Type': 'multipart/form-data',
    'cookie': 'JSESSIONID=1.jvm2'
  };
  var request = http.MultipartRequest(
      'POST', Uri.parse('https://$url/jw/api/form/$formId/updateWithFiles'));
  request.headers.addAll(headers);
  normalFields.forEach((key, value) {
    request.fields[key] = value.toString();
  });
  for (var entry in fileFields.entries) {
    var key = entry.key;
    var files = entry.value;
    for (var file in files!) {
      String fileName = file.path.split('/').last;
      request.files.add(http.MultipartFile(
        key,
        file.openRead(),
        await file.length(),
        filename: fileName,
        contentType: MediaType(
          'application',
          'octet-stream',
        ),
      ));
    }
  }
  http.StreamedResponse response = await request.send();
  if (response.statusCode >= 200 && response.statusCode < 300) {
    print('Request successful with status: ${response.statusCode}');
    return true;
  } else {
    print('Request failed with status: ${response.statusCode}');
    return false;
  }
}

Future<bool> startProcess(
    Map<String, List<File>> fileFields,
    Map<String, String> allFields,
    String apiId,
    String processDefId,
    String formId) async {
  String? url = await getAccountUrlFromStorage();
  String? apiKey = await getApiKeyFromStorage();
  String? username = await getUsernameFromStorage();
  String? password = await getPasswordFromStorage();
  await runJSpringSecurityCheck(username!, password!);
  String? cookie = await getLoginCookieFromStorage();
  final Map<String, String> headers = {
    'accept': 'application/json',
    'api_id': apiId,
    'api_key': apiKey!,
    'Content-Type': 'application/json',
    'cookie': cookie!
  };
  http.Response response = await http.post(
      Uri.parse('https://$url/jw/api/process/$processDefId/startProcess'),
      headers: headers,
      body: json.encode(allFields));

  if (response.statusCode >= 200 && response.statusCode < 300) {
    print('Request successful with status: ${response.statusCode}');
    Map<String, dynamic> jsonResponse = json.decode(response.body);
    Map<String, dynamic> formData =
        await getFormData(jsonResponse['recordId'], apiId, formId);
    List<String> fileFieldsID = [];
    fileFields.forEach((key, value) {
      fileFieldsID.add(key);
    });
    Map<String, dynamic> formData_filtered = {};
    formData.forEach((key, value) {
      for (var i = 0; i < fileFieldsID.length; i++) {
        if (key != fileFieldsID[i]) {
          formData_filtered[key] = value;
        }
      }
    });
    updateFormDataWithFiles(formData_filtered, fileFields, apiId, formId);
    return true;
  } else {
    print('Request failed with status: ${response.statusCode}');
    return false;
  }
}

Future<Map<String, dynamic>> getFormData(
    String recordId, String apiId, String formId) async {
  String? url = await getAccountUrlFromStorage();
  String? apiKey = await getApiKeyFromStorage();
  final Map<String, String> headers = {
    'accept': 'application/json',
    'api_id': apiId,
    'api_key': apiKey!,
    'Content-Type': 'application/json',
    'cookie': 'JSESSIONID=1.jvm1'
  };
  http.Response response = await http.get(
    Uri.parse('https://$url/jw/api/form/$formId/$recordId'),
    headers: headers,
  );

  if (response.statusCode >= 200 && response.statusCode < 300) {
    print('Request successful with status: ${response.statusCode}');
    Map<String, dynamic> jsonResponse = json.decode(response.body);
    return jsonResponse;
  } else {
    print('Request failed with status: ${response.statusCode}');
    return {};
  }
}

// API for Form << END >>

// API for Userviews <<START>>

Future<List> listCreatedUserviews(String apiId) async {
  String? url = await getAccountUrlFromStorage();
  String? apiKey = await getApiKeyFromStorage();
  http.Response response = await http.get(
    Uri.parse("https://$url/jw/api/app/list/userview"),
    headers: <String, String>{
      'api_id': apiId,
      'api_key': apiKey!,
      'cookie': 'JSESSIONID=1.jvm2'
    },
  );
  if (response.statusCode == 200) {
    List<dynamic> jsonResponse = json.decode(response.body);
    if (jsonResponse.isNotEmpty) {
      return jsonResponse;
    } else {
      return [];
    }
  } else {
    return [];
  }
}

Future<Map<String, dynamic>> downloadUserviewDefinition(
    String apiId, String id) async {
  String? url = await getAccountUrlFromStorage();
  String? apiKey = await getApiKeyFromStorage();
  http.Response response = await http.get(
    Uri.parse("https://$url/jw/api/app/userview/definition/$id"),
    headers: <String, String>{
      'api_id': apiId,
      'api_key': apiKey!,
      'cookie': 'JSESSIONID=1.jvm2'
    },
  );
  if (response.statusCode == 200) {
    Map<String, dynamic> jsonResponse = json.decode(response.body);
    if (jsonResponse.isNotEmpty) {
      return jsonResponse;
    } else {
      return {};
    }
  } else {
    return {};
  }
}

// API for Userviews <<END>>

// API for List <<START>>

Future<Map<String, dynamic>> getListById(
    String apiId, String datalistId) async {
  String? url = await getAccountUrlFromStorage();
  String? apiKey = await getApiKeyFromStorage();
  http.Response response = await http.get(
    Uri.parse("https://$url/jw/api/list/$datalistId"),
    headers: <String, String>{
      'api_id': apiId,
      'api_key': apiKey!,
      'cookie': 'JSESSIONID=1.jvm2'
    },
  );
  if (response.statusCode == 200) {
    Map<String, dynamic> jsonResponse = json.decode(response.body);
    if (jsonResponse.isNotEmpty) {
      return jsonResponse;
    } else {
      return {};
    }
  } else {
    return {};
  }
}

Future<Map<String, dynamic>> downloadDatalistDefinition(
    String apiId, String datalistId) async {
  String? url = await getAccountUrlFromStorage();
  String? apiKey = await getApiKeyFromStorage();
  http.Response response = await http.get(
    Uri.parse("https://$url/jw/api/app/datalist/definition/$datalistId"),
    headers: <String, String>{
      'api_id': apiId,
      'api_key': apiKey!,
      'cookie': 'JSESSIONID=1.jvm2'
    },
  );
  if (response.statusCode == 200) {
    Map<String, dynamic> jsonResponse = json.decode(response.body);
    if (jsonResponse.isNotEmpty) {
      return jsonResponse;
    } else {
      return {};
    }
  } else {
    return {};
  }
}

// API for List <<END>>

// API for User <<START>>

Future<bool> updateUser(Map<String, dynamic> body) async {
  String? url = await getAccountUrlFromStorage();
  String? apiKey = await getApiKeyFromStorage();
  String? apiId = await getApiIdFromStorage();
  Map<String, String>? headers = {
    'api_id': apiId!,
    'api_key': apiKey!,
    'cookie': 'JSESSIONID=1.jvm2'
  };
  Uri fullUrl = Uri.https(url!, '/jw/api/user');
  http.Response response =
      await http.put(fullUrl, headers: headers, body: json.encode(body));
  if (response.statusCode == 200) {
    String firstName = body['firstName'] ?? '';
    String lastName = body['lastName'] ?? '';
    String fullName = "$firstName $lastName";
    setFirstNameToStorage(firstName);
    setLastNameToStorage(lastName);
    setFullNameToStorage(fullName);
    setEmailToStorage(body['email'] ?? '');
    return true;
  } else {
    return false;
  }
}

Future<bool> isUsernameAndPasswordValid(
    String username, String password) async {
  String? url = await getAccountUrlFromStorage();
  String? apiKey = await getApiKeyFromStorage();
  String? apiId = await getApiIdFromStorage();
  Map<String, dynamic>? queryParameters = {
    'j_username': username,
    'j_password': password
  };
  Map<String, String>? headers = {
    'api_id': apiId!,
    'api_key': apiKey!,
    'cookie': 'JSESSIONID=1.jvm2'
  };
  Uri fullUrl = Uri.https(url!, '/jw/api/sso', queryParameters);
  http.Response response = await http.post(fullUrl, headers: headers);
  if (response.statusCode == 200) {
    Map<String, dynamic> jsonResponse1 = convert.jsonDecode(response.body);
    if (jsonResponse1['isAdmin'] == true) {
      setIsUserAdmin(true);
    } else {
      setIsUserAdmin(false);
    }
    setPasswordToStorage(password);
    setUsernameToStorage(jsonResponse1['username'] ?? '');
    Map<String, dynamic> jsonResponse2 = await getUserByUsername();
    String firstName = jsonResponse2['firstName'] ?? '';
    String lastName = jsonResponse2['lastName'] ?? '';
    String fullName = "$firstName $lastName";
    setFirstNameToStorage(firstName);
    setLastNameToStorage(lastName);
    setFullNameToStorage(fullName);
    setEmailToStorage(jsonResponse2['email'] ?? '');
    return true;
  } else if (response.statusCode == 302) {
    return false;
  } else {
    return false;
  }
}

Future<bool> isApiIdAndApiKeyValid() async {
  String? url = await getAccountUrlFromStorage();
  String? apiKey = await getApiKeyFromStorage();
  String? apiId = await getApiIdFromStorage();
  Map<String, String>? headers = {
    'api_id': apiId!,
    'api_key': apiKey!,
    'cookie': 'JSESSIONID=1.jvm2'
  };
  Uri fullUrl = Uri.https(url!, '/jw/api/user/XXX');
  http.Response response = await http.get(fullUrl, headers: headers);
  if (response.statusCode == 200 || response.statusCode == 404) {
    return true;
  } else {
    return false;
  }
}

Future<Map<String, dynamic>> getUserByUsername() async {
  String? username = await getUsernameFromStorage();
  Map<String, dynamic> jsonResponse = {};
  String? url = await getAccountUrlFromStorage();
  String? apiKey = await getApiKeyFromStorage();
  String? apiId = await getApiIdFromStorage();
  Map<String, String>? headers = {
    'api_id': apiId!,
    'api_key': apiKey!,
    'cookie': 'JSESSIONID=1.jvm2'
  };
  Uri fullUrl = Uri.https(url!, '/jw/api/user/$username');
  http.Response response = await http.get(fullUrl, headers: headers);
  if (response.statusCode == 200) {
    jsonResponse = convert.jsonDecode(response.body);
    return jsonResponse;
  } else {
    return {};
  }
}

Future<bool> isAccountUrlValid(String url) async {
  var fullUrl = Uri.https(url, '/jw/api/');
  try {
    http.Response response =
        await http.get(fullUrl).timeout(const Duration(seconds: 5));
    if (response.statusCode == 400) {
      setAccountUrlToStorage(url);
      return true;
    } else {
      return false;
    }
  } on TimeoutException {
    return false;
  } catch (e) {
    return false;
  }
}

// API for User <<END>>

runJSpringSecurityCheck(String username, String password) async {
  String? url = await getAccountUrlFromStorage();
  Map<String, dynamic>? queryParameters = {
    'j_username': username,
    'j_password': password
  };
  Map<String, String>? headers = {
    'Content-Type': 'application/x-www-form-urlencoded',
    'Cookie': 'JSESSIONID=1.jvm2'
  };
  Uri fullUrl = Uri.https(url!, '/jw/j_spring_security_check', queryParameters);
  http.Response response = await http.post(fullUrl, headers: headers);
  String? sessionString = response.headers['set-cookie'];
  List<String> parts = sessionString!.split(RegExp(r'[=;]'));
  String? desiredString;
  for (int i = 0; i < parts.length; i++) {
    if (parts[i] == 'JSESSIONID') {
      desiredString = parts[i + 1];
      break;
    }
  }
  List<String> sessionParts = desiredString!.split('.');
  String extractedString = 'JSESSIONID=${sessionParts[0]}.${sessionParts[1]}';
  await setLoginCookieToStorage(extractedString);
}
