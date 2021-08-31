import 'package:imeaapp/model/sales.dart';

class Store {
  String _title;
  String _caption;
  String _latitude;
  String _longitude;
  String _description;
  String _website;
  List<Sales> _salesList;

  Store(this._title, this._caption, this._latitude, this._longitude,
      this._description, this._website, this._salesList);

  List<Sales> get salesList => _salesList;

  set salesList(List<Sales> value) {
    _salesList = value;
  }

  String get latitude => _latitude;

  set latitude(String value) {
    _latitude = value;
  }

  String get title => _title;

  set title(String value) {
    _title = value;
  }

  String get caption => _caption;

  String get website => _website;

  set website(String value) {
    _website = value;
  }

  set longitude(String value) {
    _longitude = value;
  }

  String get longitude => _longitude;

  String get description => _description;

  set description(String value) {
    _description = value;
  }

  @override
  String toString() {
    return 'Store{_title: $_title, _caption: $_caption, _latitude: $_latitude, _longitude: $_longitude, _description: $_description, _website: $_website, _salesList: $_salesList}';
  }
}
