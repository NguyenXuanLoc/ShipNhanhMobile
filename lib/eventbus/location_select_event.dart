class LocationSelectEvent {
  LocationSelectType type;

  LocationSelectEvent(this.type);
}

enum LocationSelectType { Suggest, Place, Map }
