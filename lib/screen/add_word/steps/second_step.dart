import 'package:flutter/material.dart';
import 'package:my_lab/screen/add_word/widgets/step_container.dart';
import 'package:my_lab/screen/shared/widgets/build_text_field.dart';
import 'package:provider/provider.dart';

import '../../../providers/form_state_provider.dart';

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
          buildModernTextField(
            initialValue: context
                    .read<FormStateProvider>()
                    .state
                    .theWord
                    ?.definitions?[0] ??
                "",
            onChanged: (value) {
              context
                  .read<FormStateProvider>()
                  .updateTheWordDetail(definitions: [value]);
            },
            context,
            label: 'Brief Definition',
            hint: 'Enter a concise definition',
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          buildModernTextField(
            initialValue:
                context.read<FormStateProvider>().state.theWord?.examples?[0] ??
                    "",
            onChanged: (value) {
              context
                  .read<FormStateProvider>()
                  .updateTheWordDetail(examples: [value]);
            },
            context,
            label: 'Example',
            hint: 'Enter an example sentence in English',
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          buildModernTextField(
            initialValue:
                context.read<FormStateProvider>().state.theWord?.contextNotes ??
                    "",
            onChanged: (value) {
              context
                  .read<FormStateProvider>()
                  .updateTheWordDetail(contextNotes: value);
            },
            context,
            label: "Usage Notes",
            hint:
                "Add additional notes about when, where, or how the word is typically used.",
            maxLines: 3,
          ),
        ],
      ),
    );
  }
}
