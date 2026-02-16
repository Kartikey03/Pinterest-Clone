/*
 * Domain entity for a photo/pin with JSON serialization for persistence.
 */

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
  final String imageUrl;
  final String thumbnailUrl;
  final String tinyUrl;
  final String alt;

  double get aspectRatio => height / width;

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
