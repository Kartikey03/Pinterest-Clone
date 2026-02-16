/*
 * Board domain entity representing a collection of pins.
 */

import '../../../home/domain/entities/photo.dart';

class Board {
  const Board({
    required this.id,
    required this.name,
    this.description = '',
    this.coverPhoto,
    this.pinCount = 0,
    this.isPrivate = false,
  });

  final String id;
  final String name;
  final String description;
  final Photo? coverPhoto;
  final int pinCount;
  final bool isPrivate;
}
