
import 'package:get/get.dart';
import 'package:tictactoe/helpers/debug_print.dart';
import 'dart:math' as math;

import 'package:tictactoe/models/tic_tac_toe.dart';

enum GameMode {
  ai,
  offlineFriend,
}

class GameController extends GetxController {
  final GameMode mode;
  final bool stupidAi;
  late List<List<GameLetter>> board;
  final GameLetter playerOne;
  late final GameLetter playerTwo;
  GameLetter? playedLast;
  BoardState boardState = BoardState.playing;
  late final Score score = Score(player1: playerOne, player2: playerTwo);
  WinWay lastWinWay = WinWay.withdraw;
  TacAI aiModule = TacAI();

  GameController({required this.mode, required this.playerOne, this.stupidAi=false});

  @override
  void onInit() {
    super.onInit();
    debugPrint("initALIZ");
    board = _genBoard(3);
    playerTwo = playerOne == GameLetter.x? GameLetter.o : GameLetter.x;
    playedLast = GameLetter.values[math.Random().nextInt(2)];
    if (mode == GameMode.ai && playedLast == playerOne) {
      botMove();
    }
  }

  List<List<GameLetter>> _genBoard(int size) {
    return List<List<GameLetter>>.generate(size, (index) => List<GameLetter>.generate(size, (index) => GameLetter.none));
  }

  void newMove(int r, int i) {
    GameLetter nextPlayer = playedLast == playerOne? playerTwo:playerOne; 

    if (playedLast == null) {
      playedLast = playerOne;
    } else if (mode == GameMode.ai && playedLast == playerOne || boardState == BoardState.done) {
      return;
    }

    if (board[r][i] == GameLetter.none) {
      //print(boardState);
      board[r][i] = nextPlayer;
      playedLast = nextPlayer;
      //print("SET");
    } else {
      //print("ERROR");
    }
    bool isWinner = _checkWinner(r, i);
    debugPrint("ME $isWinner");
    if (isWinner) {
      score.addPoint(playedLast!);
      boardState = BoardState.done;
      update();
      return;
    } else if (isBoardFull()) {
      boardState = BoardState.done;
      update();
      return;
    }
    update();
    if (mode == GameMode.ai) {
      Future.delayed(const Duration(milliseconds: 300)).then((value) {
        debugPrint("bot turn");
        botMove();
      });
    }
  }

  botMove() {
    int i = 0;
    int j = 0;

    if (stupidAi == true) {
      List<List<int>> temp = [];

      for (var i = 0; i < board.length; i++) {
        for (var j = 0; j < board[i].length; j++) {
          if (board[i][j] == GameLetter.none) {
            temp.add([i, j]);
          }
        }
      }

      math.Random rnd = math.Random();
      int r = rnd.nextInt(temp.length);
      i = temp[r][0];
      j = temp[r][1];

      board[i][j] = playerTwo;
      playedLast = playerTwo;
      update();
    } else {
      int? bestMove = aiModule.play(boardToOneDim, playerTwo);
      i = bestMove! ~/ 3;
      j = bestMove - i * 3;

      board[i][j] = playerTwo;
      playedLast = playerTwo;
      update();
    }


    bool isWinner = _checkWinner(i, j);
    debugPrint("BOT $isWinner");
    if (isWinner) {
      score.addPoint(playerTwo);
      boardState = BoardState.done;
      update();
      return;
    } else if (isBoardFull()) {
      boardState = BoardState.done;
      update();
    }
  }

  bool _checkWinner(int x, int y) {

    var col = 0, row = 0, diag = 0, rdiag = 0;
    var n = board.length - 1;
    var player = board[x][y];

    for (int i = 0; i < board.length; i++) {
      if (board[x][i] == player) col++;
      if (board[i][y] == player) row++;
      if (board[i][i] == player) diag++;
      if (board[i][n - i] == player) rdiag++;
    }
    if (row == n + 1 || col == n + 1 || diag == n + 1 || rdiag == n + 1) {
      if (board[0][0] == player && board[0][1] == player && board[0][2] == player) {
        lastWinWay = WinWay.upHorizWin;
      } else if (board[1][0] == player && board[1][1] == player && board[1][2] == player) {
        lastWinWay = WinWay.midHorizWin;
      } else if (board[2][0] == player && board[2][1] == player && board[2][2] == player) {
        lastWinWay = WinWay.downHorizWin;
      } else if (board[0][0] == player && board[1][0] == player && board[2][0] == player) {
        lastWinWay = WinWay.leftVerticalWin;
      } else if (board[0][1] == player && board[1][1] == player && board[2][1] == player) {
        lastWinWay = WinWay.midVerticalWin;
      } else if (board[0][2] == player && board[1][2] == player && board[2][2] == player) {
        lastWinWay = WinWay.rightVerticalWin;
      } else if (board[0][0] == player && board[1][1] == player && board[2][2] == player) {
        lastWinWay = WinWay.clockWin;
      } else if (board[0][2] == player && board[1][1] == player && board[2][0] == player) {
        lastWinWay = WinWay.clockwiseWin;
      } else {
        lastWinWay = WinWay.withdraw;
      }
      return true;
    }
    lastWinWay = WinWay.withdraw;
    return false;
  }

