import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tictactoe/models/tic_tac_toe.dart';
import 'package:tictactoe/screens/offline_game.dart';
import 'package:tictactoe/widgets/letter_choices.dart';
import 'package:tictactoe/widgets/modern_switch.dart';

class GameSettings extends StatefulWidget {
  const GameSettings({Key? key}) : super(key: key);

  @override
  State<GameSettings> createState() => _GameSettingsState();
}

class _GameSettingsState extends State<GameSettings> {
  GameLetter letter = GameLetter.none;
  bool stupidAi = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 4),
                child: Center(
                  child: Text(
                    "Pick your side",
                    style: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: OrientationBuilder(
                  builder: (context, orientation) {
                    return SizedBox(
                      width: Get.mediaQuery.orientation == Orientation.landscape? 250 : null,
                      child: LetterChoices(
                        onChange: (value) {
                          setState(() {
                            letter = value;
                          });
                        }
                      ),
                    );
                  }
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Unbeatable AI',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blueGrey,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: ModernSwitch(
                          controller: stupidAi,
                          onTap: (newState) {
                            setState(() {
                              stupidAi = newState;
                            });
                          },
                          activeColor: Colors.green,
                        ),
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Stupid AI',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blueGrey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: SizedBox(
                    width: Get.width/2.5,
                    child: TextButton(
                      onPressed: () {
                        Get.to(() => Game(playerLetter: letter, stupidAi: stupidAi,));
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                        primary: Colors.blueGrey,
                        elevation: 7,
                        shape: const StadiumBorder(),
                        shadowColor: Colors.blue.shade200
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Continue'),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}