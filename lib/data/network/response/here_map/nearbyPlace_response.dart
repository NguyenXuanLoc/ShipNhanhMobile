import 'package:geocoder/geocoder.dart';

class NearbyPlace {
  NearbyPlace({
    required this.error,
    required this.errorDescription,
    required this.results,
    required this.search,
  });
  late final String error;
  late final String errorDescription;
  late final Results results;
  late final Search search;

  NearbyPlace.fromJson(Map<String, dynamic> json){
    error = json['error'];
    errorDescription = json['error_description'];
    results = Results.fromJson(json['results']);
    search = Search.fromJson(json['search']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['error'] = error;
    _data['error_description'] = errorDescription;
    _data['results'] = results.toJson();
    _data['search'] = search.toJson();
    return _data;
  }
}

class Results {
  Results({
    required this.items,
  });
  late final List<Items> items;

  Results.fromJson(Map<String, dynamic> json){
    items = List.from(json['items']).map((e)=>Items.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['items'] = items.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Items {
  Items({
    required this.position,
    required this.distance,
    required this.title,
    required this.averageRating,
    required this.category,
    required this.icon,
    required this.vicinity,
    required this.having,
    required this.type,
    required this.href,
    required this.id,
  });
  late final List<double> position;
  late final int distance;
  late final String title;
  late final double averageRating;
  late final Category category;
  late final String icon;
  late final String vicinity;
  late final List<dynamic> having;
  late final String type;
  late final String href;
  late final String id;
  late final Address address;

  Items.fromJson(Map<String, dynamic> json){
    print('Items.fromJson 1');
    position = List.castFrom<dynamic, double>(json['position']);
    print('Items.fromJson 2');
    distance = json['distance'];
    print('Items.fromJson 3');
    title = json['title'];
    print('Items.fromJson 4');
    averageRating = json['averageRating'];
    print('Items.fromJson 5');
    category = Category.fromJson(json['category']);
    print('Items.fromJson 6');
    icon = json['icon'];
    vicinity = json['vicinity'];
    having = List.castFrom<dynamic, dynamic>(json['having']);
    type = json['type'];
    href = json['href'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['position'] = position;
    _data['distance'] = distance;
    _data['title'] = title;
    _data['averageRating'] = averageRating;
    _data['category'] = category.toJson();
    _data['icon'] = icon;
    _data['vicinity'] = vicinity;
    _data['having'] = having;
    _data['type'] = type;
    _data['href'] = href;
    _data['id'] = id;
    return _data;
  }
}

class Category {
  Category({
    required this.id,
    required this.title,
    required this.href,
    required this.type,
    required this.system,
  });
  late final String id;
  late final String title;
  late final String href;
  late final String type;
  late final String system;

  Category.fromJson(Map<String, dynamic> json){
    id = json['id'];
    title = json['title'];
    href = json['href'];
    type = json['type'];
    system = json['system'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['title'] = title;
    _data['href'] = href;
    _data['type'] = type;
    _data['system'] = system;
    return _data;
  }
}

class Id {
  Id({
    required this.id,
    required this.title,
    required this.group,
  });
  late final String id;
  late final String title;
  late final String group;

  Id.fromJson(Map<String, dynamic> json){
    id = json['id'];
    title = json['title'];
    group = json['group'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['title'] = title;
    _data['group'] = group;
    return _data;
  }
}

class Search {
  Search({
    required this.context,
  });
  late final Context context;

  Search.fromJson(Map<String, dynamic> json){
    context = Context.fromJson(json['context']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['context'] = context.toJson();
    return _data;
  }
}

class Context {
  Context({
    required this.location,
    required this.type,
    required this.href,
  });
  late final Location location;
  late final String type;
  late final String href;

  Context.fromJson(Map<String, dynamic> json){
    location = Location.fromJson(json['location']);
    type = json['type'];
    href = json['href'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['location'] = location.toJson();
    _data['type'] = type;
    _data['href'] = href;
    return _data;
  }
}

class Location {
  Location({
    required this.position,
    required this.address,
  });
  late final List<double> position;
  late final Address address;

  Location.fromJson(Map<String, dynamic> json){
    position = List.castFrom<dynamic, double>(json['position']);
    address = Address.fromJson(json['address']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['position'] = position;
    _data['address'] = address.toJson();
    return _data;
  }
}

class Address {
  Address({
    required this.text,
    required this.district,
    required this.city,
    required this.county,
    required this.country,
    required this.countryCode,
  });
  late final String text;
  late final String district;
  late final String city;
  late final String county;
  late final String country;
  late final String countryCode;

  Address.fromJson(Map<String, dynamic> json){
    text = json['text'];
    district = json['district'];
    city = json['city'];
    county = json['county'];
    country = json['country'];
    countryCode = json['countryCode'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['text'] = text;
    _data['district'] = district;
    _data['city'] = city;
    _data['county'] = county;
    _data['country'] = country;
    _data['countryCode'] = countryCode;
    return _data;
  }
}