  bool isBoardFull() {
    int count = 0;
    for (var i = 0; i < board.length; i++) {
      for (var j = 0; j < board[i].length; j++) {
        if (board[i][j] == GameLetter.none) count = count + 1;
      }
    }
    if (count == 0) return true;

    return false;
  }

  void resetBoard() {
    board = _genBoard(3);
    boardState = BoardState.playing;
    playedLast = GameLetter.values[math.Random().nextInt(2)]; 
    if (mode == GameMode.ai && playedLast == playerOne) {
      botMove();
    }
    update();
    //_player$.add(_start);
    //_boardState$.add(MapEntry(BoardState.Play, ""));
    /*if (_player$.value == "O") {
      _player$.add("X");
    }*/
  }

  List<GameLetter> get boardToOneDim {
    List<GameLetter> oneDimBoard = [];

    for (List<GameLetter> i in board) {
      for (GameLetter j in i) {
        oneDimBoard.add(j);
      }
    }
    
    return oneDimBoard;
  }
}
// F H

class TacAI {
  // evaluation condition values
  static const int human = 1;
  static const int aiPlayer = -1;
  static const int noWinnersYet = 0;
  static const int draw = 2;
 
  static const int emptySpace = 0;
 
  // arbitrary values for winning, draw and losing conditions
  static const int winScore = 100;
  static const int drawScore = 0;
  static const int loseScore = -100;
 
  static const winConditionsList = [
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8],
    [0, 3, 6],
    [1, 4, 7],
    [2, 5, 8],
    [0, 4, 8],
    [2, 4, 6],
  ];
 
  /// Returns the optimal move based on the state of the board.
  int? play(List<GameLetter> board, GameLetter currentPlayer) {
    return _getBestMove(board, currentPlayer).move;
  }
 
  /// Returns the best possible score for a certain board condition.
  /// This method implements the stopping condition.
  int? _getBestScore(List<GameLetter> board, GameLetter currentPlayer) {
    dynamic evaluation = TacUtility.evaluateBoard(board);
 
    if (evaluation == currentPlayer) return winScore;
 
    if (evaluation == draw) return drawScore;
 
    if (evaluation == TacUtility.flipPlayer(currentPlayer)) {
      return loseScore;
    }
 
    return _getBestMove(board, currentPlayer).score;
  }
 
  /// This is where the actual Minimax algorithm is implemented
  Move _getBestMove(List<GameLetter> board, GameLetter currentPlayer) {
    // try all possible moves
    // will contain our next best score
    Move bestMove = Move(score: -10000, move: -1);
 
    for (int currentMove = 0; currentMove < board.length; currentMove++) {
      if (!TacUtility.isMoveLegal(board, currentMove)) continue;
 
      // we need a copy of the initial board so we don't pollute our real board
      List<GameLetter> newBoard = List.from(board);
 
      // make the move
      newBoard[currentMove] = currentPlayer;
 
      // solve for the next player
      // what is a good score for the opposite player is opposite of good score for us
      int nextScore =
          -_getBestScore(newBoard, TacUtility.flipPlayer(currentPlayer))!;
 
      // check if the current move is better than our best found move
      if (nextScore > bestMove.score!) {
        bestMove.score = nextScore;
        bestMove.move = currentMove;
      }
    }
 
    return bestMove;
  }
}
 
class Move {
  int? score;
  int? move;
 
  Move({this.score, this.move});
}

class TacUtility {
  //region utility
  static bool isBoardFull(List<GameLetter> board) {
    for (var val in board) {
      if (val == GameLetter.none) return false;
    }
 
    return true;
  }
 
  static bool isMoveLegal(List<GameLetter> board, int move) {
    if (move < 0 || move >= board.length || board[move] != GameLetter.none) {
      return false;
    }
 
    return true;
  }
 
  /// Returns the current state of the board [winning player, draw or no winners yet]
  static dynamic evaluateBoard(List<GameLetter> board) {
    for (var list in TacAI.winConditionsList) {
      if (board[list[0]] !=
              GameLetter.none && // if a player has played here AND
          board[list[0]] ==
              board[list[1]] && // if all three positions are of the same player
          board[list[0]] == board[list[2]]) {
        return board[list[0]];
      }
    }
 
    if (isBoardFull(board)) {
      return TacAI.draw;
    }
 
    return TacAI.noWinnersYet;
  }
 
  /// Returns the opposite player from the current one.
  static GameLetter flipPlayer(GameLetter currentPlayer) {
    if (currentPlayer == GameLetter.x) {
      return GameLetter.o;
    } else {
      return GameLetter.x;
    }
  }
}