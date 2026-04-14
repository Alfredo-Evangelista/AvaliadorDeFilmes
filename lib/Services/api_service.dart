import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiServices {
  
  static Future<Map<String, dynamic>> postUser(String usuario, String senha) async {
    final response = await http.post(
      Uri.parse("https://teste.siim.com.br/auth/login"),
      headers: {
        "Content-Type": "application/json"
      },
      body: jsonEncode({
        "username": usuario,
        "password": senha
      }),
    );

    dynamic body;
    try {
      body = jsonDecode(response.body);
    } catch (e) {
      body = null;
    }

    return {
      "status": response.statusCode,
      "body": body
    };
}

  static Future<Map<String, dynamic>> postFilme(String token, String titulo, int? ano, String genero, String diretor, double? nota) async {
    final response = await http.post( 
      Uri.parse("https://teste.siim.com.br/filmes"), 
      headers: { 
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
        }, 
      body: jsonEncode({ 
        "titulo": titulo,
        "ano": ano,
        "genero": genero,
        "diretor": diretor,
        "nota": nota,
      }), 
    );

    dynamic body;
    try {
      body = jsonDecode(response.body);
    } catch (e) {
      body = null;
    }

    return {
      "status": response.statusCode,
      "body": body
    };
  }

  static Future<Map<String, dynamic>> getFilme(String token) async {
    final response = await http.get(
      Uri.parse("https://teste.siim.com.br/filmes"),
      headers: {
      "Authorization": "Bearer $token"
      },
    );

    dynamic body;
    try {
      body = jsonDecode(response.body);
    } catch (e) {
      body = null;
    }

    return {
      "status": response.statusCode,
      "body": body
    };
  }

  static Future<Map<String, dynamic>> deleteFilme(String token, int id) async {
    final response = await http.delete(
      Uri.parse("https://teste.siim.com.br/filmes/$id"),
      headers: {
        "Authorization": "Bearer $token"
      },
    );

    return {
      "status": response.statusCode
    };
  }

  static Future<Map<String, dynamic>> patchFilme(String token, int id, String titulo, int? ano, String genero, String diretor, double? nota) async{
    final response = await http.patch(
      Uri.parse("https://teste.siim.com.br/filmes/$id"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "titulo": titulo,
        "ano": ano,
        "genero": genero,
        "diretor": diretor,
        "nota": nota,
      }),
    );

    dynamic body;
    try {
      body = jsonDecode(response.body);
    } catch (e) {
      body = null;
    }

    return {
      "status": response.statusCode,
      "body": body
    };
  }
}