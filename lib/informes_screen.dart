import 'package:app_informes/Facebook/facebook_data_fetcher.dart';
import 'package:app_informes/InputDecorations.dart';
import 'package:flutter/material.dart';
import 'database/database_helper.dart';

class InformesScreen extends StatefulWidget {
  const InformesScreen({super.key});

  @override
  _InformesScreenState createState() => _InformesScreenState();
}

class _InformesScreenState extends State<InformesScreen> {
  final TextEditingController _universidadController = TextEditingController();
  final TextEditingController _tipoPublicacionController = TextEditingController();
  final TextEditingController _redSocialController = TextEditingController();
  final TextEditingController _fechaController = TextEditingController();
  final TextEditingController _alcanceController = TextEditingController();
  final TextEditingController _interaccionesController = TextEditingController();
  final TextEditingController _enlaceExtraccionController = TextEditingController();

  final DatabaseHelper _dbHelper = DatabaseHelper();
  final FacebookDataFetcher _dataFetcher = FacebookDataFetcher(); // Instancia de FacebookDataFetcher

  void saveInforme() async {
    Map<String, dynamic> informe = {
      'universidad': _universidadController.text,
      'tipo_publicacion': _tipoPublicacionController.text,
      'red_social': _redSocialController.text,
      'fecha': _fechaController.text,
      'alcance': int.parse(_alcanceController.text),
      'interacciones': int.parse(_interaccionesController.text),
    };

    await _dbHelper.insertInforme(informe);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Informe guardado con éxito'),
        backgroundColor: Colors.blueAccent,
      ),
    );
    _clearFields();
  }

  void _clearFields() {
    _universidadController.clear();
    _tipoPublicacionController.clear();
    _redSocialController.clear();
    _fechaController.clear();
    _alcanceController.clear();
    _interaccionesController.clear();
    _enlaceExtraccionController.clear();
  }

  void _extraerDatos() async {
    String enlace = _enlaceExtraccionController.text;

    try {
      // Extraemos el postId desde el enlace
      String postId = _dataFetcher.extractPostId(enlace);

      // Obtenemos los datos de la publicación desde la API de Facebook
      final data = await _dataFetcher.fetchPostData(postId);

      // Llenamos los campos con los datos obtenidos
      _universidadController.text = "Universidad Ejemplo"; // Puedes ajustar este valor
      _tipoPublicacionController.text = data['message'] ?? 'No especificado';
      _redSocialController.text = 'Facebook';
      _fechaController.text = data['created_time'] ?? '';
      _alcanceController.text = data['shares'] != null ? data['shares']['count'].toString() : '0';
      _interaccionesController.text = data['reactions']['summary']['total_count'].toString();

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al extraer datos: ${e.toString()}'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Registrar Nuevo Informe',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _enlaceExtraccionController,
                      decoration: InputDecorations.customInputDecoration('Enlace de Extracción'),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        _extraerDatos(); // Llama a la función para extraer datos
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Extraer Datos',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _universidadController,
                      decoration: InputDecorations.customInputDecoration('Universidad'),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _tipoPublicacionController,
                      decoration: InputDecorations.customInputDecoration('Tipo de Publicación'),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _redSocialController,
                      decoration: InputDecorations.customInputDecoration('Red Social'),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _fechaController,
                      decoration: InputDecorations.customInputDecoration('Fecha'),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _alcanceController,
                      decoration: InputDecorations.customInputDecoration('Alcance'),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _interaccionesController,
                      decoration: InputDecorations.customInputDecoration('Interacciones'),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: saveInforme,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Guardar Informe',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
