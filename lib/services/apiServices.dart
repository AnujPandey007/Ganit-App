import 'dart:io';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../shared/constants.dart';

class ApiService {

  Future<Map<String, dynamic>> fetchGet(BuildContext context, String url) async {
    Future<bool> hasInternetFuture = checkInternet();
    Map<String, dynamic> resp = {};
    try{
      await hasInternetFuture.then((hasConn) async {
        if (hasConn) {
          HttpClient client = HttpClient();
          client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);

          HttpClientRequest request = await client.getUrl(Uri.parse(url));

          request.headers.set('content-type', 'application/json');

          HttpClientResponse response = await request.close();

          String reply = await response.transform(utf8.decoder).join();

          int responseCode = response.statusCode;

          if(responseCode==200){
            resp = jsonDecode(reply);
          }else{
            showMessage(context, "Something went wrong!");
          }
        }else{
          showMessage(context, "No net connection!");
        }
      });
    }catch(e){
      print(e);
    }
    return resp;
  }

  dynamic fetchPost(BuildContext context, String url, Object body) async {
    Future<bool> hasInternetFuture = checkInternet();
    dynamic resp;
    try{
      await hasInternetFuture.then((hasConn) async {
        if (hasConn) {
          HttpClient client = HttpClient();
          client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);

          HttpClientRequest request = await client.postUrl(Uri.parse(url));

          String token = dotenv.get('token', fallback: "Error!");

          request.headers.set('Authorization', 'Bearer $token');
          request.headers.set('content-type', 'application/json');

          request.add(utf8.encode(json.encode(body)));

          HttpClientResponse response = await request.close();

          String reply = await response.transform(utf8.decoder).join();

          int responseCode = response.statusCode;

          if(responseCode==200){
            resp = jsonDecode(reply);
          }else{
            showMessage(context, "Something went wrong!");
          }
        } else {
          showMessage(context, "No net connection!");
        }
      });
    }catch(e){
      print(e);
    }
    return resp;
  }

  Future<Map<String, dynamic>> fetchPut(BuildContext context, String url, Object body) async {
    Future<bool> hasInternetFuture = checkInternet();
    Map<String, dynamic> resp = {};
    try{
      await hasInternetFuture.then((hasConn) async {
        if (hasConn) {
          HttpClient client = HttpClient();
          client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);

          HttpClientRequest request = await client.putUrl(Uri.parse(url));

          request.headers.set('content-type', 'application/json');

          request.add(utf8.encode(json.encode(body)));

          HttpClientResponse response = await request.close();

          String reply = await response.transform(utf8.decoder).join();

          int responseCode = response.statusCode;

          if(responseCode==200){
            resp = jsonDecode(reply);
          }else{
            showMessage(context, "Something went wrong!");
          }
        } else {
          showMessage(context, "No net connection!");
        }
      });
    }catch(e){
      print(e);
    }
    return resp;
  }

  Future<bool> checkInternet() async {
    bool hasInternetConn = true;
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (ConnectivityResult.mobile != connectivityResult && ConnectivityResult.wifi != connectivityResult) {
      hasInternetConn = false;
    }
    return hasInternetConn;
  }

}

