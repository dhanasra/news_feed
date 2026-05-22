import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class NativeImageCompressor {
  static const _channel = MethodChannel('com.newsapp/image_compressor');

  static Future<Uint8List?> compress(Uint8List imageBytes, {int quality = 80}) async {
    try {
      final result = await _channel.invokeMethod<Uint8List>('compressImage', {
        'bytes': imageBytes,
        'quality': quality,
      });
      return result;
    } on PlatformException catch (e) {
      debugPrint(e.message);
      return imageBytes;
    }
  }
}