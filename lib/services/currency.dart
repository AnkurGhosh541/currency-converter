import 'dart:convert';

import 'package:http/http.dart' as http;

class Currency {
  static const String _apiKey = "YOUR-API-KEY";

  static Future<List<List<String>>> getCurrencies() async {
    try {
      Uri url = Uri.parse("https://v6.exchangerate-api.com/v6/$_apiKey/codes");
      final response = await http.get(url);
      final Map<String, dynamic> currencyMap = jsonDecode(response.body);
      List<dynamic> currencyList = currencyMap["supported_codes"];

      if (currencyMap["result"] == "error") {
        throw currencyMap["error-type"];
      }

      List<List<String>> currencies = currencyList.map((e) {
        List<String> item = List.of(<String>[e[0], e[1]]);
        return item;
      }).toList();

      return currencies;
    } catch (e) {
      throw e.toString();
    }
  }

  static Future<double> convertCurrency({
    required String from,
    required String to,
    required double amount,
  }) async {
    try {
      Uri url = Uri.parse(
          "https://v6.exchangerate-api.com/v6/$_apiKey/pair/$from/$to/$amount");
      final response = await http.get(url);
      final Map<String, dynamic> responseMap = jsonDecode(response.body);

      if (responseMap["result"] == "error") {
        throw responseMap["error-type"];
      }

      final double convertedAmount = responseMap["conversion_result"];
      return convertedAmount;
    } catch (e) {
      throw e.toString();
    }
  }
}
