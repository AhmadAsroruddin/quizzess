import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/https_exception.dart';

class AuthProvider with ChangeNotifier{
  String? _token;
  String? _userId;
  DateTime? _expiryTime;
  Timer? _authTimer;
  String? _email;

  bool get isAuth{
    return token != null;
  }

  String? get token{
    if(_token != null && _expiryTime!.isAfter(DateTime.now()) && _expiryTime != null){
      return _token!;
    }
    return null;
  }

  String? get email{
    return _email;
  }

  Future<void> _authentication(String email, String password, String key) async{
    final url = Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:$key?key=AIzaSyDZbFGXE3TU26RtiuqWOmVofyXqCwEpeFo');

    try{
      final response = await http.post(url, body: json.encode(
        {
          'email': email,
          'password': password,
          'returnSecureToken' : true 
        }
      ));
      final responseData = json.decode(response.body);
      if(responseData['error'] != null ){
        throw HttpException(responseData['error']['message']);
      }

      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryTime = DateTime.now().add(
        Duration(
          seconds: int.parse(responseData['expiresIn'])
        )
      );
      _email = email;
      notifyListeners();
      //ini menambahkan variabel sharedPreferences untuk fitur autoLogin
      final userData = json.encode(
        { 
          'token' : _token,
          'userId' : _userId,
          'expiryTime' : _expiryTime!.toIso8601String()
        }
      );
      final pref = await SharedPreferences.getInstance();
      pref.setString('userData', userData);
      autoLogout();
    } catch(error){
      rethrow;
    }
  }

  Future<void> signUp(String email, String password) async{
    return _authentication(email, password, "signUp");
  }

  Future<void> login(String email, String password,) async{
    return _authentication(email, password, "signInWithPassword");
  }

  Future<bool> autoLogin() async{
    final pref = await SharedPreferences.getInstance();
    if (!pref.containsKey('userData')) {
      return false;
    }
    final extractedData = pref.getString('userData');
    final userData = json.decode(extractedData!) as Map<String, dynamic>;
    final expiryDate = DateTime.parse(userData['expiryTime'] as String);

    if(expiryDate.isBefore(DateTime.now())){
      return false;
    }
    _token = userData['token'];
    _userId = userData['userId'];
    _expiryTime = expiryDate;

    notifyListeners();
    autoLogout();
    return true;
  } 

  Future<void> logout() async{
    _userId = null;
    _expiryTime = null;
    _token = null;

    //jika masa token masih ada, maka hapus timer token
    if(_authTimer != null){
      _authTimer!.cancel();
      _authTimer = null;
    }
    notifyListeners();

   final pref = await SharedPreferences.getInstance();
    pref.clear();
  }

  Future<void> autoLogout() async{
    if(_authTimer != null){
      _authTimer!.cancel();
    }
    final timeToExpiry = _expiryTime?.difference(DateTime.now()).inSeconds;
    Timer(Duration(seconds: timeToExpiry!+500000), logout);
  }
}