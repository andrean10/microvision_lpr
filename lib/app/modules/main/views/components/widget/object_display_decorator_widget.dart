// import 'package:camerawesome/camerawesome_plugin.dart';
// import 'package:flutter/material.dart';
// import 'package:microvision_lpr/app/data/models/object_detection_model.dart';

// import '../painters/object_detector_painter.dart';

// class ObjectDisplayDecoratorWidget extends StatelessWidget {
//   final CameraState cameraState;
//   final Stream<ObjectDetectionModel> objectDetectionStream;
//   final Preview preview;

//   const ObjectDisplayDecoratorWidget({
//     required this.cameraState,
//     required this.objectDetectionStream,
//     required this.preview,
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return IgnorePointer(
//       child: StreamBuilder(
//         stream: cameraState.sensorConfig$,
//         builder: (_, snapshot) {
//           if (!snapshot.hasData) {
//             return const SizedBox();
//           } else {
//             return StreamBuilder<ObjectDetectionModel>(
//               stream: objectDetectionStream,
//               builder: (_, objectModelSnapshot) {
//                 if (!objectModelSnapshot.hasData) return const SizedBox();
//                 // this is the transformation needed to convert the image to the preview
//                 // Android mirrors the preview but the analysis image is not
//                 final canvasTransformation = objectModelSnapshot.data!.img
//                     ?.getCanvasTransformation(preview);
//                 return CustomPaint(
//                   painter: ObjectDetectorPainter(
//                     model: objectModelSnapshot.requireData,
//                     canvasTransformation: canvasTransformation,
//                     preview: preview,
//                   ),
//                 );
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }
