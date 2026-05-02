import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EnviarGithubScreen extends StatelessWidget {
  const EnviarGithubScreen({super.key});

  // LINK REAL DE TU REPOSITORIO
  final String githubUrl = 'https://github.com/ARROYOCARLOS0478/IAM-proyecto-final-flutter-rappi-carlos-6I-';

  Future<void> _launchUrl() async {
    final Uri url = Uri.parse(githubUrl);
    if (!await launchUrl(url)) {
      throw Exception('No se pudo abrir el link $githubUrl');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enviar a GitHub'),
        backgroundColor: const Color(0xFFFF441F),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.code,
                size: 100,
                color: Color(0xFFFF441F),
              ),
              const SizedBox(height: 20),
              const Text(
                'Link del Repositorio:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              SelectableText(
                githubUrl,
                style: const TextStyle(fontSize: 16, color: Colors.blue),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: _launchUrl,
                icon: const Icon(Icons.open_in_new),
                label: const Text('Abrir en el Navegador'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
