import 'dart:convert';

import 'package:http/http.dart' as http;

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

class CoinData {
  Future<String> GetExchangeRate(selectedCurrency, selectedCrypto) async {
    http.Response response = await http.get(Uri.parse(
        'https://rest.coinapi.io/v1/exchangerate/$selectedCrypto/$selectedCurrency?apikey=C42BD8B7-9795-4609-AB43-03F3B71550E5'));
    if (response.statusCode == 200) {
      dynamic filteredResponse = await jsonDecode(response.body);
      print(filteredResponse['rate']);
      return filteredResponse['rate'].toStringAsFixed(0);
    } else {
      print('problem with the request' + response.statusCode.toString());
      return response.statusCode.toString();
    }
  }
}
