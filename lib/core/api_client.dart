import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';

class ApiClient {
  // Cambiar aquí la baseUrl según el entorno
  // Emulador Android: http://10.0.2.2:8000
  // Dispositivo físico: http://<IP_DE_TU_PC>:8000
  // Web/Desktop: http://localhost:8000
  final String baseUrl;
  final Dio _dio;

  ApiClient({String? baseUrl})
      : baseUrl = baseUrl ?? 'http://localhost:8000',
        _dio = Dio(
          BaseOptions(
            baseUrl: baseUrl ?? 'http://localhost:8000',
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 30),
            headers: {HttpHeaders.acceptHeader: 'application/json'},
          ),
        );

  // Chequeo de salud del servidor
  Future<bool> health() async {
    try {
      final r = await _dio.get('/health');
      return r.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  // Método tradicional (no streaming)
  Future<String> ask(String message, List<Map<String, String>> history) async {
    final body = {'message': message, 'history': history};
    final resp = await _dio.post('/chat', data: jsonEncode(body));

    if (resp.statusCode == 200) {
      final data = resp.data;
      if (data is Map<String, dynamic> && data.containsKey('answer')) {
        return data['answer'].toString();
      }
      return '';
    }
    throw Exception('Error ${resp.statusCode}');
  }

  // Streaming de respuesta (para mostrar tokens mientras se generan)
  Stream<String> askStream(
      String message, List<Map<String, String>> history) async* {
    final body = jsonEncode({'message': message, 'history': history});
    final options = Options(
      responseType: ResponseType.stream,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );

    final response = await _dio.post('/chat', data: body, options: options);
    final stream = response.data!.stream as Stream<List<int>>;
    final decoder = const Utf8Decoder();
    final buffer = StringBuffer();

    await for (final chunk in stream) {
      final part = decoder.convert(chunk);
      buffer.write(part);
      try {
        final jsonChunk = jsonDecode(part);
        if (jsonChunk is Map<String, dynamic> &&
            jsonChunk.containsKey('answer')) {
          yield jsonChunk['answer'].toString();
          continue;
        }
      } catch (_) {
      }

      yield part;
    }
  }
}