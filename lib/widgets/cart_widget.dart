import 'package:fgcart/hrv/api.dart';
import 'package:fgcart/hrv/model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'cart_item_widget.dart';

class CartWidget extends StatelessWidget {
  const CartWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final api = context.read<HrvApi>();
    return AnimatedBuilder(
      animation: Listenable.merge([api.cart, api.isLoading]),
      builder: (context, _) => _CartWidget(
        api.cart.value,
        isLoading: api.isLoading.value,
      ),
    );
  }
}

class _CartWidget extends StatelessWidget {
  final Cart cart;
  final bool isLoading;

  const _CartWidget(this.cart, {required this.isLoading, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(cart.token ?? 'N/A'),
          subtitle: const Text('token'),
        ),
        ...cart.groups.map((group) => Column(
              children: [
                if (group is CartOutfit)
                  ListTile(
                    title: Text(
                      'Outfit=${group.id}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                ...group.items.map((item) => CartItemWidget(item)),
              ],
            )),
        ListTile(
          title: isLoading
              ? const Align(
                  alignment: Alignment.topLeft,
                  child: CircularProgressIndicator.adaptive(),
                )
              : Text('${cart.totalPrice}'),
          subtitle: const Text('total_price'),
        ),
      ],
    );
  }
}
