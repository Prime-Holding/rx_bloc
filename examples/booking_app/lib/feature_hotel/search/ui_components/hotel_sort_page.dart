import 'package:favorites_advanced_base/core.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class HotelSortPage extends StatefulWidget {
  HotelSortPage({
    this.onApplyPressed,
    this.initialSelection = SortBy.none,
  });

  final Function(SortBy)? onApplyPressed;
  final SortBy initialSelection;

  @override
  _HotelSortPageState createState() => _HotelSortPageState();
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
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            _buildItem(name: 'Price descending', id: SortBy.priceDesc),
            _buildItem(name: 'Price ascending', id: SortBy.priceAsc),
            _buildItem(name: 'Distance descending', id: SortBy.distanceDesc),
            _buildItem(name: 'Distance ascending', id: SortBy.distanceAsc),
          ],
        ),
      );

  Widget _buildItem({required String name, required SortBy id}) => Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 5),
        child: GestureDetector(
          onTap: () {
            setState(() {
              selected = id;
            });
          },
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              color: selected == id ? Colors.blue : Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: selected == id ? Colors.white : Colors.blue,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
