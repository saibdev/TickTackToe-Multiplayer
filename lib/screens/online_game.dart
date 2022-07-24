import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:tictactoe/controllers/online_game_controller.dart';
import 'package:tictactoe/controllers/settings_controller.dart';
import 'package:tictactoe/models/server.dart';
import 'package:tictactoe/models/tic_tac_toe.dart';
import 'package:tictactoe/widgets/board.dart';
import 'package:tictactoe/widgets/represent_letter.dart';

class OnlineGame extends StatefulWidget {
  final RoomProvider roomServerProvider;
  final MyInfoResponse userInfo;

  const OnlineGame(
      {Key? key, required this.roomServerProvider, required this.userInfo})
      : super(key: key);

  @override
  State<OnlineGame> createState() => _OnlineGameState();
}

class _OnlineGameState extends State<OnlineGame> {
  late String roomId = widget.userInfo.roomId;
  late RoomProvider roomServerProvider = widget.roomServerProvider;
  late MyInfoResponse userInfo = widget.userInfo;
  late GameLetter playerLetter = userInfo.letter;
  late String friendNickname = userInfo.player1Nickname;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GetBuilder<OnlineGameController>(
            init: OnlineGameController(
                roomId: roomId,
                userInfo: userInfo,
                roomServerProvider: roomServerProvider),
            builder: (controller) {
              return GetBuilder<SettingsController>(
                  init: SettingsController(),
                  builder: (settingsController) {
                    return OrientationBuilder(builder: (context, orientation) {
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
                                          duration:
                                              const Duration(milliseconds: 250),
                                          opacity: controller.playedLast ==
                                                  controller.playerOne
                                              ? 0.5
                                              : 1,
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
                                        if (orientation ==
                                            Orientation.landscape)
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
                                        if (orientation ==
                                            Orientation.landscape)
                                          Expanded(
                                            flex: 1,
                                            child: AnimatedOpacity(
                                              duration: const Duration(
                                                  milliseconds: 250),
                                              opacity: controller.boardState ==
                                                      BoardState.playing
                                                  ? 0
                                                  : 1,
                                              child: InkWell(
                                                onTap: controller.boardState ==
                                                        BoardState.playing
                                                    ? null
                                                    : () =>
                                                        controller.resetBoard(),
                                                child: const Icon(
                                                    Ionicons.refresh_outline,
                                                    color: Colors.blueGrey),
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
                                            friendNickname,
                                            style: const TextStyle(
                                              color: Colors.blueGrey,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        AnimatedOpacity(
                                          duration:
                                              const Duration(milliseconds: 250),
                                          opacity: controller.playedLast ==
                                                  controller.playerTwo
                                              ? 0.5
                                              : 1,
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
                              dimension: (orientation == Orientation.portrait
                                  ? Get.width / 1.1
                                  : Get.height / 1.5),
                              child: Board(
                                board: controller.boardToOneDim,
                                dimension: (orientation == Orientation.portrait
                                    ? Get.width / 1.1
                                    : Get.height / 1.5),
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
                            opacity: controller.boardState == BoardState.playing
                                ? 0
                                : 1,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                primary: Colors.blueGrey,
                                backgroundColor: Colors.white,
                                elevation: 7,
                                shadowColor: Colors.blue.withOpacity(0.1),
                                shape: const CircleBorder(),
                              ),
                              onPressed:
                                  controller.boardState == BoardState.playing
                                      ? null
                                      : () {
                                          controller.resetBoard();
                                        },
                              child: const Icon(Ionicons.refresh_outline),
                            ),
                          ),
                        ],
                      );
                    });
                  });
            }),
      ),
    );
  }
}

class WinLine extends StatefulWidget {
  final double to;
  final WinWay winWay;

  const WinLine({
    Key? key,
    required this.to,
    required this.winWay,
  }) : super(key: key);

  @override
  State<WinLine> createState() => _WinLineState();
}

