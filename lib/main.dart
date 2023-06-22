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
      title: 'Tic Tac Toe',
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
      Audio('assets/audio/summer-walk-152722.mp3'),
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
          // Add this condition
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
          content: Text('Congratulations, $winner! You won the game.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _resetGame();
              },
              child: Text('Play Again'),
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
              color: _board[row][col] == 'X' ? Colors.blue : Colors.red,
            ),
          ),
        ),
        foregroundDecoration: isWinnerCell && _winner == _board[row][col]
            ? BoxDecoration(
                border: Border.all(
                  color: Colors.green,
                  width: 4,
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
        appBar: AppBar(
          title: Center(child: Text('Tic Tac Toe')),
          actions: [
            IconButton(
              onPressed: _toggleMusic,
              icon: Icon(
                _isMusicOn ? Icons.music_note : Icons.music_off,
              ),
            ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/2863231.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height / 5,
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        border: Border.all(color: Colors.purple, width: 4)),
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
                  height: 50,
                  width: 250,
                  margin: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      border: Border.all(
                        color: Colors.purple,
                      ),
                      borderRadius: BorderRadius.circular(5)),
                  child: Center(
                    child: Text(
                      _winner != ''
                          ? 'Winner: $_winner'
                          : 'Current Player: $_currentPlayer',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _resetGame,
          child: Icon(Icons.refresh),
        ),
      ),
    );
  }
}
