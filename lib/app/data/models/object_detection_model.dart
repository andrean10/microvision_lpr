// import 'dart:ui';

// import 'package:camerawesome/camerawesome_plugin.dart';
// import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';

// class ObjectDetectionModel {
//   final List<DetectedObject> objects;
//   final Size? absoluteImageSize;
//   final int? rotation;
//   final InputImageRotation? imageRotation;
//   final AnalysisImage? img;

//   ObjectDetectionModel({
//     required this.objects,
//     this.absoluteImageSize,
//     this.rotation,
//     this.imageRotation,
//     this.img,
//   });

//   Size get croppedSize => img!.croppedSize;

//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       other is ObjectDetectionModel &&
//           runtimeType == other.runtimeType &&
//           objects == other.objects &&
//           absoluteImageSize == other.absoluteImageSize &&
//           rotation == other.rotation &&
//           imageRotation == other.imageRotation &&
//           croppedSize == other.croppedSize;

//   @override
//   int get hashCode =>
//       objects.hashCode ^
//       absoluteImageSize.hashCode ^
//       rotation.hashCode ^
//       imageRotation.hashCode ^
//       croppedSize.hashCode;

//   @override
//   String toString() {
//     return 'ObjectDetectionModel{objects: $objects, absoluteImageSize: $absoluteImageSize, rotation: $rotation, imageRotation: $imageRotation, img: $img}';
//   }
// }
