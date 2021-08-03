final String tablePrayerTime = 'prayertime';

class PrayerTimeFields {
  static final List<String> values = [
    // Add all fields
    id, date, subuh, terbit, dhuhur, ashar, maghrib, isha,
  ];

  static final String id = '_id';
  static final String date = 'date';
  static final String subuh = 'subuh';
  static final String terbit = 'terbit';
  static final String dhuhur = 'dhuhur';
  static final String ashar = 'ashar';
  static final String maghrib = 'maghrib';
  static final String isha = 'isha';
}

class PrayerTime {
  int _id;
  DateTime _date;
  DateTime _subuh;
  DateTime _terbit;
  DateTime _dhuhur;
  DateTime _ashar;
  DateTime _maghrib;
  DateTime _isha;

  PrayerTime(this._id, this._date, this._subuh, this._terbit, this._dhuhur,
      this._ashar, this._maghrib, this._isha);

  // PrayerTime copy(int? id){
  //   return PrayerTime(
  //     id: id ?? this._id,
  //     date: date ?? this._date,
  //     subuh: subuh ?? this._subuh,
  //     dhuhur: dhuhur ?? this._dhuhur,
  //     ashar: ashar ?? this._ashar,
  //     maghrib: maghrib ?? this._maghrib,
  //     isha: isha ?? this._isha,
  //   );
  // }

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  DateTime get date => _date;

  set date(DateTime value) {
    _date = value;
  }

  DateTime get subuh => _subuh;

  DateTime get isha => _isha;

  set isha(DateTime value) {
    _isha = value;
  }

  DateTime get maghrib => _maghrib;

  set maghrib(DateTime value) {
    _maghrib = value;
  }

  DateTime get ashar => _ashar;

  set ashar(DateTime value) {
    _ashar = value;
  }

  DateTime get dhuhur => _dhuhur;

  set dhuhur(DateTime value) {
    _dhuhur = value;
  }

  DateTime get terbit => _terbit;

  set terbit(DateTime value) {
    _terbit = value;
  }

  set subuh(DateTime value) {
    _subuh = value;
  }

  static PrayerTime fromJson(Map<String, Object> json) {
    return PrayerTime(
        json[PrayerTimeFields.id] as int,
        DateTime.parse(json[PrayerTimeFields.date] as String),
        DateTime.parse(json[PrayerTimeFields.subuh] as String),
        DateTime.parse(json[PrayerTimeFields.terbit] as String),
        DateTime.parse(json[PrayerTimeFields.dhuhur] as String),
        DateTime.parse(json[PrayerTimeFields.ashar] as String),
        DateTime.parse(json[PrayerTimeFields.maghrib] as String),
        DateTime.parse(json[PrayerTimeFields.isha] as String));
  }

  Map<String, Object> toJson() {
    return {
      PrayerTimeFields.id: _id,
      PrayerTimeFields.date: _date.toIso8601String(),
      PrayerTimeFields.subuh: _subuh.toIso8601String(),
      PrayerTimeFields.terbit: _terbit.toIso8601String(),
      PrayerTimeFields.dhuhur: _dhuhur.toIso8601String(),
      PrayerTimeFields.ashar: _ashar.toIso8601String(),
      PrayerTimeFields.maghrib: _maghrib.toIso8601String(),
      PrayerTimeFields.isha: _isha.toIso8601String(),
    };
  }
}
