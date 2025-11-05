import 'package:flutter/material.dart';
import 'circular_countdown.dart';
import 'main.dart';

class TaskCard extends StatelessWidget {
  final TaskItem task;
  final VoidCallback onDelete;

  const TaskCard({Key? key, required this.task, required this.onDelete})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Check if the due date has passed
    final isOverdue = task.daysLeft <= 0;

    return GestureDetector(
      onLongPress: () {
        // Show delete confirmation dialog on long press
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: const Color(0xFF1A2332),
            title: const Text(
              'Delete Task',
              style: TextStyle(color: Colors.white),
            ),
            content: Text(
              'Are you sure you want to delete "${task.name}"?',
              style: const TextStyle(color: Colors.white70),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Color(0xFF7FFFD4)),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  onDelete();
                },
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF1A2332),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF2A3442), width: 1),
        ),
        child: Row(
          children: [
            // Left side - Task Name and Days Left
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    task.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    task.daysLeft > 0
                        ? '${task.daysLeft} days left'
                        : task.daysLeft == 0
                        ? 'Due today'
                        : 'Overdue by ${task.daysLeft.abs()} days',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: task.daysLeft <= 0
                          ? Colors.red
                          : const Color(0xFFFFA500),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 16),

            // Right side - Circular Countdown
            CircularCountdown(daysLeft: task.daysLeft, totalDays: 7),
          ],
        ),
      ),
    );
  }
}
