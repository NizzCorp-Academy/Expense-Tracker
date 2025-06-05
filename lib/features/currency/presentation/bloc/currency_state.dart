import 'package:expense_trackerl_ite/features/currency/domain/model/currency_model.dart';


abstract class CurrencyState {}

class CurrencyInitial extends CurrencyState {}

class CurrencyLoading extends CurrencyState {}

class CurrencyLoaded extends CurrencyState {
  final currency_model model;
  CurrencyLoaded(this.model);
}

class CurrencyError extends CurrencyState {
  final String message;
  CurrencyError(this.message);
}
