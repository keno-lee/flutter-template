import 'dart:core';

class SafeRes extends ResMsg<SafeMap> {
  final Map rawData;
  SafeRes(
    int status,
    String message,
    SafeMap data, [
    this.rawData,
  ]) : super(status, message, data);

  /// 从返回结果判断是否成功，并读取message，读取data为safeMap
  SafeRes.fromMap(Map resMap)
      : this(
          SafeMap(resMap)['status'].intValue,
          SafeMap(resMap)['message'].string,
          SafeMap(resMap['data']),
          resMap,
        );
}

class ResMsg<T> {
  final int status;
  final String message;
  final T data;

  ResMsg(this.status, this.message, this.data);

  @override
  String toString() {
    return 'ResMsg:$status $message $data';
  }
}

class SafeMap {
  SafeMap(this.value);

  final dynamic value;

  SafeMap operator [](dynamic key) {
    if (value is Map) return SafeMap(value[key]);
    if (value is List) {
      List _list = value;
      int max = _list.length - 1;
      if (key is int && key <= max) return SafeMap(value[key]);
    }
    return SafeMap(null);
  }

  dynamic get v => value;
  String get string => value is String ? value as String : null;
  num get number => value is num ? value as num : null;
  int get intValue => number?.toInt();
  double get doubleValue => number?.toDouble();
  Map get map => value is Map ? value as Map : null;
  List get list => value is List ? value as List : null;
  bool get boolean => value is bool ? value as bool : false;

  int get toInt {
    return this.intValue ?? (string == null ? null : int.tryParse(string));
  }

  double get toDouble {
    return this.doubleValue ??
        (string == null ? null : double.tryParse(string));
  }

  bool isEmpty() {
    if (this.v == null) return true;
    if (this.string == '') return true;
    if (this.number == 0) return true;
    if (this.map?.keys?.length == 0) return true;
    if (this.list?.length == 0) return true;
    if (this.boolean == false) return true;
    return false;
  }

  @override
  String toString() => '<SafeMap:$value>';
}
