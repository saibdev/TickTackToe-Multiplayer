import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tictactoe/controllers/settings_controller.dart';
import 'package:tictactoe/models/tic_tac_toe.dart';

class RepresentLetter extends StatelessWidget {
  final GameLetter letter;
  final double? width;
  
  const RepresentLetter(this.letter, {Key? key, this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsController>(
      init: SettingsController(),
      builder: (settingsController) {
        return Image.asset(
          letter == GameLetter.x? 'assets/themes/${settingsController.theme.toLowerCase()}/x.png' : 'assets/themes/${settingsController.theme.toLowerCase()}/o.png',
          width: width,
        );
      }
    );
  }
}