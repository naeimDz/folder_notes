import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/word_provider.dart';
import '../shared/widgets/custom_chip.dart';

class WordOfTheDayWidget extends StatelessWidget {
  final bool isDark;

  const WordOfTheDayWidget({super.key, this.isDark = false});

  @override
  Widget build(BuildContext context) {
    return Consumer<WordProvider>(
      builder: (context, wordProvider, _) {
        if (wordProvider.isLoading) {
          return Center(child: CircularProgressIndicator());
        }

        final word = wordProvider.wordOfTheDay;
        if (word == null) {
          return Center(child: Text('No word of the day found'));
        }

        return Container(
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[850] : Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 15,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                // Set the selected word in the provider
                Provider.of<WordProvider>(context, listen: false)
                    .selectWord(word);
                Navigator.of(context).pushNamed(
                  "/word-details",
                  arguments: word,
                );
              },
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Word of the Day",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.blue[100],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            word.difficulty.name,
                            style: TextStyle(
                              color: Colors.blue[800],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Text(
                      word.word,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[600],
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      word.pronunciation,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      word.details?.definition ?? "",
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: word.details?.tags
                              .map((tag) => CustomChip(
                                    label: tag,
                                  ))
                              .toList() ??
                          [],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
