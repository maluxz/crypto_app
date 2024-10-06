// import 'dart:convert';

class Markets {
  String? name; // Añadir un campo para el nombre del mercado
  String initialprice;
  String price;
  String high;
  String low;
  String volume;
  String bid;
  String ask;
  String basename;

  Markets({
    required this.name, // Agregar el nombre al constructor
    required this.initialprice,
    required this.price,
    required this.high,
    required this.low,
    required this.volume,
    required this.bid,
    required this.ask,
    required this.basename,
  });

  factory Markets.fromJson(String name, Map<String, dynamic> json) => Markets(
        name: name, // Asignar el nombre
        initialprice: json["initialprice"],
        price: json["price"],
        high: json["high"],
        low: json["low"],
        volume: json["volume"],
        bid: json["bid"],
        ask: json["ask"],
        basename: json["basename"],
      );

  Map<String, dynamic> toJson() => {
        // "name": name, // Incluir el nombre en la conversión a JSON si es necesario
        "initialprice": initialprice,
        "price": price,
        "high": high,
        "low": low,
        "volume": volume,
        "bid": bid,
        "ask": ask,
        "basename": basename,
      };
}
