import 'package:http/http.dart' as http;
import 'package:miro_voice_memos/modules/2oauth/2oauth_cfg.dart';
import 'dart:convert' as convert;
import 'package:miro_voice_memos/modules/2oauth/token.dart';

main() async {
  var token = new Token("boards:write boards:read", "3074457347037872302",
      "3074457347037984023", "b812a48a-d65b-4232-a90b-22dc7c7932bb", "Bearer");
  var miro = new MiroProvider();
  //var boards = miro.getAllBoards(token);
  var boards = await miro.getBoard(token, "o9J_kwdigFY=");
}

class MiroProvider {
  final apiBase = oauthCfg['API_BASE'];

  getBoard(Token token, String id) async {
    var url = "$apiBase/boards/$id";
    var uri = Uri.parse(url);
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Authorization': 'Bearer ${token.accessToken}'
    };

    var response = await http.get(uri, headers: headers);
    print(response);

    if (response.statusCode == 200) {
      Map<String, dynamic> map = convert.jsonDecode(response.body);
      print("Request success with data: $map.");
      return map;
    } else {
      var jsonResponse = convert.jsonDecode(response.body);
      print("Request failed with body: $jsonResponse.");
      return null;
    }
  }

  getAllBoards(Token token, [limit = 10, offset = 0]) async {
    var url =
        "$apiBase/teams/${token.teamId}/boards?limit=$limit&offset=$offset";
    var uri = Uri.parse(url);
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Authorization': 'Bearer ${token.accessToken}'
    };

    var response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      Map<String, dynamic> map = convert.jsonDecode(response.body);
      print("Request success with data: $map.");
      return map;
    } else {
      var jsonResponse = convert.jsonDecode(response.body);
      print("Request failed with body: $jsonResponse.");
      return null;
    }
  }
}