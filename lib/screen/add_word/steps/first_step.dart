import 'package:flutter/material.dart';
import 'package:my_lab/screen/shared/widgets/build_text_field.dart';
import 'package:provider/provider.dart';
import '../../../providers/word_form_provider.dart';
import '../widgets/step_container.dart';

class FirstStepForm extends StatelessWidget {
  final WordFormState state;

  const FirstStepForm({
    required this.state,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StepContainer(
      stepIndex: 0,
      title: "Core Details",
      child: Column(
        children: [
          buildModernTextField(
            initialValue: context.read<WordFormProvider>().state.wordData?.word,
            onChanged: (value) =>
                context.read<WordFormProvider>().updateWord(value),
            context,
            label: 'Word',
            hint: 'Enter the word',
            suffix: IconButton(
              icon: const Icon(Icons.volume_up),
              onPressed: () {
                // Implement text-to-speech
              },
            ),
          ),
          const SizedBox(height: 16),
          buildModernTextField(
            initialValue:
                context.read<WordFormProvider>().state.wordData?.translation,
            onChanged: (value) =>
                context.read<WordFormProvider>().updateTranslation(value),
            context,
            label: 'Translation',
            hint: 'Enter translation',
            suffix: IconButton(
              icon: const Icon(Icons.translate),
              onPressed: () {
                // Implement auto-translation
              },
            ),
          ),
          const SizedBox(height: 16),
          buildModernTextField(
            initialValue:
                context.read<WordFormProvider>().state.wordData?.pronunciation,
            onChanged: (value) =>
                context.read<WordFormProvider>().updatePronunciation(value),
            context,
            label: 'Pronunciation',
            hint: 'Describe how the word is pronounced',
            suffix: IconButton(
              icon: const Icon(Icons.record_voice_over),
              onPressed: () {
                // Implement voice recording
              },
            ),
          ),
        ],
      ),
    );
  }
}
