import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'database/database_helper.dart';

class InformesListScreen extends StatefulWidget {
  const InformesListScreen({super.key});

  @override
  _InformesListScreenState createState() => _InformesListScreenState();
}

class _InformesListScreenState extends State<InformesListScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> informes = [];

  @override
  void initState() {
    super.initState();
    _loadInformes();
  }

  void _loadInformes() async {
    final data = await _dbHelper.getInformes();
    setState(() {
      informes = data;
    });
  }

  Future<void> _generatePdf(Map<String, dynamic> informe) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'INFORME DE ALCANCE DE DIVULGACIÓN',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.blue,
                ),
              ),
              pw.SizedBox(height: 16),
              pw.Text('Nombre de la Universidad: ${informe['universidad']}'),
              pw.SizedBox(height: 8),
              pw.Text('Tipo de Publicación: ${informe['tipo_publicacion']}'),
              pw.Divider(color: PdfColors.blue),
              pw.Text('REDES SOCIALES'),
              pw.SizedBox(height: 8),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Fecha: ${informe['fecha']}'),
                      pw.Text('Alcance: ${informe['alcance']}'),
                      pw.Text('Impresiones: ${informe['impresiones']}'), // Nueva línea añadida
                    ],
                  ),
                  pw.Text('Interacciones: ${informe['interacciones']}'),
                ],
              ),
              pw.SizedBox(height: 8),
              pw.Text(
                'Evidencia',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 8),
              pw.Text('Captura de pantalla:'),
              // Aquí se puede agregar una imagen si se proporciona una ruta válida
              pw.SizedBox(height: 8),
              pw.Text(
                'Link: ${informe['enlace']}',
                style: pw.TextStyle(color: PdfColors.blue),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Informes'),
        backgroundColor: Colors.blueAccent,
      ),
      body: informes.isEmpty
          ? const Center(child: Text('No hay informes guardados'))
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: informes.length,
              itemBuilder: (context, index) {
                final informe = informes[index];
                return ListTile(
                  title: Text('Informe de ${informe['universidad']}'),
                  subtitle: Text('Fecha: ${informe['fecha']}'),
                  trailing: IconButton(
                    icon: Icon(Icons.picture_as_pdf),
                    onPressed: () => _generatePdf(informe),
                  ),
                );
              },
            ),
    );
  }
}
