import 'package:flutter/material.dart';

class WordInput extends StatefulWidget {
  final Function(String word, String type) onSave;
  final VoidCallback onHide;
  final bool isVisible;

  // Use const constructor for better widget tree optimization
  const WordInput({
    super.key,
    required this.onSave,
    required this.onHide,
    this.isVisible = true,
  });

  @override
  State<WordInput> createState() => _WordInputState();
}

class _WordInputState extends State<WordInput> {
  late final TextEditingController _controller;
  bool _isSynonym = true;
  bool _isInputValid = false;

  // Optimize color constants
  static const _synonymColor = Color(0xFF1B5E20); // Colors.green[900]
  static const _antonymColor = Color(0xFFB71C1C); // Colors.red[900]
  static const _backgroundColor = Color(0xFFFFFFFF);

  // Cache commonly used styles and decorations
  static const _iconSize = 16.0;
  static const _textStyle = TextStyle(fontSize: 14);
  static const _containerHeight = 32.0;
  static const _inputHeight = 40.0;

  // Cache commonly used decorations
  static final _toggleOptionWidth = 120.0;
  static final _borderRadius = BorderRadius.circular(8);
  static final _inputBorderRadius = BorderRadius.circular(20);

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _setupListeners();
  }

  void _setupListeners() {
    _controller.addListener(_validateInput);
  }

  // Separate validation logic for better performance
  void _validateInput() {
    final isValid = _controller.text.trim().isNotEmpty;
    if (_isInputValid != isValid) {
      setState(() => _isInputValid = isValid);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Optimize submit handler
  void _handleSubmit() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      widget.onSave(text, _isSynonym ? 'Synonym' : 'Antonym');
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isVisible)
      return const SizedBox.shrink(); // Early return for better performance

    final accentColor = _isSynonym ? _synonymColor : _antonymColor;

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 200),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) => Transform.translate(
        offset: Offset(0, 20 * (1 - value)),
        child: Opacity(opacity: value, child: child),
      ),
      child: _buildContent(accentColor),
    );
  }

  // Split content building for better readability and maintenance
  Widget _buildContent(Color accentColor) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: _borderRadius,
        border: Border.all(
          color: accentColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(accentColor),
          const SizedBox(height: 8),
          _buildInputSection(accentColor),
        ],
      ),
    );
  }

  Widget _buildHeader(Color accentColor) {
    return Row(
      children: [
        Expanded(child: _buildToggle(accentColor)),
        IconButton(
          icon: const Icon(Icons.keyboard_arrow_down, size: _iconSize),
          onPressed: widget.onHide,
          splashRadius: 20,
          tooltip: 'Hide (swipe down)',
        ),
      ],
    );
  }

  Widget _buildToggle(Color accentColor) {
    return Container(
      height: _containerHeight,
      decoration: BoxDecoration(
        color: accentColor.withOpacity(0.1),
        borderRadius: _borderRadius,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _ToggleOption(
            selected: _isSynonym,
            onTap: () => setState(() => _isSynonym = true),
            icon: Icons.sync_alt,
            color: _synonymColor,
            text: 'Synonym',
            width: _toggleOptionWidth,
            borderRadius: _borderRadius,
          ),
          _ToggleOption(
            selected: !_isSynonym,
            onTap: () => setState(() => _isSynonym = false),
            icon: Icons.compare_arrows,
            color: _antonymColor,
            text: "Antonyms",
            width: _toggleOptionWidth,
            borderRadius: _borderRadius,
          ),
        ],
      ),
    );
  }

  Widget _buildInputSection(Color accentColor) {
    return SizedBox(
      height: _inputHeight,
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          TextField(
            controller: _controller,
            onSubmitted: (_) => _handleSubmit(),
            textInputAction: TextInputAction.done,
            style: _textStyle,
            decoration: InputDecoration(
              hintText: _isSynonym ? 'Add synonym...' : 'Add antonym...',
              hintStyle: TextStyle(color: Colors.grey[400]),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              filled: true,
              fillColor: accentColor.withOpacity(0.05),
              border: OutlineInputBorder(
                borderRadius: _inputBorderRadius,
                borderSide: BorderSide.none,
              ),
            ),
          ),
          if (_controller.text.isNotEmpty)
            Positioned(
              right: 4,
              child: _buildActionButton(accentColor),
            ),
        ],
      ),
    );
  }

  Widget _buildActionButton(Color accentColor) {
    return Material(
      type: MaterialType.transparency,
      child: IconButton(
        icon: Icon(
          _isInputValid ? Icons.arrow_forward : Icons.close,
          size: 18,
        ),
        color: _isInputValid ? accentColor : Colors.grey,
        splashRadius: 20,
        onPressed: _isInputValid ? _handleSubmit : _controller.clear,
        tooltip: _isInputValid ? 'Save' : 'Clear',
      ),
    );
  }
}

// Extracted to separate stateless widget for better performance
class _ToggleOption extends StatelessWidget {
  final bool selected;
  final VoidCallback onTap;
  final IconData icon;
  final Color color;
  final String text;
  final double width;
  final BorderRadius borderRadius;

  const _ToggleOption({
    required this.selected,
    required this.onTap,
    required this.icon,
    required this.color,
    required this.text,
    required this.width,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: width,
        height: 40,
        decoration: BoxDecoration(
          color: selected ? color : Colors.transparent,
          borderRadius: borderRadius,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: selected ? Colors.white : color,
            ),
            const SizedBox(width: 4),
            Text(
              text,
              style: TextStyle(
                color: selected ? Colors.white : Colors.grey,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
