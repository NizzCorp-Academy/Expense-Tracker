import 'package:expense_trackerl_ite/features/currency/domain/api_client.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'currency_event.dart';
import 'currency_state.dart';

class CurrencyBloc extends Bloc<CurrencyEvent, CurrencyState> {
  final CurrencyApiClient apiClient = CurrencyApiClient();

  CurrencyBloc() : super(CurrencyInitial()) {
    on<LoadCurrencyEvent>((event, emit) async {
      emit(CurrencyLoading());
      try {
        final model = await apiClient.fetchCurrencyRates();
        emit(CurrencyLoaded(model));
      } catch (e) {
        emit(CurrencyError('Failed to load currency data'));
      }
    });
  }
}
