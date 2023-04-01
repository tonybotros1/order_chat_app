import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/auth_controllers/loading_sreen_controller.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoadingScreenController>(
        init: LoadingScreenController(),
        builder: (controller) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }
}
