import 'package:favorites_advanced_base/core.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class HotelSortPage extends StatefulWidget {
  const HotelSortPage({
    this.onApplyPressed,
    this.initialSelection = SortBy.none,
    Key? key,
  }) : super(key: key);

  final Function(SortBy)? onApplyPressed;
  final SortBy initialSelection;

  @override
  State<HotelSortPage> createState() => _HotelSortPageState();
}

class _HotelSortPageState extends State<HotelSortPage> {
  late SortBy selected;

  @override
  void initState() {
    super.initState();
    selected = widget.initialSelection;
  }

  @override
  Widget build(BuildContext context) => Column(
        children: [
          _buildSortItems(),
          DialogButton(
            onPressed: () {
              widget.onApplyPressed?.call(selected);
              Navigator.of(context).pop();
            },
            child: const Text(
              'Apply',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
        ],
      );

  Widget _buildSortItems() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
        child: Column(
          children: [
            _buildSortingRow(
              label: 'Expensive',
              highest: SortBy.priceDesc,
              lowest: SortBy.priceAsc,
            ),
            _buildSortingRow(
              label: 'Closest',
              highest: SortBy.distanceDesc,
              lowest: SortBy.distanceAsc,
            ),
          ],
        ),
      );

  Row _buildSortingRow({
    required String label,
    required SortBy highest,
    required SortBy lowest,
  }) =>
      Row(
        children: [
          Expanded(child: Text(label)),
          _buildItem(name: highest.displayString, id: highest),
          _buildItem(name: lowest.displayString, id: lowest),
        ],
      );

  Widget _buildItem({required String name, required SortBy id}) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: GestureDetector(
          onTap: () {
            setState(() {
              selected = id;
            });
          },
          child: Chip(
            labelStyle: ChipTheme.of(context)
                .labelStyle
                ?.copyWith(color: selected == id ? Colors.white : Colors.black),
            label: Text(name),
            backgroundColor:
                selected == id ? Theme.of(context).colorScheme.secondary : null,
          ),
        ),
      );
}

extension _SortByUtils on SortBy {
  String get displayString {
    switch (this) {
      case SortBy.none:
        return 'None';
      case SortBy.priceAsc:
        return 'last';
      case SortBy.priceDesc:
        return 'first';
      case SortBy.distanceAsc:
        return 'last';
      case SortBy.distanceDesc:
        return 'first';
    }
  }
}
