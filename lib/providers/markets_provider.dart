import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/markets.dart'; // Importa tu modelo Markets

class MarketsProvider with ChangeNotifier {
  List<Markets> _markets = []; // Lista de mercados
  bool _isLoading = false;

  List<Markets> get markets => _markets; // Getter para la lista de mercados
  bool get isLoading => _isLoading;

  Future<void> fetchMarketData() async {
    _isLoading = true;
    notifyListeners();

    final response =
        await http.get(Uri.parse('https://tradeogre.com/api/v1/markets'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      _markets = []; // Reiniciar la lista de mercados

      // Iterar sobre cada objeto en la lista
      for (var item in data) {
        item.forEach((key, value) {
          _markets
              .add(Markets.fromJson(key, value)); // Pasar el nombre como clave
        });
      }
    } else {
      throw Exception('Fallo al cargar los mercados');
    }

    _isLoading = false;
    notifyListeners();
  }
}
