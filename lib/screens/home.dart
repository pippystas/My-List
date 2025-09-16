import 'package:flutter/material.dart';
import 'package:my_list/models/item.dart';
import 'package:my_list/widgets/add_item.dart';
import 'package:my_list/widgets/shopping_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _shoppingList = <Item>[];
  double? _total;
  bool get _allChecked =>
      _shoppingList.every((i) => i.inCart) && _shoppingList.isNotEmpty;

  void _toggleItem(Item item) {
    setState(() {
      item.inCart = !item.inCart;
    });
  }

  void _addItem(Item item) {
    setState(() {
      _shoppingList.add(item);
    });
  }

  Future<double?> _getTotal(BuildContext context) async {
    final controller = TextEditingController();

    final value = await showDialog<double?>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('How much was the total?'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(hintText: 'Price (€)'),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textInputAction: TextInputAction.done,
            onSubmitted: (_) {
              final v = double.tryParse(controller.text.replaceAll(',', '.'));
              Navigator.pop(ctx, v);
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, null), // cancel
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final v = double.tryParse(controller.text.replaceAll(',', '.'));
                Navigator.pop(ctx, v);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );

    setState(() {
      _total = value; // store last total if provided
    });

    return value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Expanded(
                child: ShoppingList(
                  shoppingList: _shoppingList,
                  onToggle: _toggleItem,
                ),
              ),
              AddItem(addItem: _addItem),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (!_allChecked) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Not all items are checked"),
                behavior: SnackBarBehavior.floating,
                duration: Duration(seconds: 1),
              ),
            );
          } else {
            debugPrint("Complete list");
            final total = await _getTotal(context);
            if (total != null) {
              setState(() {
                _shoppingList.clear();
              });
            }
          }
        },
        backgroundColor: Theme.of(context).colorScheme.surfaceDim,
        child: Icon(
          Icons.check,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),

      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
    );
  }
}
