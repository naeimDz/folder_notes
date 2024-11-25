import 'package:flutter/material.dart';
import 'package:my_lab/screen/shared/widgets/build_text_field.dart';
import 'package:provider/provider.dart';
import '../../../providers/form_state_provider.dart';
import '../widgets/step_container.dart';

class FirstStepForm extends StatelessWidget {
  const FirstStepForm({super.key});

  @override
  Widget build(BuildContext context) {
    final formProvider = Provider.of<FormStateProvider>(context, listen: false);

    return StepContainer(
      stepIndex: 0,
      title: "Core Details",
      child: Column(
        children: [
          // Use Consumer for each field
          buildModernTextField(
            initialValue:
                context.read<FormStateProvider>().state.wordData?.word,
            onChanged: (value) {
              formProvider.updateCoreWord(word: value);
            },
            context,
            label: 'Word',
            hint: 'Enter the word',
            suffix: Icon(Icons.volume_up),
          ),

          const SizedBox(height: 16),
          buildModernTextField(
            initialValue:
                context.read<FormStateProvider>().state.wordData?.translation,
            onChanged: (value) {
              formProvider.updateCoreWord(translation: value);
            },
            context,
            label: 'Translation',
            hint: 'Enter translation',
            suffix: Icon(Icons.translate),
          ),
          const SizedBox(height: 16),
          buildModernTextField(
            initialValue:
                context.read<FormStateProvider>().state.wordData?.pronunciation,
            onChanged: (value) {
              formProvider.updateCoreWord(pronunciation: value);
            },
            context,
            label: 'Pronunciation',
            hint: 'Describe how the word is pronounced',
            suffix: Icon(Icons.record_voice_over),
          ),
        ],
      ),
    );
  }
}
