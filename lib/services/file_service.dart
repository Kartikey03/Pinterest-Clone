/*
 * File service stub for future file download and local storage features.
 */
library;

class FileService {
  FileService._();
  static final FileService _instance = FileService._();
  static FileService get instance => _instance;

  Future<void> init() async {}
}
