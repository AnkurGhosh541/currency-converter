import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';
import '../services/currency.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  IconData _currentIcon = Icons.nightlight;
  Color _iconColor = Colors.black87;
  Color _clearColor = Colors.blueGrey[700]!;

  final fromController = TextEditingController();
  final toController = TextEditingController();

  late Future<List<List<String>>> currencies;
  String from = "USD";
  String to = "INR";

  @override
  void initState() {
    currencies = Currency.getCurrencies();
    super.initState();
  }

  void changeTheme() {
    setState(() {
      Provider.of<ThemeProvider>(context, listen: false).changeTheme();
      if (_currentIcon == Icons.nightlight) {
        _currentIcon = Icons.sunny;
        _iconColor = Colors.white70;
        _clearColor = Colors.white60;
      } else {
        _currentIcon = Icons.nightlight;
        _iconColor = Colors.black87;
        _clearColor = Colors.blueGrey[700]!;
      }
    });
  }

  void replace() {
    setState(() {
      String temp = from;
      from = to;
      to = temp;
    });
  }

  void clear() {
    setState(() {
      fromController.text = "";
      toController.text = "";
    });
  }

  void convertCurrency() {
    double? amount = double.tryParse(fromController.text);
    if (amount == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please enter some amount",
            style: TextStyle(fontSize: 16),
          ),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    if (amount == 0) {
      toController.text = "0";
    } else if (amount > 0) {
      Currency.convertCurrency(from: from, to: to, amount: amount)
          .then((value) {
        setState(() {
          toController.text = value.toStringAsFixed(2);
        });
      });
    }
  }

  @override
  void dispose() {
    fromController.dispose();
    toController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const decoration = InputDecoration(
      contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 10.0),
      border: OutlineInputBorder(
        borderSide: BorderSide(
          width: 1.0,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.teal,
          width: 2.0,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Currency Converter",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: changeTheme,
            icon: Icon(
              _currentIcon,
              size: 28,
              color: _iconColor,
            ),
          ),
          const SizedBox(width: 10.0),
        ],
      ),
      body: FutureBuilder(
        future: currencies,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(
                valueColor: AlwaysStoppedAnimation(Colors.white38),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            );
          } else {
            final currencies = snapshot.data!;
            final items = currencies
                .map(
                  (item) => DropdownMenuEntry(
                    value: item[0],
                    label: item[0],
                    labelWidget: ListTile(
                      title: Text(item[0]),
                      subtitle: Text(
                        item[0] == "BAM"
                            ? "${item[1].substring(0, 23)}\n${item[1].substring(24)}"
                            : item[1],
                        softWrap: false,
                        overflow: TextOverflow.visible,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                )
                .toList();
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15.0,
                vertical: 40.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  DropdownMenu(
                    dropdownMenuEntries: items,
                    initialSelection: from,
                    width: 120.0,
                    label: const Text(
                      "From",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    menuStyle: const MenuStyle(
                      fixedSize: MaterialStatePropertyAll(Size(260, 500)),
                      surfaceTintColor: MaterialStatePropertyAll(Colors.white),
                      alignment: Alignment.bottomRight,
                      padding: MaterialStatePropertyAll(EdgeInsets.all(8.0)),
                    ),
                    onSelected: (value) {
                      if (value != null) {
                        setState(() {
                          from = value;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: fromController,
                    keyboardType: TextInputType.number,
                    decoration: decoration,
                    textAlign: TextAlign.end,
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 20.0),
                  Center(
                    child: IconButton.outlined(
                      onPressed: replace,
                      icon: const Icon(Icons.swap_vert),
                      iconSize: 28.0,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  DropdownMenu(
                    dropdownMenuEntries: items,
                    initialSelection: to,
                    width: 120.0,
                    label: const Text(
                      "To",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    menuStyle: const MenuStyle(
                      fixedSize: MaterialStatePropertyAll(Size(260, 400)),
                      surfaceTintColor: MaterialStatePropertyAll(Colors.white),
                      alignment: Alignment.bottomRight,
                      padding: MaterialStatePropertyAll(EdgeInsets.all(8.0)),
                    ),
                    onSelected: (value) {
                      if (value != null) {
                        setState(() {
                          to = value;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: toController,
                    readOnly: true,
                    canRequestFocus: false,
                    decoration: decoration,
                    textAlign: TextAlign.end,
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 10.0),
                  InkWell(
                    onTap: clear,
                    child: Text(
                      "Clear All",
                      style: TextStyle(
                        fontSize: 18,
                        color: _clearColor,
                        decoration: TextDecoration.underline,
                        decorationColor: _clearColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40.0),
                  TextButton(
                    onPressed: convertCurrency,
                    style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Colors.teal),
                        elevation: MaterialStatePropertyAll(4.0),
                        fixedSize: MaterialStatePropertyAll(
                            Size(double.maxFinite, 60.0)),
                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        ))),
                    child: const Text(
                      "Convert",
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
