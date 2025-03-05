import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PokeCatch',
      theme: ThemeData(primarySwatch: Colors.yellow),
      home: PokeCatchScreen(),
    );
  }
}

class  PokeCatchScreen extends StatefulWidget {
  const PokeCatchScreen({super.key});
  @override
  State<PokeCatchScreen> createState() => _PokeCatchScreenState();
}

class _PokeCatchScreenState extends State<PokeCatchScreen> {
  String? _pokemonImageUrl;
  String? _pokemonName;
  final Random _random = Random();

  Future<void> fetchRandomPokemon() async {
    int pokemonId = _random.nextInt(898) + 1;
    final url = Uri.parse('https://pokeapi.co/api/v2/pokemon/$pokemonId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _pokemonImageUrl = data['sprites']['front_default'];
        _pokemonName = data['name'].toString().toUpperCase();
      });
    } else {
      setState(() {
        _pokemonImageUrl = null;
        _pokemonName = null;
      });
    }

  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        backgroundColor: Colors.yellow,

        title: const Text('ポケモンずかん'),
      ),
      body: Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _pokemonImageUrl != null
              ? Column(
                children: [
                  Image.network(_pokemonImageUrl!, width: 200, height: 200),
                  const SizedBox(height: 10),
                  Text(_pokemonName ?? '', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                ],
            )
                : const Text('ボタンを押してポケモンをゲット！', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: fetchRandomPokemon,
                child: const Text('ゲットだぜ！', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
