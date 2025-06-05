class currency_model {
  String? result;
  int? timeLastUpdateUnix;
  String? timeLastUpdateUtc;
  int? timeNextUpdateUnix;
  String? timeNextUpdateUtc;
  String? baseCode;
  ConversionRates? conversionRates;

  currency_model(
      {this.result,
      this.timeLastUpdateUnix,
      this.timeLastUpdateUtc,
      this.timeNextUpdateUnix,
      this.timeNextUpdateUtc,
      this.baseCode,
      this.conversionRates});

  currency_model.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    timeLastUpdateUnix = json['time_last_update_unix'];
    timeLastUpdateUtc = json['time_last_update_utc'];
    timeNextUpdateUnix = json['time_next_update_unix'];
    timeNextUpdateUtc = json['time_next_update_utc'];
    baseCode = json['base_code'];
    conversionRates = json['conversion_rates'] != null
        ? ConversionRates.fromJson(json['conversion_rates'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['result'] = result;
    data['time_last_update_unix'] = timeLastUpdateUnix;
    data['time_last_update_utc'] = timeLastUpdateUtc;
    data['time_next_update_unix'] = timeNextUpdateUnix;
    data['time_next_update_utc'] = timeNextUpdateUtc;
    data['base_code'] = baseCode;
    if (conversionRates != null) {
      data['conversion_rates'] = conversionRates!.toJson();
    }
    return data;
  }
}

class ConversionRates {
  int? uSD;
  double? eUR;
  double? iNR;
  double? sAR;

  ConversionRates({this.uSD, this.eUR, this.iNR, this.sAR});

  ConversionRates.fromJson(Map<String, dynamic> json) {
    uSD = json['USD'];
    eUR = json['EUR'];
    iNR = json['INR'];
    sAR = json['SAR'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['USD'] = uSD;
    data['EUR'] = eUR;
    data['INR'] = iNR;
    data['SAR'] = sAR;
    return data;
  }
}