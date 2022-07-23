import 'package:tictactoe/models/tic_tac_toe.dart';

class MyInfoResponse {
  final String roomId;
  final GameLetter letter;
  final GameLetter playedLast;
  final String player1Nickname;
  
  MyInfoResponse({
    required this.roomId,
    required this.letter,
    required this.playedLast,
    required this.player1Nickname,
  });

  static MyInfoResponse fromMap(Map data) {
    return MyInfoResponse(
      roomId: data['room_id'],
      letter: GameLetter.values.firstWhere((element) => element.name == data['player2']),
      player1Nickname: data['player1_nickname'],
      playedLast: GameLetter.values.firstWhere((element) => element.name == data['played_last']),
    );
  }
}