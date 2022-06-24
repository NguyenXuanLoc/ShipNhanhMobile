import 'package:google_maps_flutter/google_maps_flutter.dart';

class HereRoute {
  HereRoute({
    required this.error,
    required this.errorDescription,
    required this.response,
  });
  late final String error;
  late final String errorDescription;
  late final Response response;

  HereRoute.fromJson(Map<String, dynamic> json){
    error = json['error'];
    errorDescription = json['error_description'];
    response = Response.fromJson(json['response']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['error'] = error;
    _data['error_description'] = errorDescription;
    _data['response'] = response.toJson();
    return _data;
  }
}

class Response {
  Response({
    required this.metaInfo,
    required this.route,
    required this.language,
  });
  late final MetaInfo metaInfo;
  late final List<Route> route;
  late final String language;

  Response.fromJson(Map<String, dynamic> json){
    metaInfo = MetaInfo.fromJson(json['metaInfo']);
    route = List.from(json['route']).map((e)=>Route.fromJson(e)).toList();
    language = json['language'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['metaInfo'] = metaInfo.toJson();
    _data['route'] = route.map((e)=>e.toJson()).toList();
    _data['language'] = language;
    return _data;
  }
}

class MetaInfo {
  MetaInfo({
    required this.timestamp,
    required this.mapVersion,
    required this.moduleVersion,
    required this.interfaceVersion,
    required this.availableMapVersion,
  });
  late final String timestamp;
  late final String mapVersion;
  late final String moduleVersion;
  late final String interfaceVersion;
  late final List<String> availableMapVersion;

  MetaInfo.fromJson(Map<String, dynamic> json){
    timestamp = json['timestamp'];
    mapVersion = json['mapVersion'];
    moduleVersion = json['moduleVersion'];
    interfaceVersion = json['interfaceVersion'];
    availableMapVersion = List.castFrom<dynamic, String>(json['availableMapVersion']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['timestamp'] = timestamp;
    _data['mapVersion'] = mapVersion;
    _data['moduleVersion'] = moduleVersion;
    _data['interfaceVersion'] = interfaceVersion;
    _data['availableMapVersion'] = availableMapVersion;
    return _data;
  }
}

class Route {
  Route({
    required this.routeId,
    required this.waypoint,
    required this.mode,
    required this.leg,
    required this.summary,
  });
  late final String routeId;
  late final List<Waypoint> waypoint;
  late final Mode mode;
  late final List<Leg> leg;
  late final Summary summary;

  Route.fromJson(Map<String, dynamic> json){
    routeId = json['routeId'];
    waypoint = List.from(json['waypoint']).map((e)=>Waypoint.fromJson(e)).toList();
    mode = Mode.fromJson(json['mode']);
    leg = List.from(json['leg']).map((e)=>Leg.fromJson(e)).toList();
    summary = Summary.fromJson(json['summary']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['routeId'] = routeId;
    _data['waypoint'] = waypoint.map((e)=>e.toJson()).toList();
    _data['mode'] = mode.toJson();
    _data['leg'] = leg.map((e)=>e.toJson()).toList();
    _data['summary'] = summary.toJson();
    return _data;
  }
}

class Waypoint {
  Waypoint({
    required this.linkId,
    required this.mappedPosition,
    required this.originalPosition,
    required this.type,
    required this.spot,
    required this.sideOfStreet,
    required this.mappedRoadName,
    required this.label,
    required this.shapeIndex,
    required this.source,
  });
  late final String linkId;
  late final MappedPosition mappedPosition;
  late final OriginalPosition originalPosition;
  late final String type;
  late final double spot;
  late final String sideOfStreet;
  late final String mappedRoadName;
  late final String label;
  late final int shapeIndex;
  late final String source;

