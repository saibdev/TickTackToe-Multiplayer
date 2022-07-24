import 'package:flutter/material.dart';
import 'package:tictactoe/models/tic_tac_toe.dart';
import 'package:tictactoe/widgets/represent_letter.dart';

class Board extends StatefulWidget {
  final List<GameLetter> board;
  final double dimension;
  final BoardState boardState;
  final WinWay lastWinWay;
  final Function(int j, int i) newMove;

  const Board({Key? key, required this.board, required this.dimension, required this.boardState, required this.lastWinWay, required this.newMove}) : super(key: key);

  @override
  State<Board> createState() => _BoardState();
}

class _BoardState extends State<Board> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: GridView.builder(
              itemCount: 9,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  decoration: BoxDecoration(
                    border: Border(
                      left: index % 3 == 0 || index % 3 == 2? BorderSide.none : BorderSide(
                        color: Colors.blueGrey.shade200,
                      ),
                      right: index % 3 == 2 || index % 3 == 0? BorderSide.none : BorderSide(
                        color: Colors.blueGrey.shade200,
                      ),
                      top: index < 3 || index > 5? BorderSide.none : BorderSide(
                        color: Colors.blueGrey.shade200,
                      ),
                      bottom: index > 5 || index < 3? BorderSide.none : BorderSide(
                        color: Colors.blueGrey.shade200,
                      ),
                    ),
                  ),
                  child: Center(
                    child: PlayLetter(
                      letter: widget.board[index],
                      onSet: () {
                        setState(() {
                          widget.newMove(index ~/ 3, index - (index ~/ 3) * 3);
                        });
                      },
                    ),
                  ),
                );
              }),
          ),
          if (widget.boardState == BoardState.done && widget.lastWinWay != WinWay.withdraw)
          OrientationBuilder(builder: (context, orientation) {
            double to = (widget.dimension) - (20);
            return WinLine(
              to: to,
              winWay: widget.lastWinWay,
            );
          }),
        ],
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
  late Tween<double> _tween = Tween(begin: 0, end: widget.to);
  
  double lastTo = 0;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
    animation = _tween.animate(controller)
      ..addListener(() {
        setState(() {});
      });
    controller.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    setState(() {
      lastTo = widget.to;
    });
  }

  @override
  Widget build(BuildContext context) {
    // There is some bugs for now Pulls are accepted for any fix that works on Portrait and Landscape mode.
    if (lastTo != widget.to) {
      lastTo = widget.to;
      _tween = Tween(begin: 0, end: lastTo);
      animation = _tween.animate(controller)
        ..addListener(() {
          setState(() {});
        });
      controller.reset();
      controller.forward();
    }

    if (widget.winWay == WinWay.clockWin) {
      return CustomPaint(
        painter: MyPainter(
          p1: const Offset(20, 20),
          p2: Offset(animation.value, animation.value),
        ),
      );
    } else if (widget.winWay == WinWay.clockwiseWin) {
      return CustomPaint(
        painter: MyPainter(
          p1: Offset(widget.to, 20), // EdIT
          p2: Offset((widget.to + 20) - animation.value, animation.value), // EdIT
        ),
      );
    } else if (widget.winWay == WinWay.upHorizWin) {
      return CustomPaint(
        painter: MyPainter(
          p1: Offset(16, (widget.to/3) - (widget.to/3)/3),
          p2: Offset(animation.value, (widget.to/3) - (widget.to/3)/3),
        ),
      );
    } else if (widget.winWay == WinWay.midHorizWin) {
      return CustomPaint(
        painter: MyPainter(
          p1: Offset(16, (widget.to/2) + 12.5), // 12.5 because of the letters.
          p2: Offset(animation.value, (widget.to/2) + 12.5), // 12.5 because of the letters.
        ),
      );
    } else if (widget.winWay == WinWay.downHorizWin) {
      return CustomPaint(
        painter: MyPainter(
          p1: Offset(16, (widget.to/3)*3 - (widget.to/3)/2.25),
          p2: Offset(animation.value, (widget.to/3)*3 - (widget.to/3)/2.25),
        ),
      );
    } else if (widget.winWay == WinWay.leftVerticalWin) {
      return CustomPaint(
        painter: MyPainter(
          p1: Offset((widget.to/3) - (widget.to/3)/3.5, 16),
          p2: Offset((widget.to/3) - (widget.to/3)/3.5, animation.value),
        ),
      );
    } else if (widget.winWay == WinWay.midVerticalWin) {
      return CustomPaint(
        painter: MyPainter(
          p1: Offset((widget.to/2) + 8, 16),
          p2: Offset((widget.to/2) + 8, animation.value),
        ),
      );
    } else if (widget.winWay == WinWay.rightVerticalWin) {
      return CustomPaint(
        painter: MyPainter(
          p1: Offset((widget.to) - (widget.to/3)/2 + 2, 16),
          p2: Offset((widget.to) - (widget.to/3)/2 + 2, animation.value),
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
              child: AnimatedOpacity(
                duration: letter == GameLetter.none
                    ? Duration.zero
                    : const Duration(milliseconds: 300),
                opacity: letter == GameLetter.none ? 0 : 1,
                child: RepresentLetter(letter,),
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
