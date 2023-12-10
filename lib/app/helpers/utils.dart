import 'dart:io';
// import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

Future<String> getAssetPath(String asset) async {
  final path = await getLocalPath(asset);
  await Directory(dirname(path)).create(recursive: true);
  final file = File(path);

  if (!await file.exists()) {
    final byteData = await rootBundle.load(asset);
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
  }
  return file.path;
}

Future<String> getLocalPath(String path) async {
  return '${(await getApplicationSupportDirectory()).path}/$path';
}

// extension MLKitUtils on AnalysisImage {
//   InputImage toInputImage() {
//     return when(
//       nv21: (image) {
//         return InputImage.fromBytes(
//           bytes: image.bytes,
//           metadata: InputImageMetadata(
//             rotation: inputImageRotation,
//             format: InputImageFormat.nv21,
//             size: image.size,
//             bytesPerRow: image.planes.first.bytesPerRow,
//           ),
//         );
//       },
//       bgra8888: (image) {
//         final inputImageData = InputImageMetadata(
//           size: size,
//           rotation: inputImageRotation,
//           format: inputImageFormat,
//           bytesPerRow: image.planes.first.bytesPerRow,
//         );

//         return InputImage.fromBytes(
//           bytes: image.bytes,
//           metadata: inputImageData,
//         );
//       },
//     )!;
//   }

//   InputImageRotation get inputImageRotation =>
//       InputImageRotation.values.byName(rotation.name);

//   InputImageFormat get inputImageFormat {
//     switch (format) {
//       case InputAnalysisImageFormat.bgra8888:
//         return InputImageFormat.bgra8888;
//       case InputAnalysisImageFormat.nv21:
//         return InputImageFormat.nv21;
//       default:
//         return InputImageFormat.yuv420;
//     }
//   }
// }

// extension InputImageRotationConversion on InputImageRotation {
//   double toRadians() {
//     final degrees = toDegrees();
//     return degrees * 2 * pi / 360;
//   }

//   int toDegrees() {
//     switch (this) {
//       case InputImageRotation.rotation0deg:
//         return 0;
//       case InputImageRotation.rotation90deg:
//         return 90;
//       case InputImageRotation.rotation180deg:
//         return 180;
//       case InputImageRotation.rotation270deg:
//         return 270;
//     }
//   }
// }
