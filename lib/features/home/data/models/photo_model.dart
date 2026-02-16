/*
 * Data model mapping Pexels API photo object to domain Photo entity.
 */

import '../../domain/entities/photo.dart';

class PhotoModel {
  const PhotoModel({
    required this.id,
    required this.width,
    required this.height,
    required this.photographer,
    required this.photographerUrl,
    required this.src,
    required this.alt,
  });

  final int id;
  final int width;
  final int height;
  final String photographer;
  final String photographerUrl;
  final PhotoSrcModel src;
  final String alt;

  factory PhotoModel.fromJson(Map<String, dynamic> json) {
    return PhotoModel(
      id: json['id'] as int,
      width: json['width'] as int,
      height: json['height'] as int,
      photographer: json['photographer'] as String? ?? 'Unknown',
      photographerUrl: json['photographer_url'] as String? ?? '',
      src: PhotoSrcModel.fromJson(json['src'] as Map<String, dynamic>),
      alt: json['alt'] as String? ?? '',
    );
  }

  Photo toEntity() {
    return Photo(
      id: id,
      width: width,
      height: height,
      photographer: photographer,
      photographerUrl: photographerUrl,
      imageUrl: src.large2x,
      thumbnailUrl: src.medium,
      tinyUrl: src.tiny,
      alt: alt,
    );
  }
}

class PhotoSrcModel {
  const PhotoSrcModel({
    required this.original,
    required this.large2x,
    required this.large,
    required this.medium,
    required this.small,
    required this.portrait,
    required this.landscape,
    required this.tiny,
  });

  final String original;
  final String large2x;
  final String large;
  final String medium;
  final String small;
  final String portrait;
  final String landscape;
  final String tiny;

  factory PhotoSrcModel.fromJson(Map<String, dynamic> json) {
    return PhotoSrcModel(
      original: json['original'] as String? ?? '',
      large2x: json['large2x'] as String? ?? '',
      large: json['large'] as String? ?? '',
      medium: json['medium'] as String? ?? '',
      small: json['small'] as String? ?? '',
      portrait: json['portrait'] as String? ?? '',
      landscape: json['landscape'] as String? ?? '',
      tiny: json['tiny'] as String? ?? '',
    );
  }
}
