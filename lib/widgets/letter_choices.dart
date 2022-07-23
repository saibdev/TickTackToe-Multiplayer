import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tictactoe/controllers/settings_controller.dart';
import 'package:tictactoe/models/tic_tac_toe.dart';
import 'package:tictactoe/widgets/custom_radio.dart';

class LetterChoices extends StatefulWidget {
  final bool showSelectedOnly;
  final Function(GameLetter value) onChange;

  const LetterChoices({Key? key, this.showSelectedOnly = false, required this.onChange}) : super(key: key);

  @override
  State<LetterChoices> createState() => _LetterChoicesState();
}

class _LetterChoicesState extends State<LetterChoices> {
  GameLetter letter = GameLetter.none;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsController>(
      init: SettingsController(),
      builder: (settingsController) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 2500),
          child: Row(
            children: [
              if (letter == GameLetter.none || widget.showSelectedOnly == false || widget.showSelectedOnly == true && letter == GameLetter.x)
              Expanded(
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 250),
                  opacity: letter == GameLetter.x? 1 : 0.5,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset('assets/themes/${settingsController.theme.toLowerCase()}/x.png'),
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: CustomRadioWidget<GameLetter>(
                          size: 40,
                          value: GameLetter.x,
                          groupValue: letter,
                          borderColors: const [
                            Colors.blue,
                            Colors.lightBlue,
                          ],
                          internalColors: const [
                            Colors.blue,
                            Colors.lightBlue,
                          ],
                          onChanged: (newValue) {
                            setState(() {
                              letter = newValue;
                            });
                            widget.onChange(newValue);
                          }
                        ),
                      ),
                    
                    ],
                  ),
                )
              ),
              if (letter == GameLetter.none || widget.showSelectedOnly == false || widget.showSelectedOnly == true && letter == GameLetter.o)
              Expanded(
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 250),
                  opacity: letter == GameLetter.o? 1 : 0.5,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset('assets/themes/${settingsController.theme.toLowerCase()}/o.png'),
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: CustomRadioWidget<GameLetter>(
                          size: 40,
                          value: GameLetter.o,
                          groupValue: letter,
                          borderColors: const [
                            Colors.deepOrange,
                            Colors.orange,
                          ],
                          internalColors: const [
                            Colors.deepOrange,
                            Colors.orange,
                          ],
                          onChanged: (newValue) {
                            setState(() {
                              letter = newValue;
                            });
                            widget.onChange(newValue);
                          }
                        ),
                      ),
                    ],
                  ),
                )
              ),
            ],
          ),
        );
      }
    );
  }
}