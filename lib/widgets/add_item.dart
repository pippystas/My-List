import 'package:flutter/material.dart';
import 'package:my_list/models/item.dart';

class AddItem extends StatefulWidget {
  final void Function(Item item) addItem;
  const AddItem({super.key, required this.addItem});

  @override
  State<AddItem> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose(); // free the native resources
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(Icons.add_box, color: Theme.of(context).colorScheme.tertiary),
        SizedBox(width: 12),
        Expanded(
          child: TextField(
            controller: _controller,
            textInputAction: TextInputAction.done, // "Done" button on keyboard
            decoration: InputDecoration(
              hintText: 'Add Item...',
              border: InputBorder.none,
            ),
            onSubmitted: (value) {
              final text = value.trim();
              if (text.isEmpty) return;
              widget.addItem(Item(text));
              _controller.clear();
            },
          ),
        ),
      ],
    );
  }
}
