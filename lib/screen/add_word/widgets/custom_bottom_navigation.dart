import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final VoidCallback onBackPressed;
  final VoidCallback onNextPressed;
  final int step;

  const CustomBottomNavigationBar(
      {super.key,
      required this.onBackPressed,
      required this.onNextPressed,
      required this.step});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            if (step > 0) ...[
              TextButton.icon(
                onPressed: onBackPressed,
                icon: const Icon(Icons.arrow_back),
                label: const Text('Back'),
                style: TextButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                ),
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: ElevatedButton.icon(
                onPressed: onNextPressed,
                icon: Icon(
                  step == 3 - 1 ? Icons.check : Icons.arrow_forward,
                ),
                label: Text(
                  step == 3 - 1 ? 'Save Word' : 'Next Step',
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
