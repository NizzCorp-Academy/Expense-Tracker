import 'package:dio/dio.dart';

class DioService {
  static final DioService _instance = DioService._internal();
  late Dio dio;

  factory DioService() {
    return _instance;
  }

  DioService._internal() {
    dio = Dio(BaseOptions(
      baseUrl: 'https://v6.exchangerate-api.com/v6/09979c66e6305274236f9b78/latest/USD', 
      connectTimeout: Duration(seconds: 5),
      receiveTimeout: Duration(seconds: 5),
      headers: {
        'Content-Type': 'application/json',
      },
    ));

    
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));
  }
}