  Waypoint.fromJson(Map<String, dynamic> json){
    linkId = json['linkId'];
    mappedPosition = MappedPosition.fromJson(json['mappedPosition']);
    originalPosition = OriginalPosition.fromJson(json['originalPosition']);
    type = json['type'];
    spot = json['spot'];
    sideOfStreet = json['sideOfStreet'];
    mappedRoadName = json['mappedRoadName'];
    label = json['label'];
    shapeIndex = json['shapeIndex'];
    source = json['source'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['linkId'] = linkId;
    _data['mappedPosition'] = mappedPosition.toJson();
    _data['originalPosition'] = originalPosition.toJson();
    _data['type'] = type;
    _data['spot'] = spot;
    _data['sideOfStreet'] = sideOfStreet;
    _data['mappedRoadName'] = mappedRoadName;
    _data['label'] = label;
    _data['shapeIndex'] = shapeIndex;
    _data['source'] = source;
    return _data;
  }
}

class MappedPosition {
  MappedPosition({
    required this.latitude,
    required this.longitude,
  });
  late final double latitude;
  late final double longitude;

  MappedPosition.fromJson(Map<String, dynamic> json){
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['latitude'] = latitude;
    _data['longitude'] = longitude;
    return _data;
  }
}

class OriginalPosition {
  OriginalPosition({
    required this.latitude,
    required this.longitude,
  });
  late final double latitude;
  late final double longitude;

  OriginalPosition.fromJson(Map<String, dynamic> json){
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['latitude'] = latitude;
    _data['longitude'] = longitude;
    return _data;
  }
}

class Mode {
  Mode({
    required this.type,
    required this.transportModes,
    required this.trafficMode,
    required this.feature,
  });
  late final String type;
  late final List<String> transportModes;
  late final String trafficMode;
  late final List<dynamic> feature;

  Mode.fromJson(Map<String, dynamic> json){
    type = json['type'];
    transportModes = List.castFrom<dynamic, String>(json['transportModes']);
    trafficMode = json['trafficMode'];
    feature = List.castFrom<dynamic, dynamic>(json['feature']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['type'] = type;
    _data['transportModes'] = transportModes;
    _data['trafficMode'] = trafficMode;
    _data['feature'] = feature;
    return _data;
  }
}

class Leg {
  Leg({
    required this.start,
    required this.end,
    required this.length,
    required this.travelTime,
    required this.maneuver,
    required this.coordinatesList
  });
  late final Start start;
  late final End end;
  late final int length;
  late final int travelTime;
  late final List<Maneuver> maneuver;
  late final List<LatLng> coordinatesList;

