import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:tictactoe/controllers/offline_game_controller.dart';
import 'package:tictactoe/controllers/settings_controller.dart';
import 'package:tictactoe/models/tic_tac_toe.dart';
import 'package:tictactoe/widgets/board.dart';
import 'package:tictactoe/widgets/represent_letter.dart';

class Game extends StatefulWidget {
  final GameMode mode;
  final GameLetter playerLetter;
  final bool stupidAi;
  const Game({Key? key, required this.playerLetter, this.mode=GameMode.ai, this.stupidAi = false}) : super(key: key);

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  late GameLetter playerLetter  = widget.playerLetter;
  late GameMode mode            = widget.mode;
  late bool stupidAi            = widget.stupidAi;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GetBuilder<GameController>(
            init: GameController(mode: mode, playerOne: playerLetter, stupidAi: stupidAi),
            builder: (controller) {
              return GetBuilder<SettingsController>(
                init: SettingsController(),
                builder: (settingsController) {
                  return OrientationBuilder(
                    builder: (context, orientation) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(4),
                                    child: Column(
                                      children: [
                                        FittedBox(
                                          child: Text(
                                            settingsController.nickName,
                                            style: const TextStyle(
                                              color: Colors.blueGrey,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        AnimatedOpacity(
                                          duration: const Duration(milliseconds: 250),
                                          opacity: controller.playedLast == controller.playerOne? 0.5: 1,
                                          child: RepresentLetter(
                                            controller.playerOne,
                                            width: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 8,
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 8),
                                    child: Row(
                                      children: [
                                        if (orientation == Orientation.landscape)
                                        const Expanded(
                                          flex: 1,
                                          child: SizedBox.shrink(),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Center(
                                            child: Text(
                                              controller.score.textScore,
                                              style: GoogleFonts.roboto(
                                                color: Colors.blueGrey,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                              ),
                                            ),
                                          ),
                                        ),
                                        if (orientation == Orientation.landscape)
                                        Expanded(
                                          flex: 1,
                                          child: AnimatedOpacity(
                                            duration: const Duration(milliseconds: 250),
                                            opacity: controller.boardState == BoardState.playing ? 0 : 1,
                                            child: InkWell(
                                              onTap: controller.boardState == BoardState.playing? null : () => controller.resetBoard(),
                                              child: const Icon(Ionicons.refresh_outline, color: Colors.blueGrey),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(4),
                                    child: Column(
                                      children: [
                                        FittedBox(
                                          child: Text(
                                            mode == GameMode.ai? 'AI' : 'Friend',
                                            style: const TextStyle(
                                              color: Colors.blueGrey,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        AnimatedOpacity(
                                          duration: const Duration(milliseconds: 250),
                                          opacity: controller.playedLast == controller.playerTwo? 0.5: 1,
                                          child: RepresentLetter(
                                            controller.playerTwo,
                                            width: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: SizedBox.square(
                              dimension: (orientation == Orientation.portrait? Get.width / 1.1 : Get.height / 1.5),
                              child: Board(
                                board: controller.boardToOneDim,
                                dimension: (orientation == Orientation.portrait? Get.width / 1.1 : Get.height / 1.5),
                                boardState: controller.boardState,
                                lastWinWay: controller.lastWinWay,
                                newMove: (rowIndex, rowItemIndex) {
                                  controller.newMove(rowIndex, rowItemIndex);
                                },
                              ),
                            ),
                          ),
                          if (orientation == Orientation.portrait)
                          AnimatedOpacity(
                            duration: const Duration(milliseconds: 250),
                            opacity:
                                controller.boardState == BoardState.playing ? 0 : 1,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                primary: Colors.blueGrey,
                                backgroundColor: Colors.white,
                                elevation: 7,
                                shadowColor: Colors.blue.withOpacity(0.1),
                                shape: const CircleBorder(),
                              ),
                              onPressed: controller.boardState == BoardState.playing
                                  ? null
                                  : () {
                                      controller.resetBoard();
                                    },
                              child: const Icon(Ionicons.refresh_outline),
                            ),
                          ),
                        ],
                      );
                    }
                  );
                }
              );
            }),
      ),
    );
  }
}