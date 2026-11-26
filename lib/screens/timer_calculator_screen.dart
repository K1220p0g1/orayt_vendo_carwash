import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class TimerCalculatorScreen extends StatefulWidget {
  const TimerCalculatorScreen({super.key});

  @override
  State<TimerCalculatorScreen> createState() => _TimerCalculatorScreenState();
}

class _TimerCalculatorScreenState extends State<TimerCalculatorScreen> {
  int _coinCount = 1;
  int _totalSeconds = 120; // 1 Coin = 2 Mins (120 Secs)
  int _secondsRemaining = 120;
  
  Timer? _timer;
  bool _isRunning = false;
  final AudioPlayer _audioPlayer = AudioPlayer();

  void _updateTime(int coins) {
    setState(() {
      _coinCount = coins;
      _totalSeconds = coins * 120;
      if (!_isRunning) {
        _secondsRemaining = _totalSeconds;
      }
    });
  }

  void _startTimer() {
    if (_isRunning) return;
    setState(() {
      _isRunning = true;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
          
          // Sound trigger alerts
          if (_secondsRemaining == 10) {
            _playAlert(ReleaseMode.loop); // Beep warning
          }
        } else {
          _stopTimer();
          _playAlert(ReleaseMode.release); // End tone
        }
      });
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    _audioPlayer.stop();
    setState(() {
      _isRunning = false;
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _audioPlayer.stop();
    setState(() {
      _isRunning = false;
    });
  }

  void _resetTimer() {
    _stopTimer();
    setState(() {
      _secondsRemaining = _totalSeconds;
    });
  }

  Future<void> _playAlert(ReleaseMode mode) async {
    await _audioPlayer.setReleaseMode(mode);
    // Uses native system sounds to avoid complex bundle configurations
    await _audioPlayer.play(Uri.parse('asset:///packages/audioplayers/assets/sound.mp3'));
  }

  String _formatTime(int totalSeconds) {
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double progress = _totalSeconds > 0 ? _secondsRemaining / _totalSeconds : 0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Coin Selection Panel
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              key: const Key('calculator_panel'),
              child: Column(
                children: [
                  const Text(
                    "Insert Coins (₱5 Each)",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle, size: 36, color: Colors.red),
                        onPressed: _coinCount > 1 ? () => _updateTime(_coinCount - 1) : null,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          '$_coinCount Coin(s)',
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle, size: 36, color: Colors.green),
                        onPressed: () => _updateTime(_coinCount + 1),
                      ),
                    ],
                  ),
                  const Divider(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          const Text("Total Price", style: TextStyle(color: Colors.grey)),
                          Text("₱${_coinCount * 5}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue)),
                        ],
                      ),
                      Column(
                        children: [
                          const Text("Target Time", style: TextStyle(color: Colors.grey)),
                          Text("${_coinCount * 2} Mins", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue)),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),

          // Visual Circle Display Timer
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 220,
                height: 220,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 14,
                  backgroundColor: Colors.grey.shade300,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _secondsRemaining <= 10 ? Colors.red : Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
              Column(
                children: [
                  Text(
                    _formatTime(_secondsRemaining),
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: _secondsRemaining <= 10 ? Colors.red : Colors.black87,
                    ),
                  ),
                  const Text("Remaining", style: TextStyle(color: Colors.grey)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 30),

          // Player State Button Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: _isRunning ? _pauseTimer : _startTimer,
                icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
                label: Text(_isRunning ? "Pause" : "Start"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
              const SizedBox(width: 20),
              OutlinedButton.icon(
                onPressed: _resetTimer,
                icon: const Icon(Icons.refresh),
                label: const Text("Reset"),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
