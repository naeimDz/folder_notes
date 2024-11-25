import 'package:flutter/material.dart';
import 'package:my_lab/screen/add_word/widgets/step_container.dart';
import 'package:my_lab/screen/shared/widgets/build_text_field.dart';
import 'package:provider/provider.dart';

import '../../../providers/word_form_provider.dart';

class ThirdStepForm extends StatelessWidget {
  const ThirdStepForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StepContainer(
      stepIndex: 2,
      title: "Metadata",
      child: Column(
        children: [
          Selector<WordFormProvider, String?>(
              selector: (context, provider) =>
                  provider.state.wordData?.details?.synonyms[0],
              builder: (context, word, child) {
                return buildModernTextField(
                  initialValue: word ?? "",
                  onFieldSubmitted: (value) => context
                      .read<WordFormProvider>()
                      .updateDetailWord(synonyms: [value ?? ""]),
                  onChanged: (value) => context
                      .read<WordFormProvider>()
                      .updateDetailWord(synonyms: [value]),
                  context,
                  label: "Synonyms",
                  hint: "List words that have the same or similar meaning.",
                );
              }),
          const SizedBox(height: 16),
          Selector<WordFormProvider, String?>(
              selector: (context, provider) =>
                  provider.state.wordData?.details?.antonyms[0],
              builder: (context, word, child) {
                return buildModernTextField(
                  initialValue: word ?? "",
                  onChanged: (value) => context
                      .read<WordFormProvider>()
                      .updateDetailWord(antonyms: [value]),
                  context,
                  label: "Antonyms",
                  hint: "List words that have the opposite meaning.",
                );
              }),
          const SizedBox(height: 16),
          buildModernTextField(
            context,
            label: "Tags",
            hint: "Add keywords or categories related to the word",
            suffix: const Icon(Icons.tag_sharp),
          ),
        ],
      ),
    );
  }
}
