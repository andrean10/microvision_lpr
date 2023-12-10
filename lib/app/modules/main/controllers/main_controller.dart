import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:microvision_lpr/app/helpers/utils.dart';
import 'package:microvision_lpr/app/modules/init/init_controller.dart';
import 'package:image/image.dart' as img;
import 'dart:ui' as ui;
import 'package:palette_generator/palette_generator.dart';
import 'package:path_provider/path_provider.dart';

import '../../../routes/app_pages.dart';
import '../views/components/painters/object_detector_painter.dart';

class MainController extends GetxController with WidgetsBindingObserver {
  late final InitController _initC;
  late CameraController cameraC;
  late List<CameraDescription> cameras;

  ObjectDetector? _objectDetector;
  TextRecognizer? _textRecognizer;
  FlutterTts? flutterTts;
  // final objectDetectionC = BehaviorSubject<ObjectDetectionModel>();
  // final objectDetectionC = Rxn<ObjectDetectionModel>();

  final objectPainter = Rxn<ObjectDetectorPainter>();
  final imagePreview = Rxn<Uint8List>();

  final isCameraInitialized = false.obs;
  final isCameraFront = false.obs;
  final isCameraPaused = false.obs;
  var isTakePicture = false;

  final _orientations = {
    DeviceOrientation.portraitUp: 0,
    DeviceOrientation.landscapeLeft: 90,
    DeviceOrientation.portraitDown: 180,
    DeviceOrientation.landscapeRight: 270,
  };

  final isColorRed = false.obs;
  final textLicensePlate = RxnString();

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    debugPrint('debug: state = $state');
    if (state == AppLifecycleState.resumed) {
      debugPrint('debug: cameraC resumed = ${cameraC.value.isStreamingImages}');
      if (!cameraC.value.isStreamingImages) {
        _initCamera();
        startImage(cameras);
      }
    } else if (state == AppLifecycleState.paused) {
      debugPrint('debug: cameraC paused = ${cameraC.value}');
      if (cameraC.value.isStreamingImages) {
        cameraC.stopImageStream();
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    _init();

    everAll(
      [
        isColorRed,
        textLicensePlate,
      ],
      (callback) {
        if (isColorRed.value && textLicensePlate.value != null) {
          _triggerTTS(textLicensePlate.value!);
        }
      },
    );
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  Future<void> _init() async {
    if (Get.isRegistered<InitController>()) {
      _initC = Get.find<InitController>();
    }

    _initObjectDetector();
    _initTextRecognizion();
    _initTTS();
    _initCamera();
  }

  Future<void> _initObjectDetector() async {
    final modelPath = await getAssetPath('assets/ml/object_labeler.tflite');
    final options = LocalObjectDetectorOptions(
      mode: DetectionMode.stream,
      modelPath: modelPath,
      classifyObjects: true,
      multipleObjects: true,
    );
    _objectDetector = ObjectDetector(options: options);
  }

  void _initTextRecognizion() {
    _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
  }

  void _initTTS() {
    flutterTts = FlutterTts();
    flutterTts!.isLanguageAvailable('id-ID').then((value) {
      if (value) {
        flutterTts?.setLanguage('id-ID');
      } else {
        flutterTts?.setLanguage('en-US');
      }
    }).catchError((e) {
      debugPrint('error: isLanguageAvailable = $e');
    });
    flutterTts?.setVolume(1);
    flutterTts?.setSpeechRate(0.5);
  }

  Future<void> _initCamera() async {
    cameras = await availableCameras();
    cameraC = CameraController(
      (isCameraFront.value) ? cameras.last : cameras.first,
      ResolutionPreset.high,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.nv21
          : ImageFormatGroup.bgra8888,
      enableAudio: false,
    );

    cameraC.setFocusMode(FocusMode.auto);
    cameraC.setFlashMode(FlashMode.off);

    cameraC.initialize().then((_) {
      isCameraInitialized.value = true;
      startImage(cameras);
    }).catchError((e) {
      debugPrint('debug: error = $e');

      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }

        debugPrint('debug: error = ${e.code}');
      }
      return e;
    });
  }

  void startImage(List<CameraDescription> cameras) {
    cameraC.startImageStream((image) {
      final inputImage = _inputImageFromCameraImage(image, cameras);
      if (inputImage == null) return;
      _processObjectDetection(inputImage);
    });
  }

