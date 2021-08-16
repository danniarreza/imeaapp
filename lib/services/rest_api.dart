import 'package:http/http.dart';
import 'dart:convert';

Future getData(String url) async {
  String completeUrl = "https://imeaapp-sandbox.mxapps.io/api"+url;
  // String completeUrl = "https://www.google.com/"+url;

  try{
    Response response = await get(completeUrl);

    var responseJson = jsonDecode(response.body);
    return responseJson;
  } catch (error){
    print(error);

    List<dynamic> emptyResponseJson = [];
    return emptyResponseJson;
  }
}

Future postData(Map<String, dynamic> params, String url) async {
  String completeUrl = "https://imeaapp-sandbox.mxapps.io/api"+url;
  String bodyJson = json.encode(params);

  const header = {
    'Content-Type':'application/json'
  };

  try{
    Response response = await post(completeUrl, headers: header, body: bodyJson);

    var responseJson = jsonDecode(response.body);
    return responseJson;
  } catch (error){
    print(error);
    return error;
  }
}

Future putData(Map<String, dynamic> params, String url) async {
  String completeUrl = "https://imeaapp-sandbox.mxapps.io/api"+url;
  String bodyJson = json.encode(params);

  const header = {
    'Content-Type':'application/json'
  };

  try{
    Response response = await put(completeUrl, headers: header, body: bodyJson);

    var responseJson = jsonDecode(response.body);
    return responseJson;
  } catch (error){
    print(error);
    return error;
  }
}

Future deleteData(String url) async {
  String completeUrl = "https://imeaapp-sandbox.mxapps.io/api"+url;

  try{
    Response response = await delete(completeUrl);

    var responseJson = jsonDecode(response.body);
    return responseJson;
  } catch (error){
    print(error);
    return error;
  }
}