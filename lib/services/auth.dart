import 'package:http/http.dart' as http;

class Auth{
  final String baseurl = 'http://127.0.0.1:8000/api';
  var token;

  _getToken() async{
    token ="19|nBsduzbuER3V2T1ApBns6kwYRfjTtlpdMgBL6dx655930114";
  }

  logout() async{
    var route = baseurl + '/logout';
    await _getToken();
    return await http.get(
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