import 'package:flutter/material.dart';
import 'package:my_lab/screen/add_word/widgets/step_container.dart';
import 'package:my_lab/screen/shared/widgets/build_text_field.dart';
import 'package:provider/provider.dart';
import '../../../providers/word_form_provider.dart';

class SecondStepForm extends StatelessWidget {
  const SecondStepForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StepContainer(
      stepIndex: 1,
      title: "Usage Details",
      child: Column(
        children: [
          Selector<WordFormProvider, String?>(
            selector: (_, provider) =>
                provider.state.wordDetails?.definition[0],
            builder: (context, definition, _) {
              return buildModernTextField(
                context,
                initialValue: definition ?? "",
                onChanged: (value) => context
                    .read<WordFormProvider>()
                    .updateDetailWord(definition: [value]),
                label: 'Brief Definition',
                hint: 'Enter a concise definition',
                maxLines: 3,
              );
            },
          ),
          const SizedBox(height: 16),
          Selector<WordFormProvider, String?>(
            selector: (_, provider) => provider.state.wordDetails?.examples[0],
            builder: (context, example, _) {
              return buildModernTextField(
                initialValue: example ?? '',
                onChanged: (value) => context
                    .read<WordFormProvider>()
                    .updateDetailWord(examples: [value]),
                context,
                label: 'Example',
                hint: 'Enter an example sentence in English',
                maxLines: 3,
              );
            },
          ),
          const SizedBox(height: 16),
          Selector<WordFormProvider, String?>(
            selector: (_, provider) => provider.state.wordDetails?.usageNotes,
            builder: (context, usageNotes, _) {
              return buildModernTextField(
                initialValue: usageNotes ?? '',
                onChanged: (value) => context
                    .read<WordFormProvider>()
                    .updateDetailWord(usageNote: value),
                context,
                label: "Usage Notes",
                hint:
                    "Add additional notes about when, where, or how the word is typically used.",
                maxLines: 3,
              );
            },
          ),
        ],
      ),
    );
  }
}
