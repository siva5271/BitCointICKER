import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'coin_data.dart';

Map<String, String> exchangeRates = {};
String selectedCurrency = 'USD';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  bool isWaiting = false;

  String crypto = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GetData();
  }

  DropdownButton DropDownList() {
    List<DropdownMenuItem<String>> dropDownItems = [];
    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropDownItems.add(newItem);
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropDownItems,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value.toString();
          GetData();
        });
      },
    );
  }

  CupertinoPicker GetPicker() {
    List<Widget> pickerChildren = [];
    for (String currency in currenciesList) {
      pickerChildren.add(Text(currency));
    }
    return CupertinoPicker(
      itemExtent: 20,
      children: pickerChildren,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          selectedCurrency = currenciesList[selectedIndex].toString();
          GetData();
        });
      },
    );
  }

  Future<void> GetData() async {
    for (String crypto in cryptoList) {
      String exchangeRate =
          await CoinData().GetExchangeRate(selectedCurrency, crypto);
      setState(() {
        exchangeRates[crypto] = exchangeRate;
      });
    }
  }

  Column makeCard() {
    List<CardDesign> cryptoCards = [];
    for (String crypto in cryptoList) {
      cryptoCards.add(CardDesign(
          cryptoCurrency: crypto,
          exchangeRate: exchangeRates[crypto].toString(),
          selectedCurrency: selectedCurrency));
    }
    return Column(
      children: cryptoCards,
      crossAxisAlignment: CrossAxisAlignment.stretch,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
        centerTitle: true,
        backgroundColor: Colors.blue.shade400,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          makeCard(),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? GetPicker() : DropDownList(),
          ),
        ],
      ),
    );
  }
}

class CardDesign extends StatelessWidget {
  const CardDesign({
    Key? key,
    required this.cryptoCurrency,
    required this.exchangeRate,
    required this.selectedCurrency,
  }) : super(key: key);

  final String cryptoCurrency;
  final String exchangeRate;
  final String selectedCurrency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $cryptoCurrency = $exchangeRate $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