class _WinLineState extends State<WinLine> with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;
  late final Tween<double> _tween = Tween(begin: 0, end: widget.to);

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    animation = _tween.animate(controller)
      ..addListener(() {
        setState(() {
          // The state that has changed here is the animation object’s value.
        });
      });
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.winWay == WinWay.clockWin) {
      return CustomPaint(
        painter: MyPainter(
          p1: const Offset(20, 20),
          p2: Offset(animation.value - 5, animation.value),
        ),
      );
    } else if (widget.winWay == WinWay.clockwiseWin) {
      debugPrint(widget.to.toString());
      return CustomPaint(
        painter: MyPainter(
          p1: Offset(widget.to - 5, 20), // EdIT
          p2: Offset(
              (widget.to + 20) - animation.value, animation.value), // EdIT
        ),
      );
    } else if (widget.winWay == WinWay.upHorizWin) {
      return CustomPaint(
        painter: MyPainter(
          p1: Offset(16, (widget.to / 3) - (widget.to / 3) / 3),
          p2: Offset(animation.value, (widget.to / 3) - (widget.to / 3) / 3),
        ),
      );
    } else if (widget.winWay == WinWay.midHorizWin) {
      return CustomPaint(
        painter: MyPainter(
          p1: Offset(
              16, (widget.to / 2) + 12.5), // 12.5 because of the letters.
          p2: Offset(animation.value,
              (widget.to / 2) + 12.5), // 12.5 because of the letters.
        ),
      );
    } else if (widget.winWay == WinWay.downHorizWin) {
      return CustomPaint(
        painter: MyPainter(
          p1: Offset(16, (widget.to / 3) * 3 - (widget.to / 3) / 3 - 12.5),
          p2: Offset(animation.value,
              (widget.to / 3) * 3 - (widget.to / 3) / 3 - 12.5),
        ),
      );
    } else if (widget.winWay == WinWay.leftVerticalWin) {
      return CustomPaint(
        painter: MyPainter(
          p1: Offset((widget.to / 3) - (widget.to / 3) / 3 - 4.5, 16),
          p2: Offset(
              (widget.to / 3) - (widget.to / 3) / 3 - 4.5, animation.value),
        ),
      );
    } else if (widget.winWay == WinWay.midVerticalWin) {
      return CustomPaint(
        painter: MyPainter(
          p1: Offset((widget.to / 2) + 5.5, 16),
          p2: Offset((widget.to / 2) + 5.5, animation.value),
        ),
      );
    } else if (widget.winWay == WinWay.rightVerticalWin) {
      return CustomPaint(
        painter: MyPainter(
          p1: Offset((widget.to) - (widget.to / 3) / 2 - 2.5, 16),
          p2: Offset((widget.to) - (widget.to / 3) / 2 - 2.5, animation.value),
        ),
      );
    }
    return CustomPaint(
      painter: MyPainter(
        p1: const Offset(0, 0),
        p2: const Offset(50, 50),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

/*
class PlayLetter extends StatelessWidget {
  final GameLetter letter;
  const PlayLetter(this.letter, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 80,
          child: FittedBox(
            child: Text(
              letter.name == 'x' ? '×' : letter.name,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w900,
                fontSize: 2000,
                height: 0.9,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
*/

class PlayLetter extends StatelessWidget {
  final GameLetter letter;
  final Function() onSet;
  const PlayLetter({Key? key, required this.letter, required this.onSet})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: letter == GameLetter.none ? onSet : null,
      child: Container(
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 14),
              child: SizedBox(
                width: (Get.width / 3) - (16 * 2) - 20,
                height: (Get.width / 3) - (16 * 2) - 20,
                child: AnimatedOpacity(
                  duration: letter == GameLetter.none
                      ? Duration.zero
                      : const Duration(milliseconds: 300),
                  opacity: letter == GameLetter.none ? 0 : 1,
                  child: RepresentLetter(
                    letter,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  final Offset p1;
  final Offset p2;

  MyPainter({required this.p1, required this.p2});

  @override
  void paint(Canvas canvas, Size size) {
    /*const p1 = Offset(50, 50);
    const p2 = Offset(250, 150);*/
    final paint = Paint()
      ..color = Colors.blueGrey
      ..strokeWidth = 2.5;
    canvas.drawLine(p1, p2, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
