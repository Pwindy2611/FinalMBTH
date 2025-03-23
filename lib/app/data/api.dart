import 'package:app_json/app/model/register.dart';
import 'package:app_json/app/model/user.dart';
import 'package:dio/dio.dart';

class API {
  final Dio _dio = Dio();
  String baseUrl = "https://huflit.id.vn:4321";

  API() {
    _dio.options.baseUrl = "$baseUrl/api";
  }

  Dio get sendRequest => _dio;
}

class APIRepository {
  API api = API();

  Map<String, dynamic> header(String token) {
    return {
      "Access-Control-Allow-Origin": "*",
      'Content-Type': 'application/json',
      'Accept': '*/*',
      'Authorization': 'Bearer $token'
    };
  }

  Future<String> register(Signup user) async {
    try {
      final body = FormData.fromMap({
        "numberID": user.numberID,
        "accountID": user.accountID,
        "fullName": user.fullName,
        "phoneNumber": user.phoneNumber,
        "imageURL": user.imageUrl,
        "birthDay": user.birthDay,
        "gender": user.gender,
        "schoolYear": user.schoolYear,
        "schoolKey": user.schoolKey,
        "password": user.password,
        "confirmPassword": user.confirmPassword
      });
      Response res = await api.sendRequest.post('/Student/signUp',
          options: Options(headers: header('no token')), data: body);
      if (res.statusCode == 200) {
        print("ok");
        return "ok";
      } else {
        print("fail");
        return "signup fail";
      }
    } catch (ex) {
      print(ex);
      rethrow;
    }
  }

  Future<String> login(String accountID, String password) async {
    try {
      final body =
          FormData.fromMap({'AccountID': accountID, 'Password': password});
      Response res = await api.sendRequest.post('/Auth/login',
          options: Options(headers: header('no token')), data: body);
      if (res.statusCode == 200) {
        final tokenData = res.data['data']['token'];
        print("ok login");
        return tokenData;
      } else {
        return "login fail";
      }
    } catch (ex) {
      print(ex);
      rethrow;
    }
  }

  Future<User> current(String token) async {
    try {
      Response res = await api.sendRequest
          .get('/Auth/current', options: Options(headers: header(token)));
      return User.fromJson(res.data);
    } catch (ex) {
      rethrow;
    }
  }
}
