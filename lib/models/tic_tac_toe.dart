enum GameLetter { x, o, none }
/*
class Board {
  final int boardSize;
  late final List<List<GameLetter>> board;
  final GameLetter playerOne;
  late final GameLetter playerTwo;

  GameLetter? playedLast;

  Board({this.boardSize=3, required this.playerOne}) {
    board = List<List<GameLetter>>.generate(boardSize, (index) => List<GameLetter>.generate(boardSize, (index) => GameLetter.none));
    playerTwo = playerOne == GameLetter.x? GameLetter.o : GameLetter.x;
  }

  

  void newMove(int r, int i) {
    if (playedLast == null) {
      playedLast = playerOne;
    } else if (playedLast == playerOne) {
      return;
    }

    if (board[r][i] == GameLetter.none) {
      board[r][i] = playerOne;
      print("SET");
    } else {
      print("ERROR");
    }
  }
}
*/
class Score {
  final GameLetter player1;
  final GameLetter player2;
  Map<String, int> score = {
    'player1': 0,
    'player2': 0,
  };

  Score({
    required this.player1,
    required this.player2,
  });

  void addPoint(GameLetter player) {
    if (player1 == player) {
      score['player1'] = (score['player1']! + 1);
    } else {
      score['player2'] = (score['player2']! + 1);
    }
  }

  String get textScore {
    return '${score['player1']} - ${score['player2']}';
  }
}

enum BoardState {
  playing,
  done,
}

enum WinWay {
  upHorizWin,
  midHorizWin,
  downHorizWin,
  rightVerticalWin,
  midVerticalWin,
  leftVerticalWin,
  clockWin,
  clockwiseWin,
  withdraw,
}