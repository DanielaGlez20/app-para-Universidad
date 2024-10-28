import 'dart:convert';
import 'package:http/http.dart' as http;

class FacebookDataFetcher {
  final String accessToken = 'EAAWLVlxB4P4BO6jsZAh1DRK3FZCMLyZAXUWaUuFAiTPKrUQ30ZC4ORuZAwGZC2dn5aNhYSdszyZCIUdeQwwyZC0KM9MLvnZAVy5kC0viWbPDp6PHsoRTJB1IhrLx8pzrWR1oeMdgeSaPmGMmIWdxHZAkZCjFCSbD3fixLA8O9j12WyOWB8dCoehaeRWD2Nb6qCK5duF9cpycRy975ZCZC3ebfuMszdUZCxfXVog8lV1z0ZD';

  // Método para extraer el postId de una URL de Facebook
  String extractPostId(String url) {
    final uri = Uri.parse(url);
    final pathSegments = uri.pathSegments;

    // Obtenemos el último segmento como el postId
    return pathSegments.isNotEmpty ? pathSegments.last : '';
  }

  // Método para obtener datos de la publicación usando el postId
  Future<Map<String, dynamic>> fetchPostData(String postId) async {
    final url = 'https://graph.facebook.com/v17.0/$postId?fields=id,created_time,message,shares,reactions.summary(true),comments.summary(true)&access_token=$accessToken';
    
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al cargar los datos: ${response.statusCode}');
    }
  }
}
