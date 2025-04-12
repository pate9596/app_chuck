import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main(){
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mi App Estilosa',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String data = 'Cargando...';

  @override
  void initState() {
    super.initState();
    fetchData();
  }
  Future<String> translateText(String text) async {
    final encoded = Uri.encodeComponent(text);
    final url = Uri.parse(
      'https://translate.googleapis.com/translate_a/single?client=gtx&sl=en&tl=es&dt=t&q=$encoded',
    );

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return body[0][0][0];
    } else {
      return 'Error al traducir';
    }
  }


  Future<void> fetchData() async {
    final url = Uri.parse('https://api.chucknorris.io/jokes/random');
    final res = await http.get(url);

    if (res.statusCode == 200) {
      final json = jsonDecode(res.body);
      final ori = json['value'];
      //traduccion
      final translatedText = await translateText(ori);
      setState(() {
        data = translatedText;
      });
    } else {
      setState(() {
        data = 'Error al cargar datos';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text ('🧔🏼‍♂️ Frases de Chuck Norris 🧔🏼') ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              constraints: const BoxConstraints(
                minHeight: 200, // Altura mínima para evitar que el Card se achique
              ),
              child: Card(
                elevation: 7,
                color: Colors.brown.shade50,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.format_quote, color: Colors.orange, size: 40),
                      const SizedBox(height: 10),
                      Center(
                        child: Text(
                          data,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 15,
                            fontFamily: 'Oswald',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: fetchData,
              child: const Text('Otra frase'),
            ),
          ],
        ),
      ),
    );
  }

}
