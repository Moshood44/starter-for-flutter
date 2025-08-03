class Location {
  final String address;
  final double? latitude;
  final double? longitude;
  final String? city;
  final String? state;
  final String? country;

  const Location({
    required this.address,
    this.latitude,
    this.longitude,
    this.city,
    this.state,
    this.country,
  });

  // JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'city': city,
      'state': state,
      'country': country,
    };
  }

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      address: json['address'] as String,
      latitude: json['latitude'] as double?,
      longitude: json['longitude'] as double?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      country: json['country'] as String?,
    );
  }

  // Validation
  bool get isValid {
    return address.isNotEmpty;
  }

  String get displayAddress {
    final parts = <String>[address];
    if (city != null && city!.isNotEmpty) parts.add(city!);
    if (state != null && state!.isNotEmpty) parts.add(state!);
    return parts.join(', ');
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Location &&
        other.address == address &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.city == city &&
        other.state == state &&
        other.country == country;
  }

  @override
  int get hashCode {
    return Object.hash(address, latitude, longitude, city, state, country);
  }

  @override
  String toString() {
    return 'Location(address: $address, city: $city, state: $state)';
  }
}