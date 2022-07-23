import json
from simple_websocket_server import WebSocketServer, WebSocket
from random import randint

#default_board = [
#    ['none', 'none', 'none'],
#    ['none', 'none', 'none'],
#    ['none', 'none', 'none'],
#]

rooms = {

}

def genBoard(size):
    return [ ['none' for x in range(size)] for x in range(size) ]

def getMovReqInfo(sock):
    id = None
    player = None
    anotherPlayerSocket = None

    for key, val in reversed(rooms.items()):
        if val['player1_socket'] == sock or val['player2_socket'] == sock:
            id = key

            if val['player1_socket'] == sock:
                player = val['player1']
                anotherPlayerSocket = val['player2_socket']
            else:
                player = val['player2']
                anotherPlayerSocket = val['player1_socket']
                
            break

    print(player)
    #print({'room_id': id, 'player': player, 'another_player_socket': anotherPlayerSocket})
    return {'room_id': id, 'player': player, 'another_player_socket': anotherPlayerSocket}

class SimpleEcho(WebSocket):
    def handle(self):
        data = json.loads(self.data)
        event = data['type']
        data = data['data']

        if event == 'get_room_id':
            randID = randint(111111, 999999)
            player1_nickname = data['nickname']

            if randID not in rooms.keys():
                if data['player1'] == 'x':
                    player1 = 'x'
                    player2 = 'o'
                else:
                    player1 = 'o'
                    player2 = 'x'
                
                
                rooms[str(randID)] = {
                    'player1': player1,
                    'player2': player2,
                    'player1_nickname': player1_nickname,
                    'player2_nickname': '',
                    'player1_socket': self,
                    'player2_socket': None,
                    'score': {0 : 0},
                    'full': False,
                    'board': genBoard(3),
                    'played_last': 'x' if randint(0, 2) == 0 else 'o'
                }

                self.send_message(json.dumps({'event': 'set_room_id', 'data': {'room_id': randID}}))
                #print(rooms)
        elif event == 'join_room':
            id = str(data['id'])
            print("Join:", id)
            nickname = data['nickname']

            if id in rooms.keys() and rooms[id]['full'] != True:
                rooms[id]['full'] = True
                rooms[id]['player2_socket'] = self
                rooms[id]['player2_nickname'] = nickname
                self.send_message(json.dumps({
                    'event': 'join_room_status',
                    'data': {
                        'status': True,
                        'room_id': id,
                        'player1_nickname': rooms[id]['player1_nickname'],
                        'player2': rooms[id]['player2'],
                        'played_last': rooms[id]['played_last'],
                    },
                }))
                rooms[id]['player1_socket'].send_message(json.dumps({
                    'event': 'room_joined_status',
                    'data': {
                        'room_id': id,
                        'player1_nickname': rooms[id]['player2_nickname'],
                        'player2': rooms[id]['player1'],
                        'played_last': rooms[id]['played_last'],
                    },
                }))
            else:
                self.send_message(json.dumps({'event': 'join_room_status', 'data': {'status': False}}))
        elif event == 'new_move':
            roomId = getMovReqInfo(self)['room_id']
            player = getMovReqInfo(self)['player']
            anotherPlayerSocket = getMovReqInfo(self)['another_player_socket']

            r = data['r']
            j = data['j']

            if rooms[roomId]['board'][r][j] == 'none' and rooms[roomId]['played_last'] != player:
                rooms[roomId]['board'][r][j] = player
                rooms[roomId]['played_last'] = player

                rooms[roomId]['player1_socket'].send_message(json.dumps({
                    'event': 'set_new_move',
                    'data': {
                        'board': rooms[roomId]['board'],
                        'r': r,
                        'j': j,
                    }
                }))
                rooms[roomId]['player2_socket'].send_message(json.dumps({
                    'event': 'set_new_move',
                    'data': {
                        'board': rooms[roomId]['board'],
                        'r': r,
                        'j': j,
                    }
                }))
        elif event == 'reset_board':
            roomId = getMovReqInfo(self)['room_id']
            player = getMovReqInfo(self)['player']
            anotherPlayerSocket = getMovReqInfo(self)['another_player_socket']

            rooms[roomId]['played_last'] = 'x' if randint(0, 2) == 0 else 'o'
            rooms[roomId]['board'] = genBoard(3)

            rooms[roomId]['player1_socket'].send_message(json.dumps({
                'event': 'reset_board',
                'data': {
                    'played_last': rooms[roomId]['played_last'],
                }
            }))
            rooms[roomId]['player2_socket'].send_message(json.dumps({
                'event': 'reset_board',
                'data': {
                    'played_last': rooms[roomId]['played_last'],
                }
            }))

    def connected(self):
        print(self.address, 'connected')

    def handle_close(self):
        print(self.address, 'closed')


server = WebSocketServer('0.0.0.0', 4897, SimpleEcho)
server.serve_forever()