import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class CustomSearchBar extends StatefulWidget {
  final Function(String) onSearchChanged;
  final String? hintText;
  final bool enabled;

  const CustomSearchBar({
    super.key,
    required this.onSearchChanged,
    this.hintText,
    this.enabled = true,
  });

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGreen.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        enabled: widget.enabled,
        textDirection: TextDirection.rtl,
        onChanged: widget.onSearchChanged,
        decoration: InputDecoration(
          hintText: widget.hintText ?? 'ابحث عن نبات...',
          hintStyle: TextStyle(
            color: AppColors.gray,
            fontFamily: 'IBMPlexSansArabic',
          ),
          prefixIcon: Icon(Icons.search, color: AppColors.primaryGreen),
          suffixIcon: _controller.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear, color: AppColors.gray),
                  onPressed: () {
                    _controller.clear();
                    widget.onSearchChanged('');
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
        style: const TextStyle(fontFamily: 'IBMPlexSansArabic', fontSize: 16),
      ),
    );
  }
}
