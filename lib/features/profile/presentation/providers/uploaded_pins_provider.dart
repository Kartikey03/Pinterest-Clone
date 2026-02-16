import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kUploadedPinsKey = 'uploaded_pins_v1';

/// Represents a user-uploaded pin stored locally.
class UploadedPin {
  const UploadedPin({
    required this.id,
    required this.filePath,
    required this.timestamp,
  });

  final String id;
  final String filePath;
  final int timestamp;

  Map<String, dynamic> toJson() => {
    'id': id,
    'filePath': filePath,
    'timestamp': timestamp,
  };

  factory UploadedPin.fromJson(Map<String, dynamic> json) => UploadedPin(
    id: json['id'] as String,
    filePath: json['filePath'] as String,
    timestamp: json['timestamp'] as int,
  );
}

/// Manages user-uploaded pins.
///
/// Images are copied to the app's documents directory for persistence
/// and metadata is stored in SharedPreferences.
class UploadedPinsNotifier extends StateNotifier<List<UploadedPin>> {
  UploadedPinsNotifier() : super([]) {
    _load();
  }

  final _picker = ImagePicker();

  /// Pick an image from gallery and save locally.
  Future<bool> pickAndUpload() async {
    final xFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1920,
      maxHeight: 1920,
      imageQuality: 85,
    );

    if (xFile == null) return false;

    // Copy to persistent app directory
    final appDir = await getApplicationDocumentsDirectory();
    final pinsDirPath = '${appDir.path}/uploaded_pins';
    final pinsDir = Directory(pinsDirPath);
    if (!await pinsDir.exists()) {
      await pinsDir.create(recursive: true);
    }

    final ext =
        xFile.path.contains('.') ? '.${xFile.path.split('.').last}' : '';
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final destPath = '${pinsDir.path}/$id$ext';
    await File(xFile.path).copy(destPath);

    final pin = UploadedPin(
      id: id,
      filePath: destPath,
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );

    state = [pin, ...state];
    _persist();
    return true;
  }

  /// Remove an uploaded pin.
  void remove(String pinId) {
    final pin = state.firstWhere((p) => p.id == pinId);
    final file = File(pin.filePath);
    if (file.existsSync()) file.deleteSync();
    state = state.where((p) => p.id != pinId).toList();
    _persist();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_kUploadedPinsKey);
    if (jsonStr == null) return;

    try {
      final List<dynamic> list = jsonDecode(jsonStr);
      state =
          list
              .map((item) => UploadedPin.fromJson(item as Map<String, dynamic>))
              .toList();
    } catch (_) {}
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    final list = state.map((p) => p.toJson()).toList();
    await prefs.setString(_kUploadedPinsKey, jsonEncode(list));
  }
}

/// Global provider for uploaded pins.
final uploadedPinsProvider =
    StateNotifierProvider<UploadedPinsNotifier, List<UploadedPin>>((ref) {
      return UploadedPinsNotifier();
    });
