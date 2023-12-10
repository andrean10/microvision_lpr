import 'dart:io';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';

import '../../../../../helpers/coordinates_translator.dart';

class ObjectDetectorPainter extends CustomPainter {
  // final ObjectDetectionModel model;
  // final CanvasTransformation? canvasTransformation;
  // final Preview? preview;

  final List<DetectedObject> objects;
  final InputImageMetadata metadata;
  final bool isCameraFront;

  ObjectDetectorPainter({
    // required this.model,
    // this.canvasTransformation,
    // this.preview,
    required this.objects,
    required this.metadata,
    required this.isCameraFront,
    super.repaint,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (objects.isEmpty) return;
    // if (preview == null ||
    //     model.img == null ||
    //     model.objects.isEmpty ||
    //     model.absoluteImageSize == null ||
    //     model.imageRotation == null) {
    //   return;
    // }

    // We apply the canvas transformation to the canvas so that the barcode
    // rect is drawn in the correct orientation. (Android only)
    // if (canvasTransformation != null) {
    //   canvas.save();
    //   canvas.applyTransformation(canvasTransformation!, size);
    // }

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = Colors.lightGreenAccent;

    final Paint background = Paint()..color = const Color(0x99000000);

    for (var detectedObject in objects) {
      final ParagraphBuilder builder = ParagraphBuilder(
        ParagraphStyle(
          textAlign: TextAlign.left,
          fontSize: 16,
          textDirection: TextDirection.ltr,
        ),
      );
      builder.pushStyle(
        ui.TextStyle(
          color: Colors.lightGreenAccent,
          background: background,
        ),
      );
      if (detectedObject.labels.isNotEmpty) {
        final label = detectedObject.labels
            .reduce((a, b) => a.confidence > b.confidence ? a : b);
        builder.addText(
            '${label.text} ${(label.confidence * 100).toStringAsFixed(1)}%\n');
      }
      builder.pop();

      final left = translateX(
        detectedObject.boundingBox.left,
        size,
        metadata.size,
        metadata.rotation,
        isCameraFront,
      );
      final top = translateY(
        detectedObject.boundingBox.top,
        size,
        metadata.size,
        metadata.rotation,
      );
      final right = translateX(
        detectedObject.boundingBox.right,
        size,
        metadata.size,
        metadata.rotation,
        isCameraFront,
      );
      final bottom = translateY(
        detectedObject.boundingBox.bottom,
        size,
        metadata.size,
        metadata.rotation,
      );

      var rect = Rect.fromLTRB(left, top, right, bottom);

      // debugPrint('debug: rect = $rect');

      canvas.drawRect(rect, paint);

      canvas.drawParagraph(
        builder.build()
          ..layout(ParagraphConstraints(
            width: (right - left).abs(),
          )),
        Offset(
          Platform.isAndroid && isCameraFront ? right : left,
          top,
        ),
      );
    }

    // if you want to draw without canvas transformation, use this:
    // if (canvasTransformation != null) {
    //   canvas.restore();
    // }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  // @override
  // bool shouldRepaint(ObjectDetectorPainter oldDelegate) {
  //   return oldDelegate.model != model;
  // }
}
