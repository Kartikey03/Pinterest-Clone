/// Domain entity representing a photo/pin.
///
/// Decoupled from the Pexels API response model so the domain
/// layer has zero dependency on any external API.
class Photo {
  const Photo({
    required this.id,
    required this.width,
    required this.height,
    required this.photographer,
    required this.photographerUrl,
    required this.imageUrl,
    required this.thumbnailUrl,
    required this.tinyUrl,
    required this.alt,
  });

  final int id;
  final int width;
  final int height;
  final String photographer;
  final String photographerUrl;

  /// High-quality image URL (large2x from Pexels).
  final String imageUrl;

  /// Medium quality for grid display.
  final String thumbnailUrl;

  /// Tiny placeholder for blurred loading preview.
  final String tinyUrl;

  /// Alt text / description.
  final String alt;

  /// Aspect ratio used to size masonry grid cards.
  /// Pinterest varies card heights based on this value.
  double get aspectRatio => height / width;

  /// Serialize to JSON map for SharedPreferences storage.
  Map<String, dynamic> toJson() => {
    'id': id,
    'width': width,
    'height': height,
    'photographer': photographer,
    'photographerUrl': photographerUrl,
    'imageUrl': imageUrl,
    'thumbnailUrl': thumbnailUrl,
    'tinyUrl': tinyUrl,
    'alt': alt,
  };

  /// Deserialize from JSON map.
  factory Photo.fromJson(Map<String, dynamic> json) => Photo(
    id: json['id'] as int,
    width: json['width'] as int,
    height: json['height'] as int,
    photographer: json['photographer'] as String,
    photographerUrl: json['photographerUrl'] as String,
    imageUrl: json['imageUrl'] as String,
    thumbnailUrl: json['thumbnailUrl'] as String,
    tinyUrl: json['tinyUrl'] as String,
    alt: json['alt'] as String,
  );
}
