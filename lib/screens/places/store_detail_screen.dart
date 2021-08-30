import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:imeaapp/model/store.dart';
import 'package:url_launcher/url_launcher.dart';

class StoreDetailScreen extends StatefulWidget {
  final Store _store;

  StoreDetailScreen(this._store);

  @override
  _StoreDetailScreenState createState() => _StoreDetailScreenState();
}

class _StoreDetailScreenState extends State<StoreDetailScreen> {

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
            widget._store.description,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  _renderWebsiteContainer() {
    return widget._store.website != null && widget._store.website != ""
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
                    widget._store.website,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.blue,
                    ),
                  ),
                  onTap: () => launch(widget._store.website),
                ),
              ),
            ],
          )
        : Container(
            margin: EdgeInsets.symmetric(vertical: 10),
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
                widget._store.title,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            _renderDescriptionContainer(),
            _renderWebsiteContainer(),
          ],
        ),
      ),
    );
  }
}