  InputImage? _inputImageFromCameraImage(
    CameraImage image,
    List<CameraDescription> cameras,
  ) {
    // get image rotation
    // it is used in android to convert the InputImage from Dart to Java
    // `rotation` is not used in iOS to convert the InputImage from Dart to Obj-C
    // in both platforms `rotation` and `camera.lensDirection` can be used to compensate `x` and `y` coordinates on a canvas
    final camera = (isCameraFront.value) ? cameras.last : cameras.first;
    final sensorOrientation = camera.sensorOrientation;
    InputImageRotation? rotation;

    if (Platform.isIOS) {
      rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
    } else if (Platform.isAndroid) {
      var rotationCompensation = _orientations[cameraC.value.deviceOrientation];

      if (rotationCompensation == null) return null;
      if (camera.lensDirection == CameraLensDirection.front) {
        // front-facing
        rotationCompensation = (sensorOrientation + rotationCompensation) % 360;
      } else {
        // back-facing
        rotationCompensation =
            (sensorOrientation - rotationCompensation + 360) % 360;
      }
      rotation = InputImageRotationValue.fromRawValue(rotationCompensation);
    }
    if (rotation == null) return null;

    // get image format
    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    // validate format depending on platform
    // only supported formats:
    // * nv21 for Android
    // * bgra8888 for iOS
    if (format == null ||
        (Platform.isAndroid && format != InputImageFormat.nv21) ||
        (Platform.isIOS && format != InputImageFormat.bgra8888)) return null;

    if (image.planes.length != 1) return null;
    final plane = image.planes.first;

    return InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(
          image.width.toDouble(),
          image.height.toDouble(),
        ),
        rotation: rotation, // used only in Android
        format: format, // used only in iOS
        bytesPerRow: plane.bytesPerRow, // used only in iOS
      ),
    );
  }

  static Future<Map<String, dynamic>?> processObject(
    Map<String, dynamic> args,
  ) async {
    final objects = args['objects'] as List<DetectedObject>;
    final inputImage = args['input_image'] as InputImage;

    if (inputImage.metadata?.size != null &&
        inputImage.metadata?.rotation != null) {
      if (objects.isNotEmpty) {
        var filteredObjects = <DetectedObject>[];
        var licenseObject = <DetectedObject>[];

        for (var object in objects) {
          for (var label in object.labels) {
            debugPrint(
                'debug: isCar = ${label.text.toLowerCase().contains('car')}');
            debugPrint(
                'debug: isLicensePlat = ${label.text.toLowerCase().contains('license plate')}');

            if (label.text.toLowerCase().contains('car') ||
                label.text.toLowerCase().contains('license plate')) {
              filteredObjects.add(object);

              if (label.text.toLowerCase().contains('license plate')) {
                licenseObject.add(object);
              }
            }
          }

          final painter = ObjectDetectorPainter(
            objects: filteredObjects,
            metadata: inputImage.metadata!,
            isCameraFront: inputImage.metadata!.rotation ==
                InputImageRotation.rotation270deg,
          );

          return {
            'painter': painter,
            'license_object': licenseObject,
          };
        }
      }
    }
    return null;
  }

  void _processObjectDetection(InputImage inputImage) async {
    if (_objectDetector == null) return;

    try {
      final objects = await _objectDetector!.processImage(inputImage);

      final args = {
        'objects': objects,
        'input_image': inputImage,
      };

      final map = await compute(processObject, args);
      final painter = map?['painter'] as ObjectDetectorPainter?;
      final licenseObject = map?['license_object'] as List<DetectedObject>?;

      objectPainter.value = painter;

      if (licenseObject != null) {
        final width = licenseObject.first.boundingBox.width;
        final height = licenseObject.first.boundingBox.height;
        final x = licenseObject.first.boundingBox.left;
        final y = licenseObject.first.boundingBox.top;

        if (!isTakePicture) {
          cameraC.takePicture().then((XFile value) async {
            isTakePicture = true;
            final tempDir = await getTemporaryDirectory();
            final fileBytes = await value.readAsBytes();
            final image = img.decodeImage(fileBytes);
            final croppedImage = img.copyCrop(
              image!,
              width: width.toInt(),
              height: height.toInt(),
              x: x.toInt(),
              y: y.toInt(),
            );

            final imageBytes = img.encodeJpg(croppedImage);
            final isSaved = await img.encodeJpgFile(
              '${tempDir.path}/license_plate.jpg',
              croppedImage,
            );

            imagePreview.value = imageBytes;
            _checkDominantColor(imageBytes);

            if (isSaved) {
              final fileImage = File('${tempDir.path}/license_plate.jpg');
              _processTextRecognizer(fileImage);
            }
          });
        }
      }
    } catch (e) {
      debugPrint('error: processImage = $e');
      objectPainter.value = null;
    }
  }

  void _processTextRecognizer(File fileImage) async {
    final inputImage = InputImage.fromFile(fileImage);

    try {
      final recognizedText = await _textRecognizer!.processImage(inputImage);
      // final text = recognizedText.text;
      final text = recognizedText.blocks.first.text;
      textLicensePlate.value = text;

      for (var block in recognizedText.blocks) {
        final text = block.text;
        debugPrint('debug: block text = $text');

        for (var line in block.lines) {
          debugPrint('debug: line text = ${line.text}');
          for (var element in line.elements) {
            debugPrint('debug: element text = ${element.text}');
          }
        }
      }
    } catch (e) {
      debugPrint('error: textRecognizer = $e');
    }
  }

  Future _checkDominantColor(Uint8List imageBytes) async {
    final ui.Image image = await decodeImageFromList(imageBytes);
    final colors = await PaletteGenerator.fromImage(image);
    final dominantColor = colors.dominantColor?.color;

    if (dominantColor != null &&
        dominantColor.red > dominantColor.blue &&
        dominantColor.red > dominantColor.green) {
      debugPrint('debug: plat kendaraan berwarna merah');
      isColorRed.value = true;
    }
  }

  void _triggerTTS(String numberLicensePlate) {
    if (flutterTts == null) return;
    flutterTts?.speak(
      'Selamat datang ASN $numberLicensePlate silahkan menggunakan bahan bakar non subsidi',
    );
  }

  Future<void> logout() async {
    Get.defaultDialog(
      title: 'Perhatian',
      middleText: 'Apakah anda yakin ingin keluar dari aplikasi?',
      textCancel: 'Tidak',
      textConfirm: 'Ya',
      onConfirm: () {
        _initC.deleteSession().then((_) => Get.offAllNamed(Routes.LOGIN));
      },
    );
  }

  @override
  void dispose() {
    _objectDetector?.close();
    _textRecognizer?.close();
    super.dispose();
  }
}
