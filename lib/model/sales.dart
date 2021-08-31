class Sales{
  String _product;
  String _unit;
  String _price;
  String _duration;

  Sales(this._product, this._unit, this._price, this._duration);

  String get product => _product;

  set product(String value) {
    _product = value;
  }

  String get unit => _unit;

  String get duration => _duration;

  set duration(String value) {
    _duration = value;
  }

  String get price => _price;

  set price(String value) {
    _price = value;
  }

  set unit(String value) {
    _unit = value;
  }

  @override
  String toString() {
    return 'Sales{_product: $_product, _unit: $_unit, _price: $_price, _duration: $_duration}';
  }
}