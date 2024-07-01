import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Api{
  final String baseurl = 'http://127.0.0.1:8000/api';
  var token;

  _getToken() async{
    // token = "19|nBsduzbuER3V2T1ApBns6kwYRfjTtlpdMgBL6dx655930114";
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
  }

  logout() async{
    var route = baseurl + '/logout';
    await _getToken();
    return await http.get(
      Uri.parse(route),
      headers: _setHeaders(),
    );
  }

  list() async{
    var route = baseurl + '/book';
    await _getToken();
    return await http.get(
      Uri.parse(route),
      headers: _setHeaders(),
    );
  }

  store(params) async{
    var route = baseurl + '/book';
    await _getToken();
    return await http.post(
      Uri.parse(route),
      body: params,
      headers: _setHeaders(),
    );
  }

  destroy(id) async{
    var route = baseurl + '/book/${id}';
    await _getToken();
    return await http.delete(
      Uri.parse(route),
      headers: _setHeaders(),
    );
  }

  _setHeaders() => {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
  };
}