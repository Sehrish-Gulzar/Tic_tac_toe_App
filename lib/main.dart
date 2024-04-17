import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(TicTacToeApp());
}

class TicTacToeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: TicTacToeScreen(),
    );
  }
}

class TicTacToeScreen extends StatefulWidget {
  @override
  _TicTacToeScreenState createState() => _TicTacToeScreenState();
}

class _TicTacToeScreenState extends State<TicTacToeScreen> {
  late List<List<String>> _board;
  late String _currentPlayer;
  late String _winner;
  late AssetsAudioPlayer _audioPlayer;
  bool _isMusicOn = true;

  @override
  void initState() {
    super.initState();
    _initializeBoard();
    _initializeAudioPlayer();
  }

  void _initializeBoard() {
    _board = List<List<String>>.generate(3, (_) => List<String>.filled(3, ''));
    _currentPlayer = 'X';
    _winner = '';
  }

  void _initializeAudioPlayer() {
    _audioPlayer = AssetsAudioPlayer();
    _audioPlayer.open(
      Audio('assets/audio/Beautiful-Piano(chosic.com).mp3'),
      loopMode: LoopMode.single,
    );
    _audioPlayer.play();
  }

  void _playMove(int row, int col) {
    if (_board[row][col] == '' && _winner == '') {
      setState(() {
        _board[row][col] = _currentPlayer;
        _checkWinner(row, col);
        if (_winner == '') {
          _togglePlayer();
        }
      });
    }
  }

  void _checkWinner(int row, int col) {
    // Check row
    if (_board[row][0] == _board[row][1] &&
        _board[row][1] == _board[row][2] &&
        _board[row][0] != '') {
      _winner = _board[row][0];
      _showWinnerDialog(_winner);
      return;
    }

    // Check column
    if (_board[0][col] == _board[1][col] &&
        _board[1][col] == _board[2][col] &&
        _board[0][col] != '') {
      _winner = _board[0][col];
      _showWinnerDialog(_winner);
      return;
    }

    // Check diagonal
    if (_board[0][0] == _board[1][1] &&
        _board[1][1] == _board[2][2] &&
        _board[0][0] != '') {
      _winner = _board[0][0];
      _showWinnerDialog(_winner);
      return;
    }
    if (_board[0][2] == _board[1][1] &&
        _board[1][1] == _board[2][0] &&
        _board[0][2] != '') {
      _winner = _board[0][2];
      _showWinnerDialog(_winner);
      return;
    }

    // Check for a draw
    bool isBoardFull = true;
    for (var i = 0; i < 3; i++) {
      for (var j = 0; j < 3; j++) {
        if (_board[i][j] == '') {
          isBoardFull = false;
          break;
        }
      }
    }
    if (isBoardFull) {
      _winner = 'Draw';
      _showWinnerDialog(_winner);
    }
  }

  void _togglePlayer() {
    _currentPlayer = _currentPlayer == 'X' ? 'O' : 'X';
  }

  void _toggleMusic() {
    setState(() {
      _isMusicOn = !_isMusicOn;
      if (_isMusicOn) {
        _audioPlayer.play();
      } else {
        _audioPlayer.pause();
      }
    });
  }

  void _resetGame() {
    setState(() {
      _initializeBoard();
      _audioPlayer.stop();
      if (_isMusicOn) {
        _audioPlayer.play();
      }
    });
  }

  void _showWinnerDialog(String winner) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Winner'),
          content: RichText(
            text: TextSpan(
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
              children: [
                TextSpan(
                  text: 'Congratulations, ',
                ),
                TextSpan(
                  text: '$winner',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: '! You won the game.',
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _resetGame();
              },
              child: Text(
                'Play Again',
                style: TextStyle(color: Color(0xffff3c84a3)),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCell(int row, int col) {
    bool isWinnerCell = false;
    if (_winner != '') {
      if ((_board[row][0] == _board[row][1] &&
              _board[row][1] == _board[row][2] &&
              _board[row][0] != '') || // Check row
          (_board[0][col] == _board[1][col] &&
              _board[1][col] == _board[2][col] &&
              _board[0][col] != '') || // Check column
          (_board[0][0] == _board[1][1] &&
              _board[1][1] == _board[2][2] &&
              _board[0][0] != '') || // Check diagonal 1
          (_board[0][2] == _board[1][1] &&
              _board[1][1] == _board[2][0] &&
              _board[0][2] != '')) {
        // Check diagonal 2
        if ((_board[row][col] == _winner) && (_board[row][col] != '')) {
          isWinnerCell = true;
        }
      }
    }

    return GestureDetector(
      onTap: () => _playMove(row, col),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
        ),
        child: Center(
          child: Text(
            _board[row][col],
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: _board[row][col] == 'X' ? Color(0Xffff5e2fd6) : Colors.red,
            ),
          ),
        ),
        foregroundDecoration: isWinnerCell && _winner == _board[row][col]
            ? BoxDecoration(
                border: Border.all(
                  color: Colors.green,
                  width: 5,
                ),
              )
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(
        //   actions: [
        //     IconButton(
        //       onPressed: _toggleMusic,
        //       icon: Icon(
        //         _isMusicOn ? Icons.music_note : Icons.music_off,
        //       ),
        //     ),
        //   ],
        // ),
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Image(
              image: new AssetImage(
                  "assets/images/stylish-blue-abstract-background-with-text-space.jpg"),
              fit: BoxFit.cover,
              color: Colors.black12,
              colorBlendMode: BlendMode.darken,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.sizeOf(context).width * 0.05,
                vertical: MediaQuery.sizeOf(context).height * 0.1,
              ),
              child: Align(
                alignment: Alignment.topLeft,
                child: Container(
                  child: Image(
                      image: new AssetImage(
                          "assets/images/logo-no-background.png"),
                      filterQuality: FilterQuality.high),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: _toggleMusic,
                icon: Icon(
                  _isMusicOn ? Icons.music_note : Icons.music_off,
                  color: Color(0xffff3c84a3),
                ),
              ),
            ),
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height / 5,
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          border:
                              Border.all(color: Color(0xffff3c84a3), width: 4)),
                      width: MediaQuery.of(context).size.width / 1.1,
                      child: GridView.builder(
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                        ),
                        itemBuilder: (context, index) {
                          final row = index ~/ 3;
                          final col = index % 3;
                          return _buildCell(col, row);
                        },
                        itemCount: 9,
                      ),
                    ),
                  ),
                  Container(
                    height: 60,
                    width: 270,
                    margin: EdgeInsets.all(30),
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(
                          width: 2.5,
                          color: Color(0xffff3c84a3),
                        ),
                        borderRadius: BorderRadius.circular(5)),
                    child: Center(
                      child: Text.rich(
                        TextSpan(
                          text: _winner != '' ? 'Winner: ' : 'Current Player: ',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          children: [
                            if (_winner != '')
                              TextSpan(
                                text: '$_winner',
                                style: TextStyle(
                                  color: Colors.green,
                                ),
                              ),
                            if (_winner == '' && _currentPlayer.isNotEmpty)
                              TextSpan(
                                text: _currentPlayer,
                                style: TextStyle(
                                  color: _currentPlayer == 'X'
                                      ? Color(0Xffff5e2fd6)
                                      : Colors.red,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xffff3c84a3),
          onPressed: _resetGame,
          child: Icon(Icons.refresh, color: Colors.white),
        ),
      ),
    );
  }
}
