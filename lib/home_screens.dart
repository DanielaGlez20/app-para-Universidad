import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Gestión de Informes',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF4A90E2), // Azul Claro
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: const Color(0xFF4A90E2), // Color del texto
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15), // Padding personalizado
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20), // Esquinas redondeadas
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/guardarInforme');
              },
              child: const Text(
                'Generar Informe',
                style: TextStyle(fontSize: 18), // Tamaño de fuente
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: const Color(0xFFA3D5A8), // Color del texto
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15), // Padding personalizado
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20), // Esquinas redondeadas
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/verInformes');
              },
              child: const Text(
                'Historial de Informes',
                style: TextStyle(fontSize: 18), // Tamaño de fuente
              ),
            ),
          ],
        ),
      ),
    );
  }
}
