import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../controllers/main_controller.dart';

class MainView extends GetView<MainController> {
  const MainView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    PreferredSizeWidget builderAppBar() {
      return AppBar(
        actions: [
          IconButton(
            onPressed: () {
              if (controller.isCameraPaused.value) {
                controller.cameraC.resumePreview();
                controller.isCameraPaused.toggle();
              } else {
                controller.cameraC.pausePreview();
                controller.isCameraPaused.toggle();
              }
            },
            icon: Obx(
              () => Icon(
                (controller.isCameraPaused.value)
                    ? Icons.play_arrow
                    : Icons.pause,
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              controller.isCameraFront.toggle();
              controller.cameraC.setDescription(
                controller.isCameraFront.value
                    ? controller.cameras.last
                    : controller.cameras.first,
              );
            },
            icon: Obx(
              () => Icon(
                (controller.isCameraFront.value)
                    ? Icons.camera_front
                    : Icons.camera_rear,
              ),
            ),
          ),
        ],
      );
    }

    Widget builderCamera() {
      return Container(
        color: Colors.black,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Center(
              child: Obx(
                () => (controller.isCameraInitialized.value)
                    ? CameraPreview(
                        controller.cameraC,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            (controller.objectPainter.value != null)
                                ? CustomPaint(
                                    painter: controller.objectPainter.value,
                                  )
                                : const SizedBox(),
                            // Align(
                            //   alignment: Alignment.center,
                            //   child: Column(
                            //     mainAxisSize: MainAxisSize.min,
                            //     children: [],
                            //   ),
                            // ),
                            Positioned(
                              top: 12,
                              right: 12,
                              child: Container(
                                color: theme.colorScheme.background,
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  children: [
                                    if (controller.imagePreview.value != null)
                                      GestureDetector(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: const Text('Hasil Foto'),
                                              content: Image.memory(
                                                controller.imagePreview.value!,
                                                width: 300,
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('Tutup'),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        child: Image.memory(
                                          controller.imagePreview.value!,
                                          width: 150,
                                        ),
                                      ),
                                    const Gap(12),
                                    if (controller.textLicensePlate.value !=
                                        null) ...[
                                      Text(
                                        (controller.isColorRed.value)
                                            ? 'ASN'
                                            : 'Non-ASN',
                                        style: theme.textTheme.titleMedium,
                                      ),
                                      const Gap(4),
                                      Text(
                                        'Plat Nomor: ${controller.textLicensePlate.value ?? '-'}',
                                        style: theme.textTheme.titleMedium,
                                      ),
                                    ]
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : const CircularProgressIndicator(),
              ),
            ),
          ],
        ),
      );

      //   return CameraAwesomeBuilder.previewOnly(
      //     builder: (state, preview) {
      //       return AwesomeCameraLayout(
      //         state: state,
      //         topActions: AwesomeTopActions(
      //           state: state,
      //           children: [
      //             AwesomeFlashButton(state: state),
      //             AwesomeZoomSelector(state: state),
      //             AwesomeCameraSwitchButton(
      //               state: state,
      //               scale: 1,
      //             ),
      //           ],
      //         ),
      //         middleContent: builderCustomPaint(),
      //         bottomActions: const SizedBox(),
      //       );
      //     },
      //     onImageForAnalysis: (image) => controller.processObjectDetector(image),
      //     imageAnalysisConfig: AnalysisConfig(
      //       // androidOptions: const AndroidAnalysisOptions.nv21(width: 1024),
      //       maxFramesPerSecond: 5,
      //     ),
      //   );
    }

    return Scaffold(
      appBar: builderAppBar(),
      body: builderCamera(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          controller.isTakePicture = false;
          controller.imagePreview.value = null;
          controller.isColorRed.value = false;
          controller.textLicensePlate.value = null;
        },
        label: const Text('Foto Ulang'),
      ),
    );
  }
}
