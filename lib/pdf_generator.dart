import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

class PdfGenerator {
  static Future<void> generatePDF(List<Map<String, dynamic>> informes) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Table(
            border: pw.TableBorder.all(),
            children: [
              pw.TableRow(children: [
                pw.Text('Universidad', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text('Tipo Publicación', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text('Red Social', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text('Fecha', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text('Alcance', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text('Interacciones', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text('Enlace', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              ]),
              ...informes.map((informe) {
                return pw.TableRow(children: [
                  pw.Text(informe['universidad']),
                  pw.Text(informe['tipo_publicacion']),
                  pw.Text(informe['red_social']),
                  pw.Text(informe['fecha']),
                  pw.Text(informe['alcance'].toString()),
                  pw.Text(informe['interacciones'].toString()),
                  pw.Text(informe['enlace']),
                ]);
              }).toList(),
            ],
          );
        },
      ),
    );

    // Guardar el PDF
    final output = await getTemporaryDirectory();
    final file = File("${output.path}/informes.pdf");
    await file.writeAsBytes(await pdf.save());
    // Aquí puedes implementar la lógica para abrir el PDF o compartirlo.
  }
}
