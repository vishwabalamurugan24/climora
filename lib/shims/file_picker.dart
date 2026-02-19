// Lightweight shim for `file_picker` used during analysis/prototyping.
enum FileType { any, audio }

class PlatformFile {
  final String? path;
  PlatformFile({this.path});
}

class FilePickerResult {
  final List<PlatformFile> files;
  FilePickerResult(this.files);
}

class FilePicker {
  static final FilePicker platform = FilePicker._();
  FilePicker._();

  /// Returns `null` in the shim (no UI), keeping the API surface.
  Future<FilePickerResult?> pickFiles({FileType? type}) async {
    return null;
  }
}
