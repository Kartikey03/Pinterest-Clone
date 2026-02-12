import '../../../home/domain/entities/photo.dart';

/// Domain entity representing a board (collection of pins).
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
