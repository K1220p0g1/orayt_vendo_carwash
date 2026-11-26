import 'package:flutter/material.dart';

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
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      textColor: Colors.white,
                      child: Text(steps[index]["step"]!),
                    ),
                    title: Text(steps[index]["title"]!, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(steps[index]["desc"]!),
                  ),
                );
              },
            ),
          ),
          
          // Emergency Technical Operator Support Trigger
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: ElevatedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Machine Support"),
                    content: const Text("Is the machine eating coins or experiencing issues? Contact owner immediately."),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Close"),
                      ),
                      ElevatedButton(
                        onPressed: () {}, // Future mapping hook for system direct dialers
                        child: const Text("Call Operator (09123456789)"),
                      )
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.help_outline),
              label: const Text("Help & Technical Machine Support"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange.shade700,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          )
        ],
      ),
    );
  }
}
