// @dart = 2.9
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_map_polyline/google_map_polyline.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smartship_partner/base/base_state.dart';
import 'package:smartship_partner/config/color/color.dart';
import 'package:smartship_partner/constant/constants.dart';
import 'package:smartship_partner/data/model/order_info.dart';
import 'package:smartship_partner/util/utils.dart';
import 'package:smartship_partner/widget/app_bar_icon.dart';

class OrderMonitorPage extends StatefulWidget {
  var order;

  OrderMonitorPage({this.order});

  @override
  _OrderMonitorPageState createState() => _OrderMonitorPageState();
}

class _OrderMonitorPageState extends BaseState<OrderMonitorPage> {
  LatLng _currentPosition;
  StreamSubscription<Position> positionStream;
  var geolocator = Geolocator();
  final Completer<GoogleMapController> _controller = Completer();
  final locationOptions =
      LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);

  final Map<MarkerId, Marker> _markers =
      <MarkerId, Marker>{}; // CLASS MEMBER, MAP OF MARKS
// List of coordinates to join
  List<LatLng> polylineCoordinates = [];
  Set<Polyline> polyline = {};
  final _googleMapPolyline = GoogleMapPolyline(apiKey: Utils.googleMapKey);

  BitmapDescriptor _shipperMarker;
  BitmapDescriptor _supplierMarker;
  BitmapDescriptor _receiverMarker;

  void _loadMarkerIcon() async {
    var imageConfig = ImageConfiguration(
        devicePixelRatio: MediaQuery.of(context).devicePixelRatio);
    _shipperMarker = await BitmapDescriptor.fromAssetImage(
        imageConfig, 'assets/images/phone/bike_small.png',
        mipmaps: false);
    _supplierMarker = await BitmapDescriptor.fromAssetImage(
        imageConfig, 'assets/images/phone/ic_marker_from.png',
        mipmaps: false);
    _receiverMarker = await BitmapDescriptor.fromAssetImage(
        imageConfig, 'assets/images/phone/ic_marker_to.png',
        mipmaps: false);
  }

  void _add() async {
    var order = widget.order as OrderInfoModel;

    var supplierLocation = order.supplier.location;
    var receiverLocation = order.receiver.location;
    var shipperLocation = order.shipper.location;

    var minLat = Utils.minValue(
        [supplierLocation.lat, receiverLocation.lat]);
    var minLng = Utils.minValue(
        [supplierLocation.lng, receiverLocation.lng]);
    var maxLat = Utils.maxValue(
        [supplierLocation.lat, receiverLocation.lat]);
    var maxLng = Utils.maxValue(
        [supplierLocation.lng, receiverLocation.lng]);

    await _loadMarkerIcon();

    var supId = 'startPoint';
    // ignore: omit_local_variable_types
    final MarkerId supMarkerId = MarkerId(supId);
    // creating a new MARKER
    // ignore: omit_local_variable_types
    final Marker supplierMarker = Marker(
        markerId: supMarkerId,
        position: LatLng(supplierLocation.lat, supplierLocation.lng),
        infoWindow: InfoWindow(title: supId, snippet: supplierLocation.address),
        icon: _supplierMarker);

    var recId = 'destination';
    // ignore: omit_local_variable_types
    final MarkerId recMarkerId = MarkerId(recId);
    // creating a new MARKER
    // ignore: omit_local_variable_types
    final Marker receiverMarker = Marker(
        markerId: recMarkerId,
        position: LatLng(receiverLocation.lat, receiverLocation.lng),
        infoWindow: InfoWindow(title: recId, snippet: receiverLocation.address),
        icon: _receiverMarker);

    var shipId = 'shipper';
    // ignore: omit_local_variable_types
    final MarkerId shipMarkerId = MarkerId(shipId);
    // creating a new MARKER
    // ignore: omit_local_variable_types
    Marker shipperMarker;

    var con = await _controller.future;
    var coordTakeOrder;

    if (shipperLocation.lat != null && shipperLocation.lng != null) {
      shipperMarker = Marker(
          markerId: shipMarkerId,
          position: LatLng(shipperLocation.lat, shipperLocation.lng),
          infoWindow: InfoWindow(title: shipId, snippet: shipperLocation.address),
          icon: _shipperMarker);

      coordTakeOrder = await _googleMapPolyline.getCoordinatesWithLocation(
          origin: LatLng(shipperLocation.lat, shipperLocation.lng),
          destination: LatLng(supplierLocation.lat, supplierLocation.lng),
          mode: RouteMode.driving);
    }

    var coordDeliverOrder = await _googleMapPolyline.getCoordinatesWithLocation(
        origin: LatLng(supplierLocation.lat, supplierLocation.lng),
        destination: LatLng(receiverLocation.lat, receiverLocation.lng),
        mode: RouteMode.driving);

    setState(() {
      // adding a new marker to map
      if (coordTakeOrder != null) {
        _markers[shipMarkerId] = shipperMarker;
      }

      _markers[supMarkerId] = supplierMarker;
      _markers[recMarkerId] = receiverMarker;

      if (coordTakeOrder != null) {
        polyline.add(
          Polyline(
              polylineId: PolylineId('takeOrder'),
              visible: true,
              points: coordTakeOrder,
              width: 4,
              color: Colors.red,
              startCap: Cap.roundCap,
              endCap: Cap.roundCap),
        );
      }

      polyline.add(
        Polyline(
            polylineId: PolylineId('deliverOrder'),
            visible: true,
            points: coordDeliverOrder,
            width: 4,
            color: Colors.grey,
            startCap: Cap.roundCap,
            endCap: Cap.roundCap),
      );
    });

    print('hoan.dv: $maxLat , $maxLng , $minLat , $minLng');

    await con.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          northeast: LatLng(maxLat, maxLng),
          southwest: LatLng(minLat, minLng),
        ),
        30.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: AppBarIcon(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Theo dõi đơn hàng',
          style: TextStyle(color: AppColors.colorAccent),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: <Widget>[
            GoogleMap(
              zoomControlsEnabled: true,
              scrollGesturesEnabled: true,
              initialCameraPosition: CameraPosition(
                target: _currentPosition ?? Constants.DEFAULT_POSITION,
                zoom: 17,
              ),
              onCameraMove: (CameraPosition position) async {
                print('onCameraMove');
//                  _currentPosition = position.target;
              },
              onCameraIdle: () {
                print('onCameraIdle');
//                  _requestLoadPlace();
              },
              onMapCreated: _onMapCreated,
              markers: _markers.values.toSet(),
              polylines: polyline,
            ),
          ],
        ),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
    _add();
  }
}
