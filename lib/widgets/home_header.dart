import 'package:flutter/material.dart';

class HomeHeader extends StatefulWidget {
  final String? searchItem;
  final String? sortItems;
  final ValueChanged<String>? onSearchChanged;
  final VoidCallback? onSortPressed;

  const HomeHeader({
    super.key,
    this.searchItem,
    this.sortItems,
    this.onSearchChanged,
    this.onSortPressed,
  });

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.searchItem);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      decoration: BoxDecoration(
        // color: Colors.white,
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withOpacity(0.03),
        //     blurRadius: 10,
        //     offset: const Offset(0, 4),
        //   ),
        // ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 46,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _searchController,
                // Called when the user taps outside the TextField.
                // Removes focus and stops the cursor from blinking.
                onTapOutside: (_) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                onChanged: widget.onSearchChanged,

                decoration: InputDecoration(
                  hintText: "Search items...",
                  // FIXED: Removed the 'hide' keyword typo from the Color definition
                  hintStyle: const TextStyle(
                    color: Color(0xFF8A8A8E),
                    fontSize: 15,
                  ),

                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: Color(0xFF8A8A8E),
                    size: 22,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 11),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Material(
            color: const Color(0xFFF5F5F7),
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: widget.onSortPressed,
              child: Container(
                height: 46,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.swap_vert_rounded,
                      color: Color(0xFF1C1C1E),
                      size: 20,
                    ),
                    if (widget.sortItems != null &&
                        widget.sortItems!.isNotEmpty) ...[
                      const SizedBox(width: 6),
                      Text(
                        widget.sortItems!,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1C1C1E),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
