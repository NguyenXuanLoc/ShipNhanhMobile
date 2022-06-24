class SearchPlace {
  SearchPlace({
    required this.error,
    required this.errorDescription,
    required this.items,
    required this.queryTerms,
  });
  late final String error;
  late final String errorDescription;
  late final List<HereSearchItem> items;
  late final List<dynamic> queryTerms;

  SearchPlace.fromJson(Map<String, dynamic> json){
    error = json['error'];
    errorDescription = json['error_description'];
    items = List.from(json['items']).map((e)=>HereSearchItem.fromJson(e)).toList();
    queryTerms = List.castFrom<dynamic, dynamic>(json['queryTerms']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['error'] = error;
    _data['error_description'] = errorDescription;
    _data['items'] = items.map((e)=>e.toJson()).toList();
    _data['queryTerms'] = queryTerms;
    return _data;
  }
}

class HereSearchItem {
  HereSearchItem({
    required this.title,
    required this.id,
    required this.resultType,
    required this.address,
    required this.position,
    required this.access,
    required this.distance,
    required this.categories,
    required this.highlights,
  });
  late final String title;
  late final String id;
  late final String resultType;
  late final Address address;
  late final Position position;
  late final List<Access> access;
  late final int distance;
  late final List<Categories> categories;
  late final Highlights highlights;

  HereSearchItem.fromJson(Map<String, dynamic> json){
    print('HereSearchItem.fromJson 1');
    title = json['title'];
    print('HereSearchItem.fromJson 2');
    id = json['id'];
    print('HereSearchItem.fromJson 3');
    resultType = json['resultType'];
    print('HereSearchItem.fromJson 4');
    address = Address.fromJson(json['address']);
    print('HereSearchItem.fromJson 5');
    position = Position.fromJson(json['position']);
    print('HereSearchItem.fromJson 6');
    // access = List.from(json['access']).map((e)=>Access.fromJson(e)).toList();
    print('HereSearchItem.fromJson 7');
    distance = json['distance'];
    print('HereSearchItem.fromJson 8');
   // categories = List.from(json['categories']).map((e)=>Categories.fromJson(e)).toList();
    print('HereSearchItem.fromJson 9');
    //highlights = Highlights.fromJson(json['highlights']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['title'] = title;
    _data['id'] = id;
    _data['resultType'] = resultType;
    _data['address'] = address.toJson();
    _data['position'] = position.toJson();
    _data['access'] = access.map((e)=>e.toJson()).toList();
    _data['distance'] = distance;
    _data['categories'] = categories.map((e)=>e.toJson()).toList();
    _data['highlights'] = highlights.toJson();
    return _data;
  }
}

class Address {
  Address({
    required this.label,
  });
  late final String label;

  Address.fromJson(Map<String, dynamic> json){
    label = json['label'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['label'] = label;
    return _data;
  }
}

class Position {
  Position({
    required this.lat,
    required this.lng,
  });
  late final double lat;
  late final double lng;

  Position.fromJson(Map<String, dynamic> json){
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['lat'] = lat;
    _data['lng'] = lng;
    return _data;
  }
}

class Access {
  Access({
    required this.lat,
    required this.lng,
  });
  late final double lat;
  late final double lng;

  Access.fromJson(Map<String, dynamic> json){
    print( 'Access.fromJson 1');
    lat = json['lat'];
    print( 'Access.fromJson 2');
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['lat'] = lat;
    _data['lng'] = lng;
    return _data;
  }
}

class Categories {
  Categories({
    required this.id,
    required this.name,
    required this.primary,
  });
  late final String id;
  late final String name;
  late final bool primary;

  Categories.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    primary = json['primary'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['primary'] = primary;
    return _data;
  }
}

class Highlights {
  Highlights({
    required this.title,
    required this.address,
  });
  late final List<Title> title;
  late final Address address;

  Highlights.fromJson(Map<String, dynamic> json){
    title = List.from(json['title']).map((e)=>Title.fromJson(e)).toList();
    address = Address.fromJson(json['address']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['title'] = title.map((e)=>e.toJson()).toList();
    _data['address'] = address.toJson();
    return _data;
  }
}

class Title {
  Title({
    required this.start,
    required this.end,
  });
  late final int start;
  late final int end;

  Title.fromJson(Map<String, dynamic> json){
    start = json['start'];
    end = json['end'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['start'] = start;
    _data['end'] = end;
    return _data;
  }
}