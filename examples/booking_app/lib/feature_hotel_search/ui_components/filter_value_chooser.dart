import 'package:favorites_advanced_base/core.dart';
import 'package:favorites_advanced_base/keys.dart' as keys;
import 'package:flutter/material.dart';

class ItemValueChooser extends StatefulWidget {
  const ItemValueChooser({
    required this.initialValue,
    required this.onValueChanged,
    required this.title,
    this.titleStyle,
    super.key,
  });

  final String title;
  final TextStyle? titleStyle;
  final int initialValue;
  final void Function(int) onValueChanged;

  @override
  State<ItemValueChooser> createState() => _ItemValueChooserState();
}

class _ItemValueChooserState extends State<ItemValueChooser> {
  late int value;

  @override
  void initState() {
    super.initState();

    value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Text(
            widget.title,
            style: widget.titleStyle ??
                const TextStyle(
                  color: Colors.blue,
                  fontSize: 18,
                ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              FocusButton(
                key: keys.setCapacityFilterActionKey('${widget.title} Remove'),
                onPressed: () => changeValue(value - 1),
                child: const Icon(Icons.remove),
              ),
              Text(
                '$value',
                style: const TextStyle(
                  color: Colors.blue,
                  fontSize: 18,
                ),
              ),
              FocusButton(
                key: keys.setCapacityFilterActionKey('${widget.title} Add'),
                onPressed: () => changeValue(value + 1),
                child: const Icon(Icons.add),
              ),
            ],
          ),
        ],
      );

  void changeValue(int newValue) {
    if (newValue < 0) return;
    setState(() {
      value = newValue;
    });
    widget.onValueChanged(newValue);
  }
}
