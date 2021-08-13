import 'package:fgcart/hrv/api.dart';
import 'package:fgcart/hrv/model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'cart_item_widget.dart';

class CartWidget extends StatefulWidget {
  const CartWidget({Key? key}) : super(key: key);

  @override
  _CartWidgetState createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
  var _cart = Cart();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(_cart.token),
          subtitle: const Text('token'),
        ),
        ..._cart.groups.map((group) => Column(
              children: [
                if (group is CartOutfit)
                  ListTile(
                    title: Text(
                      'Outfit ${group.id}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                ...group.items.map((item) => CartItemWidget(item)),
              ],
            )),
        ListTile(
          title: Text('${_cart.totalPrice}'),
          subtitle: const Text('total_price'),
        ),
        TextButton(
          onPressed: () => _refresh(),
          child: const Text('Refresh'),
        ),
      ],
    );
  }

  Future<void> _refresh() async {
    final api = context.read<HrvApi>();
    final cart = await api.cart;
    if (mounted) {
      setState(() => _cart = cart);
    }
  }
}
