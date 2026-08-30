import 'package:flutter/material.dart';
import 'package:my_app/widgets/category.dart';

class HomeHeader extends StatefulWidget {
  final String? searchItem;
  final String? sortItems;
  final ValueChanged<String>? onSearchChanged;
  final VoidCallback? onSortPressed;
  final FocusNode searchFocusNode;

  const HomeHeader({
    super.key,
    this.searchItem,
    this.sortItems,
    this.onSearchChanged,
    this.onSortPressed,
    required this.searchFocusNode,
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
  void didUpdateWidget(covariant HomeHeader oldWidget) {
    super.didUpdateWidget(oldWidget);
    final searchItem = widget.searchItem;
    if (searchItem != null && searchItem != _searchController.text) {
      _searchController.text = searchItem;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
      // color: Colors.white,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE7E7EA), width: 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Material(
                color: const Color(0xFFF5F5F7),
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => Scaffold.maybeOf(context)?.openDrawer(),
                  child: Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFE7E7EA)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.menu_rounded,
                      color: Color(0xFF1C1C1E),
                      size: 22,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  height: 46,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F7),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE7E7EA)),
                  ),
                  child: TextField(
                     focusNode: widget.searchFocusNode,
                    controller: _searchController,
                    onTapOutside: (_) =>
                        FocusManager.instance.primaryFocus?.unfocus(),
                    onChanged: widget.onSearchChanged,
                    decoration: const InputDecoration(
                      hintText: "Search items...",
                      hintStyle: TextStyle(
                        color: Color(0xFF8A8A8E),
                        fontSize: 15,
                      ),
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        color: Color(0xFF8A8A8E),
                        size: 22,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 11),
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
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFE7E7EA)),
                      borderRadius: BorderRadius.circular(12),
                    ),
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

          const SizedBox(height: 14),

          const Categories(),
        ],
      ),
    );
  }
}
