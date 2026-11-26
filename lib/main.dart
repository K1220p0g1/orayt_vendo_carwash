// Save this file exactly as: lib/main.dart
import 'package:flutter/material.dart';

void main() {
  runApp(const OraytCarwashApp());
}

class OraytCarwashApp extends StatelessWidget {
  const OraytCarwashApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Orayt Vendo Carwash',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0077B6),
          primary: const Color(0xFF0077B6),
          secondary: const Color(0xFF00B4D8),
          background: const Color(0xFFF0F8FF),
        ),
        scaffoldBackgroundColor: const Color(0xFFF0F8FF),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  
  final List<Widget> _screens = [
    const TimerCalculatorScreen(),
    const GuideScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Orayt Vendo Carwash',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 4,
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.timer),
            label: 'Wash Timer',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'User Guide',
          ),
        ],
      ),
    );
  }
}

class TimerCalculatorScreen extends StatefulWidget {
  const TimerCalculatorScreen({super.key});

  @override
  State<TimerCalculatorScreen> createState() => _TimerCalculatorScreenState();
}

class _TimerCalculatorScreenState extends State<TimerCalculatorScreen> {
  int _coinCount = 1;
  int _totalSeconds = 120; 
  int _secondsRemaining = 120;
  
  java_timer? _timer; 
  bool _isRunning = false;

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
    _timer = java_timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _stopTimer();
        }
      });
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
    });
  }

  void _stopTimer() {
    _timer?.cancel();
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

  String _formatTime(int totalSeconds) {
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
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
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
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

class java_timer {
  final StreamSubscription _subscription;
  java_timer.periodic(Duration duration, void Function(java_timer timer) callback)
      : _subscription = Stream.periodic(duration, (count) => count).listen((_) {}) {
    _subscription.onData((_) => callback(this));
  }
  void cancel() => _subscription.cancel();
}

class GuideScreen extends StatelessWidget {
  const GuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final steps = [
      {"step": "1", "title": "Insert ₱5 Peso Coin", "desc": "Insert a crisp coin. The high-pressure water system will immediately activate."},
      {"step": "2", "title": "Apply Soap / Foam", "desc": "Switch machine nozzle state if foam option is present to cover your target vehicle uniformly."},
      {"step": "3", "title": "Rinse Thoroughly", "desc": "Switch back to high pressure wash mode to completely wash away remaining residue."},
      {"step": "4", "title": "Dry Vehicle", "desc": "Use clean microfiber cloths or a dynamic vacuum outlet if supported locally."},
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: steps.length,
              itemBuilder: (context, index) {
                return Card(
                  
