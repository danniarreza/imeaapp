import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:imeaapp/model/mosque.dart';
import 'package:url_launcher/url_launcher.dart';

class MosqueDetailScreen extends StatefulWidget {
  final Mosque _mosque;

  MosqueDetailScreen(this._mosque);

  @override
  _MosqueDetailScreenState createState() => _MosqueDetailScreenState();
}

class _MosqueDetailScreenState extends State<MosqueDetailScreen> {
  _renderJumatPrayerContainer() {
    return widget._mosque.friday_prayer_time != null
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 5,
                ),
                child: Text(
                  "Shalat Jumat",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 5,
                ),
                child: Text(
                  widget._mosque.friday_prayer_time,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              )
            ],
          )
        : Container();
  }

  _renderDescriptionContainer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 10,
          ),
          child: Text(
            "Description",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 0,
          ),
          child: Text(
            widget._mosque.description,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  _renderWebsiteContainer() {
    return widget._mosque.website != null && widget._mosque.website != ""
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10,
                ),
                child: Text(
                  "Website",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(15, 0, 15, 25),
                child: InkWell(
                  child: new Text(
                    widget._mosque.website,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.blue,
                    ),
                  ),
                  onTap: () => launch(widget._mosque.website),
                ),
              ),
            ],
          )
        : Container(
            margin: EdgeInsets.symmetric(vertical: 10),
          );
  }

  _renderJumatPrayerRegistrationContainer() {
    return widget._mosque.friday_prayer_registration_link != null &&
            widget._mosque.friday_prayer_registration_link != ""
        ? Container(
            margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
            child: InkWell(
              child: new Text(
                'Registrasi',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                ),
              ),
              onTap: () =>
                  launch(widget._mosque.friday_prayer_registration_link),
            ),
          )
        : Container(
            margin: EdgeInsets.symmetric(vertical: 0),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.all(15),
              child: Text(
                // "Iveo Mosque",
                widget._mosque.title,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            _renderJumatPrayerContainer(),
            _renderDescriptionContainer(),
            _renderJumatPrayerRegistrationContainer(),
            _renderWebsiteContainer(),
          ],
        ),
      ),
    );
  }
}
