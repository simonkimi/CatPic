import 'dart:typed_data';

class ImageSize {
  ImageSize(this.width, this.height);

  final int width;
  final int height;

  static const headers = {
    'webp': [0x52, 0x49, 0x46, 0x46],
    'gif': [0x47, 0x49, 0x46, 0x38, 0x39, 0x61],
    'png': [0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a],
    'jpg': [0xff, 0xd8, 0xff],
  };

  static String? getType(Uint8List buffer) {
    final not = <String>{};
    for (var i = 0; i < 8; i++) {
      headers.forEach((key, value) {
        if (not.contains(key)) return;
        if (value.length > i && value[i] != buffer[i]) not.add(key);
      });
    }
    if (headers.keys.length == not.length) return null;
    final types = Set<String>.from(headers.keys)..removeAll(not);
    return types.first;
  }

  static ImageSize? getSize(Uint8List buffer) {
    final type = getType(buffer);
    final blob = ByteData.sublistView(buffer);
    switch (type) {
      case 'png':
        return ImageSize(
            blob.getUint32(0x10, Endian.big), blob.getUint32(0x14, Endian.big));
      case 'gif':
        return ImageSize(
            blob.getUint16(6, Endian.little), blob.getUint16(8, Endian.little));
      case 'webp':
        return ImageSize(blob.getUint16(0x1a, Endian.little),
            blob.getUint16(0x1c, Endian.little));
      case 'jpg':
        var offset = 2;
        while (true) {
          if (offset >= blob.lengthInBytes - 1) return null;
          final marker = blob.getUint16(offset);
          if (marker == 0xFFC0 || marker == 0xFFC2) {
            return ImageSize(blob.getInt16(offset + 7, Endian.big),
                blob.getInt16(offset + 5, Endian.big));
          }
          offset++;
        }
    }
    return null;
  }

  @override
  String toString() => 'ImageSize<$width, $height>';
}
