import 'package:flutter/material.dart';
import 'package:my_list/models/item.dart';

class ShoppingList extends StatelessWidget {
  const ShoppingList({
    super.key,
    required this.shoppingList,
    required this.onToggle,
  });

  final List<Item> shoppingList;
  final void Function(Item item) onToggle;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: shoppingList.length,
      itemBuilder: (context, index) {
        final item = shoppingList[index];
        return ListTile(
          onTap: () => onToggle(item),
          title: Text(item.name),
          contentPadding: EdgeInsets.zero,
          leading: Icon(
            item.inCart ? Icons.check_box : Icons.check_box_outline_blank,
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider(
          height: 4,
          color: Theme.of(context).colorScheme.primaryFixedDim,
        );
      },
    );
  }
}
