class Mosque{
  String _title;
  String _caption;
  String _latitude;
  String _longitude;
  String _description;
  String _friday_prayer_time;
  String _friday_prayer_registration_link;
  String _website;

  Mosque(
      this._title,
      this._caption,
      this._latitude,
      this._longitude,
      this._description,
      this._friday_prayer_time,
      this._friday_prayer_registration_link,
      this._website);

  String get title => _title;

  set title(String value) {
    _title = value;
  }

  String get caption => _caption;

  String get website => _website;

  set website(String value) {
    _website = value;
  }

  String get friday_prayer_registration_link =>
      _friday_prayer_registration_link;

  set friday_prayer_registration_link(String value) {
    _friday_prayer_registration_link = value;
  }

  String get friday_prayer_time => _friday_prayer_time;

  set friday_prayer_time(String value) {
    _friday_prayer_time = value;
  }

  String get description => _description;

  set description(String value) {
    _description = value;
  }

  String get longitude => _longitude;

  set longitude(String value) {
    _longitude = value;
  }

  String get latitude => _latitude;

  set latitude(String value) {
    _latitude = value;
  }

  set caption(String value) {
    _caption = value;
  }
}