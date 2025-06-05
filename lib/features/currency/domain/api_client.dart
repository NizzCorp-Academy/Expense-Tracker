import 'package:dio/dio.dart';
import 'package:expense_trackerl_ite/features/currency/domain/api_service.dart';
import 'package:expense_trackerl_ite/features/currency/domain/model/currency_model.dart';

class CurrencyApiClient {
  final Dio dio = DioService().dio;

  Future<currency_model> fetchCurrencyRates() async {
    final response = await dio.get('');
    return currency_model.fromJson(response.data);
  }
}
