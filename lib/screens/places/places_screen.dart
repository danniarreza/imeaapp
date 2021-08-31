import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:imeaapp/model/mosque.dart';
import 'package:imeaapp/model/sales.dart';
import 'package:imeaapp/model/store.dart';
import 'package:imeaapp/screens/places/mosque_detail_screen.dart';
import 'package:imeaapp/screens/places/store_detail_screen.dart';
import 'package:imeaapp/services/Animations.dart';
import 'package:imeaapp/services/rest_api.dart';

class PlacesScreen extends StatefulWidget {
  @override
  _PlacesScreenState createState() => _PlacesScreenState();
}

class _PlacesScreenState extends State<PlacesScreen> {
  List<Mosque> listMosques = [];
  List<Store> listStores = [];
  Set<Marker> _markers = {};
  BitmapDescriptor mosqueMarker, storeMarker;
  bool listMosquesReady = false;
  bool listStoresReady = false;

  @override
  void initState() {
    super.initState();
    _requestMosques();
    _requestStores();
    _setCustomMarker();
  }

  _requestMosques() async {
    String url = "/mosque/get_all";
    List<dynamic> responseJson = await getData(url);
    List<Mosque> newListMosques = [];

    Future.forEach(responseJson, (element) {
      newListMosques.add(Mosque(
        element["title"],
        element["caption"],
        element["latitude"],
        element["longitude"],
        element["description"],
        element["friday_prayer_time"],
        element["friday_prayer_registration_link"],
        element["website"],
      ));
    });

    setState(() {
      listMosques = [...newListMosques];
      listMosquesReady = true;
    });
  }

  _requestStores() async {
    String url = "/store/get_all";
    List<dynamic> responseJson = await getData(url);
    List<Store> newListStores = [];

    Future.forEach(responseJson, (element) {
      List<Sales> newListSales = [];

      Future.forEach(element["sales"], (row) {
        Sales sales =
            Sales(row["product"], row["unit"], row["price"], row["duration"]);
        newListSales.add(sales);
      });

      Store store = Store(
        element["title"],
        element["caption"],
        element["latitude"],
        element["longitude"],
        element["description"],
        element["website"],
        [...newListSales]
      );

      newListStores.add(store);
      print(store.toString());
    });

    setState(() {
      listStores = [...newListStores];
      listStoresReady = true;
    });
  }

  _setCustomMarker() async {
    // mosqueMarker = await BitmapDescriptor.fromAssetImage(
    //     ImageConfiguration(), 'assets/mosque_marker.png');
    // storeMarker = await BitmapDescriptor.fromAssetImage(
    //     ImageConfiguration(), 'assets/cart_marker.png');

    final Uint8List mosqueMarkerIcon =
        await getBytesFromAsset('assets/mosque_marker.png', 100);

    mosqueMarker = BitmapDescriptor.fromBytes(mosqueMarkerIcon);

    final Uint8List storeMarkerIcon =
        await getBytesFromAsset('assets/cart_marker.png', 100);

    storeMarker = BitmapDescriptor.fromBytes(storeMarkerIcon);
  }

  _onMapCreated(GoogleMapController controller) {
    Set<Marker> newMarkers = {};
    int counter = 0;

    listMosques.forEach((mosque) {
      print("this is mosque");
      print(double.parse(mosque.latitude));
      Marker marker = Marker(
          markerId: MarkerId("m" + counter.toString()),
          position: LatLng(
              double.parse(mosque.latitude), double.parse(mosque.longitude)),
          icon: mosqueMarker,
          infoWindow: InfoWindow(
              title: mosque.title,
              snippet: mosque.caption,
              onTap: () {
                _showMosqueDetailScreen(mosque);
              }));

      counter++;
      newMarkers.add(marker);
    });

    listStores.forEach((store) {
      print("this is store");
      print(double.parse(store.latitude));
      Marker marker = Marker(
          markerId: MarkerId("s" + counter.toString()),
          position: LatLng(
              double.parse(store.latitude), double.parse(store.longitude)),
          icon: storeMarker,
          infoWindow: InfoWindow(
              title: store.title,
              snippet: store.caption,
              onTap: () {
                _showStoreDetailScreen(store);
              }));

      counter++;
      newMarkers.add(marker);
    });

    setState(() {
      _markers = {...newMarkers};
    });
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

  _showMosqueDetailScreen(Mosque mosque) {
    showGeneralDialog(
      context: context,
      barrierLabel: '',
      barrierDismissible: true,
      transitionDuration: Duration(milliseconds: 300),
      transitionBuilder: (context, _animation, _secondaryAnimation, _child) {
        return Animations.grow(_animation, _secondaryAnimation, _child);
      },
      pageBuilder: (_animation, _secondaryAnimation, _child) {
        return MosqueDetailScreen(mosque);
      },
    );
  }

  _showStoreDetailScreen(Store store) {
    showGeneralDialog(
      context: context,
      barrierLabel: '',
      barrierDismissible: true,
      transitionDuration: Duration(milliseconds: 300),
      transitionBuilder: (context, _animation, _secondaryAnimation, _child) {
        return Animations.grow(_animation, _secondaryAnimation, _child);
      },
      pageBuilder: (_animation, _secondaryAnimation, _child) {
        return StoreDetailScreen(store);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: listMosquesReady && listStoresReady
          ? GoogleMap(
              onMapCreated: _onMapCreated,
              markers: _markers,
              initialCameraPosition:
                  CameraPosition(target: LatLng(52.216990, 6.873004), zoom: 15),
            )
          : SpinKitCircle(
              color: Colors.green,
            ),
    );
  }
}
