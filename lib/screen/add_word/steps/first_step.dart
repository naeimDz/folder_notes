import 'package:flutter/material.dart';
import 'package:my_lab/screen/shared/widgets/build_text_field.dart';
import 'package:provider/provider.dart';
import '../../../providers/word_form_provider.dart';
import '../widgets/step_container.dart';

class FirstStepForm extends StatelessWidget {
  const FirstStepForm({super.key});

  @override
  Widget build(BuildContext context) {
    return StepContainer(
      stepIndex: 0,
      title: "Core Details",
      child: Column(
        children: [
          // Use Consumer for each field
          Selector<WordFormProvider, String?>(
            selector: (context, provider) => provider.state.wordData?.word,
            builder: (context, word, child) {
              return buildModernTextField(
                initialValue: word ?? '',
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
              );
            },
          ),
          const SizedBox(height: 16),
          Selector<WordFormProvider, String?>(
            selector: (context, provider) =>
                provider.state.wordData?.translation,
            builder: (context, translation, child) {
              return buildModernTextField(
                initialValue: translation ?? '',
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
              );
            },
          ),
          const SizedBox(height: 16),
          Selector<WordFormProvider, String?>(
            selector: (context, provider) =>
                provider.state.wordData?.pronunciation,
            builder: (context, pronunciation, child) {
              return buildModernTextField(
                initialValue: pronunciation ?? '',
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
              );
            },
          ),
        ],
      ),
    );
  }
}
