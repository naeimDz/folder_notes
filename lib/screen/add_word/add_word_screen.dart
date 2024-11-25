import 'package:flutter/material.dart';
import 'package:my_lab/screen/add_word/steps/second_step.dart';
import 'package:my_lab/screen/add_word/steps/third_step.dart';
import 'package:my_lab/screen/shared/widgets/custom_sliver_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:my_lab/providers/word_form_provider.dart';
import '../../providers/word_provider.dart';
import 'steps/first_step.dart';
import 'widgets/custom_bottom_navigation.dart';
import 'widgets/step_progress_indicator.dart';

// Constants
const int _kTotalSteps = 3;
const Duration _kAnimationDuration = Duration(milliseconds: 300);
const Curve _kAnimationCurve = Curves.easeInOut;

class AddWordScreen extends StatefulWidget {
  const AddWordScreen({super.key});

  @override
  State<AddWordScreen> createState() => _AddWordScreenState();
}

class _AddWordScreenState extends State<AddWordScreen> {
  late final PageController _pageController;
  final _formKeys =
      List.generate(_kTotalSteps, (index) => GlobalKey<FormState>());

  @override
  void initState() {
    super.initState();
    _initializePageController();
  }

  void _initializePageController() {
    _pageController = PageController();
    _pageController.addListener(_onPageChanged);
  }

  void _onPageChanged() {
    final currentPage = _pageController.page?.round() ?? 0;
    final provider = context.read<WordFormProvider>();
    if (provider.state.currentStep != currentPage) {
      provider.updateStep(currentPage);
    }
  }

  @override
  void dispose() {
    _pageController.removeListener(_onPageChanged);
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _navigateToPage(int page) async {
    await _pageController.animateToPage(
      page,
      duration: _kAnimationDuration,
      curve: _kAnimationCurve,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => WordFormProvider(),
      child: Consumer<WordFormProvider>(
        builder: (context, formProvider, _) {
          return Scaffold(
            //floatingActionButton: Text("add FAB for save word!!!"),
            bottomNavigationBar: CustomBottomNavigationBar(
                step: formProvider.state.currentStep,
                onBackPressed: () {
                  formProvider.navigateBackward();
                  _navigateToPage(formProvider.state.currentStep);
                },
                onNextPressed: () {
                  if (formProvider.state.currentStep == 2) {
                    print("create the word!!!!");

                    final newWord =
                        context.read<WordFormProvider>().getWordData();
                    print(newWord?.toFirestore());
                    // context.read<WordProvider>().addWord(newWord!);
                    print("dooone the word added");
                  } else {
                    formProvider.navigateForward();
                    _navigateToPage(formProvider.state.currentStep);
                  }
                }),
            body: CustomScrollView(
              slivers: [
                _buildAppBar(context),
                SliverFillRemaining(
                  child: Column(
                    children: [
                      StepProgressIndicator(
                          currentStep: formProvider.state.currentStep),
                      Expanded(
                        child: PageView(
                          controller: _pageController,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            Form(
                              key: _formKeys[0],
                              child: FirstStepForm(),
                            ),
                            Form(
                              key: _formKeys[1],
                              child: SecondStepForm(),
                            ),
                            Form(
                              key: _formKeys[2],
                              child: ThirdStepForm(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  CustomSliverAppBar _buildAppBar(BuildContext context) {
    final theme = Theme.of(context);
    return CustomSliverAppBar(
      gradientColors: [
        theme.colorScheme.primary,
        theme.colorScheme.primaryContainer,
      ],
      title: "Add New Word",
    );
  }
}
