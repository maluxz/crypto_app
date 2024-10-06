import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/markets_provider.dart'; // Importa tu provider
import 'screens/markets_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => MarketsProvider()), // Proveedor para el mercado
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MarketScreen(),
    );
  }
}
