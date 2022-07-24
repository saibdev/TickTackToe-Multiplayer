import 'dart:convert';

import 'package:get/get.dart';
import 'package:tictactoe/consts.dart';
import 'package:tictactoe/helpers/debug_print.dart';
import 'package:tictactoe/models/server.dart';

import 'package:tictactoe/models/tic_tac_toe.dart';

class RoomProvider extends GetConnect {
  GetSocket ws = GetSocket(serverUrl, allowSelfSigned: false);
  bool socketConnected = false;
  String? _genRoomId;
  Map _joinRoom = {};
  bool _joinRoomInit = false;

  Function(List<List<GameLetter>>, int r, int j)? setNewMove;
  Function(GameLetter playedLast)? setResetBoard;

  RoomProvider({Function(MyInfoResponse)? onUserJoin, this.setNewMove, this.setResetBoard}) {
    ws.connect();

    ws.onOpen(() {
      socketConnected = true;
      ws.onMessage((val) {
        val = json.decode(val);
        String type = val['event'];
        Map data = val['data'];

        if (type == 'set_room_id') {
          _genRoomId = data['room_id'].toString();
        } else if (type == 'join_room_status') {
          _joinRoom = data;
          _joinRoomInit = true;
        } else if (type == 'room_joined_status') {
          debugPrint(data);
          onUserJoin!(MyInfoResponse.fromMap(data));
        } else if (type == 'set_new_move') {
          if (setNewMove != null) {
            setNewMove!(List<List<GameLetter>>.from(data['board'].map((i) {
              return i.map<GameLetter>((j) => GameLetter.values.firstWhere((l) => l.name == j)).toList();
            }).toList()), data['r'], data['j']);
          } else {
            debugPrint("IT IS STILL NULL !");
          }
        } else if (type == 'reset_board') {
          if (setResetBoard != null) {
            setResetBoard!(GameLetter.values.firstWhere((element) => element.name == data['played_last']));
          }
        } else {
          debugPrint(type); // Continue from here
          debugPrint(data);
        }

        //print(val);
      });
    });
  }

  Future<String> getRoomId(GameLetter player1, String nickname) async {
    while (socketConnected == false) {
      await Future.delayed(const Duration(milliseconds: 500));
    }
    ws.emit('get_room_id', {'player1': player1.name, 'nickname': nickname});

    while(_genRoomId == null) {
      await Future.delayed(const Duration(milliseconds: 500));
    }

    return _genRoomId!;
  }

  Future<MyInfoResponse> joinRoom(String id, String nickname) async {
    while (socketConnected == false) {
      await Future.delayed(const Duration(milliseconds: 500));
    }

    ws.emit('join_room', {'id': id, 'nickname': nickname});

    while(_joinRoomInit == false) {
      await Future.delayed(const Duration(milliseconds: 500));
    }
    _joinRoomInit = false;

    if (_joinRoom['status'] == false) {
      throw Exception('Invalid room ID');
    }
    return MyInfoResponse.fromMap(_joinRoom);
  }

  Future newMove(r, j) async {
    ws.emit('new_move', {'r': r, 'j': j});
  }

  Future resetBoard() async {
    ws.emit('reset_board', {});
  }
}

class OnlineGameController extends GetxController {
  final String roomId;
  late final RoomProvider roomServerProvider;
  final MyInfoResponse userInfo;
  late List<List<GameLetter>> board;
  late final GameLetter playerOne = userInfo.letter;
  late final GameLetter playerTwo;
  late GameLetter playedLast = userInfo.playedLast;
  BoardState boardState = BoardState.playing;
  late final Score score = Score(player1: playerOne, player2: playerTwo);
  WinWay lastWinWay = WinWay.withdraw;

  OnlineGameController({required this.roomId, required this.userInfo, required this.roomServerProvider});

  @override
  void onInit() {
    super.onInit();
    //roomServerProvider = RoomProvider();
    roomServerProvider.setNewMove = ((b, r, j) {
      board = b;
      bool isWinner = _checkWinner(r, j);
      playedLast = playedLast == playerOne? playerTwo : playerOne;

      if (isWinner) {
        score.addPoint(playedLast);
        boardState = BoardState.done;
      } else if (isBoardFull()) {
        boardState = BoardState.done;
      }
      update();
    });

    roomServerProvider.setResetBoard = ((pLast) {
      board = _genBoard(3);
      boardState = BoardState.playing;
      playedLast = pLast;
      update();
    });

    debugPrint("initALIZ");
    board = _genBoard(3);
    playerTwo = playerOne == GameLetter.x? GameLetter.o : GameLetter.x;
    //playedLast = GameLetter.values[math.Random().nextInt(2)];
  }

  List<List<GameLetter>> _genBoard(int size) {
    return List<List<GameLetter>>.generate(size, (index) => List<GameLetter>.generate(size, (index) => GameLetter.none));
  }

  void newMove(int r, int j) {
    if (playedLast == playerOne || boardState == BoardState.done) {
      return;
    }

    if (board[r][j] == GameLetter.none) {
      //print(boardState);
      board[r][j] = playerOne;
      //playedLast = playerOne;
      roomServerProvider.newMove(r, j);
      //print("SET");
    } else {
      //print("ERROR");
    }
    /*bool isWinner = _checkWinner(r, j);
    print("ME $isWinner");
    if (isWinner) {
      score.addPoint(playerOne);
      boardState = BoardState.done;
      update();
      return;
    } else if (isBoardFull()) {
      boardState = BoardState.done;
      update();
      return;
    }*/
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
    roomServerProvider.resetBoard();
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