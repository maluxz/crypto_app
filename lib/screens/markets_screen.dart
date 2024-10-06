import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/markets_provider.dart'; // Importa provider

class MarketScreen extends StatelessWidget {
  const MarketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final marketProvider = Provider.of<MarketsProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mercados'),
        backgroundColor: Colors.greenAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: MarketSearchDelegate(marketProvider.markets),
              );
            },
          ),
        ],
      ),
      body: marketProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              itemCount: marketProvider.markets.length,
              itemBuilder: (context, index) {
                final market = marketProvider.markets[index];

                final coinName = market.name?.split('-').first ?? '';
                final imageUrl =
                    'assets/icons/$coinName.png'; // Ruta local de la imagen

                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      child: Image.asset(
                        imageUrl,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.error, color: Colors.red);
                        },
                      ),
                    ),
                    title: Text(
                      market.name ?? 'Nombre desconocido',
                      style: theme.textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Precio: \$${market.price}',
                            style: TextStyle(color: theme.primaryColor),
                          ),
                          Text('Alto: \$${market.high}'),
                          Text('Bajo: \$${market.low}'),
                          Text('Volumen: ${market.volume}'),
                        ],
                      ),
                    ),
                    trailing: const Icon(Icons.star),
                    onTap: () {
                      // Agregar acción al hacer clic en el ListTile
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Refrescar los datos del mercado
          marketProvider.fetchMarketData();
        },
        backgroundColor: Colors.greenAccent,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

class MarketSearchDelegate extends SearchDelegate {
  final List markets;

  MarketSearchDelegate(this.markets);

  @override
  List<Widget>? buildActions(BuildContext context) {
    // Botón para limpiar la búsqueda
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = ''; // Limpia la búsqueda
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // Botón para cerrar la búsqueda
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null); // Cierra la búsqueda
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Filtra los resultados de acuerdo al query
    final filteredMarkets = markets.where((market) {
      return market.name!.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      itemCount: filteredMarkets.length,
      itemBuilder: (context, index) {
        final market = filteredMarkets[index];
        final coinName = market.name?.split('-').first ?? '';
        final imageUrl = 'assets/icons/$coinName.png'; // Ruta local de la imagen

        return Card(
          elevation: 3,
          margin: const EdgeInsets.symmetric(vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Image.asset(
                imageUrl,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.error, color: Colors.red);
                },
              ),
            ),
            title: Text(
              market.name ?? 'Nombre desconocido',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Precio: \$${market.price}'),
                Text('Alto: \$${market.high}'),
                Text('Bajo: \$${market.low}'),
                Text('Volumen: ${market.volume}'),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Muestra sugerencias mientras se escribe en el campo de búsqueda
    final suggestedMarkets = markets.where((market) {
      return market.name!.toLowerCase().startsWith(query.toLowerCase());
    }).toList();

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      itemCount: suggestedMarkets.length,
      itemBuilder: (context, index) {
        final market = suggestedMarkets[index];
        final coinName = market.name?.split('-').first ?? '';
        final imageUrl = 'assets/icons/$coinName.png';

        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.transparent,
            child: Image.asset(
              imageUrl,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.error, color: Colors.red);
              },
            ),
          ),
          title: Text(market.name ?? 'Nombre desconocido'),
          onTap: () {
            query = market.name ?? '';
            showResults(context);
          },
        );
      },
    );
  }
}
