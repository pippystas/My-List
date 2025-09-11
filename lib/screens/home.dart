import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _shoppingList = <String>[];
  final _cart = <String>[];

  void _addItem(String item) {
    setState(() {
      _shoppingList.add(item);
    });
  }

  void _toggleItem(String item) {
    setState(() {
      if (_cart.contains(item)) {
        _cart.remove(item);
      } else {
        _cart.add(item);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton:
          (_shoppingList.isNotEmpty && _cart.length == _shoppingList.length)
          ? FloatingActionButton(
              onPressed: () {
                debugPrint("Complete list");
                setState(() {
                  _shoppingList.clear();
                  _cart.clear();
                });
              },
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Icon(
                Icons.check,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            )
          : null,
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                ShoppingList(
                  shoppingList: _shoppingList,
                  cart: _cart,
                  onToggle: _toggleItem,
                ),
                AddItem(onItemAdded: _addItem),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ShoppingList extends StatelessWidget {
  const ShoppingList({
    super.key,
    required List<String> shoppingList,
    required List<String> cart,
    required this.onToggle,
  }) : _shoppingList = shoppingList,
       _cart = cart;

  final List<String> _shoppingList;
  final List<String> _cart;
  final void Function(String) onToggle;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
        itemCount: _shoppingList.length,
        itemBuilder: (context, index) => ListTile(
          title: Text(_shoppingList[index]),
          contentPadding: EdgeInsets.zero,
          leading: IconButton(
            onPressed: () {
              onToggle(_shoppingList[index]);
            },
            icon: Icon(
              _cart.contains(_shoppingList[index])
                  ? Icons.check_box
                  : Icons.check_box_outline_blank,
            ),
          ),
        ),
        separatorBuilder: (BuildContext context, int index) {
          return Divider(
            height: 4,
            color: Theme.of(context).colorScheme.primaryFixedDim,
          );
        },
      ),
    );
  }
}

class AddItem extends StatefulWidget {
  final void Function(String) onItemAdded;
  const AddItem({super.key, required this.onItemAdded});

  @override
  State<AddItem> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.add, color: Theme.of(context).colorScheme.tertiary),
          SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _controller,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                hintText: 'Add Item...',
                border: InputBorder.none,
              ),
              onSubmitted: (value) {
                final text = value.trim();
                if (text.isEmpty) return;
                widget.onItemAdded(text);
                _controller.clear();
              },
            ),
          ),
        ],
      ),
    );
  }
}