  Leg.fromJson(Map<String, dynamic> json){
    start = Start.fromJson(json['start']);
    end = End.fromJson(json['end']);
    length = json['length'];
    travelTime = json['travelTime'];
    //maneuver = List.from(json['maneuver']).map((e)=>Maneuver.fromJson(e)).toList();
    coordinatesList = [];
    coordinatesList.add(LatLng(start.mappedPosition.latitude, start.mappedPosition.longitude));
    maneuver = List.from(json['maneuver']).map((e) {
      var m = Maneuver.fromJson(e);
      coordinatesList.add(LatLng(m.position.latitude,m.position.longitude));
      return m;
    }).toList();
    coordinatesList.add(LatLng(end.mappedPosition.latitude, end.mappedPosition.longitude));
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['start'] = start.toJson();
    _data['end'] = end.toJson();
    _data['length'] = length;
    _data['travelTime'] = travelTime;
    _data['maneuver'] = maneuver.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Start {
  Start({
    required this.linkId,
    required this.mappedPosition,
    required this.originalPosition,
    required this.type,
    required this.spot,
    required this.sideOfStreet,
    required this.mappedRoadName,
    required this.label,
    required this.shapeIndex,
    required this.source,
  });
  late final String linkId;
  late final MappedPosition mappedPosition;
  late final OriginalPosition originalPosition;
  late final String type;
  late final double spot;
  late final String sideOfStreet;
  late final String mappedRoadName;
  late final String label;
  late final int shapeIndex;
  late final String source;

  Start.fromJson(Map<String, dynamic> json){
    linkId = json['linkId'];
    mappedPosition = MappedPosition.fromJson(json['mappedPosition']);
    originalPosition = OriginalPosition.fromJson(json['originalPosition']);
    type = json['type'];
    spot = json['spot'];
    sideOfStreet = json['sideOfStreet'];
    mappedRoadName = json['mappedRoadName'];
    label = json['label'];
    shapeIndex = json['shapeIndex'];
    source = json['source'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['linkId'] = linkId;
    _data['mappedPosition'] = mappedPosition.toJson();
    _data['originalPosition'] = originalPosition.toJson();
    _data['type'] = type;
    _data['spot'] = spot;
    _data['sideOfStreet'] = sideOfStreet;
    _data['mappedRoadName'] = mappedRoadName;
    _data['label'] = label;
    _data['shapeIndex'] = shapeIndex;
    _data['source'] = source;
    return _data;
  }
}

class End {
  End({
    required this.linkId,
    required this.mappedPosition,
    required this.originalPosition,
    required this.type,
    required this.spot,
    required this.sideOfStreet,
    required this.mappedRoadName,
    required this.label,
    required this.shapeIndex,
    required this.source,
  });
  late final String linkId;
  late final MappedPosition mappedPosition;
  late final OriginalPosition originalPosition;
  late final String type;
  late final double spot;
  late final String sideOfStreet;
  late final String mappedRoadName;
  late final String label;
  late final int shapeIndex;
  late final String source;

  End.fromJson(Map<String, dynamic> json){
    linkId = json['linkId'];
    mappedPosition = MappedPosition.fromJson(json['mappedPosition']);
    originalPosition = OriginalPosition.fromJson(json['originalPosition']);
    type = json['type'];
    spot = json['spot'];
    sideOfStreet = json['sideOfStreet'];
    mappedRoadName = json['mappedRoadName'];
    label = json['label'];
    shapeIndex = json['shapeIndex'];
    source = json['source'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['linkId'] = linkId;
    _data['mappedPosition'] = mappedPosition.toJson();
    _data['originalPosition'] = originalPosition.toJson();
    _data['type'] = type;
    _data['spot'] = spot;
    _data['sideOfStreet'] = sideOfStreet;
    _data['mappedRoadName'] = mappedRoadName;
    _data['label'] = label;
    _data['shapeIndex'] = shapeIndex;
    _data['source'] = source;
    return _data;
  }
}

class Maneuver {
  Maneuver({
    required this.position,
    required this.instruction,
    required this.travelTime,
    required this.length,
    required this.id,
    required this.type,
  });
  late final Position position;
  late final String instruction;
  late final int travelTime;
  late final int length;
  late final String id;
  late final String type;

  Maneuver.fromJson(Map<String, dynamic> json){
    position = Position.fromJson(json['position']);
    instruction = json['instruction'];
    travelTime = json['travelTime'];
    length = json['length'];
    id = json['id'];
    type = json['_type'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['position'] = position.toJson();
    _data['instruction'] = instruction;
    _data['travelTime'] = travelTime;
    _data['length'] = length;
    _data['id'] = id;
    _data['_type'] = type;
    return _data;
  }
}

class Position {
  Position({
    required this.latitude,
    required this.longitude,
  });
  late final double latitude;
  late final double longitude;

  Position.fromJson(Map<String, dynamic> json){
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['latitude'] = latitude;
    _data['longitude'] = longitude;
    return _data;
  }
}

class Summary {
  Summary({
    required this.distance,
    required this.trafficTime,
    required this.baseTime,
    required this.flags,
    required this.text,
    required this.travelTime,
    required this.type,
  });
  late final int distance;
  late final int trafficTime;
  late final int baseTime;
  late final List<String> flags;
  late final String text;
  late final int travelTime;
  late final String type;

  Summary.fromJson(Map<String, dynamic> json){
    distance = json['distance'];
    trafficTime = json['trafficTime'];
    baseTime = json['baseTime'];
    flags = List.castFrom<dynamic, String>(json['flags']);
    text = json['text'];
    travelTime = json['travelTime'];
    type = json['_type'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['distance'] = distance;
    _data['trafficTime'] = trafficTime;
    _data['baseTime'] = baseTime;
    _data['flags'] = flags;
    _data['text'] = text;
    _data['travelTime'] = travelTime;
    _data['_type'] = type;
    return _data;
  }
}