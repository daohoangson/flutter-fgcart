import 'package:alice/alice.dart';
import 'package:fgcart/hrv/api.dart';
import 'package:fgcart/widgets/add_to_cart_button.dart';
import 'package:fgcart/widgets/cart_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'config.dart';

class AddOutfit extends StatefulWidget {
  const AddOutfit({Key? key}) : super(key: key);

  @override
  _AddOutfitState createState() => _AddOutfitState();
}

class _AddOutfitState extends State<AddOutfit> {
  final api = HrvApi(config);

  @override
  Widget build(BuildContext context) {
    final variantIds = [1074609211, 1074602454];

    return Provider(
      create: (_) => HrvApi(config),
      builder: (_, __) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Add Outfit'),
            actions: [
              IconButton(
                onPressed: () => context.read<Alice>().showInspector(),
                icon: const Icon(Icons.dashboard),
              ),
            ],
          ),
          body: ListView(
            children: [
              const CartWidget(),
              ...variantIds.map(
                (id) => AddToCartButton(
                  id: id,
                  outfitAdd: variantIds,
                ),
              ),
              AddToCartButton(
                id: config.v0,
                outfitAdd: variantIds,
                text: 'Increase outfit quantity',
              ),
              AddToCartButton(
                id: config.v0,
                outfitRemove: variantIds,
                text: 'Decrease outfit quantity',
              ),
              AddToCartButton(
                id: config.v0,
                outfitDrop: variantIds,
                text: 'Drop outfit entirely',
              ),
            ],
          ),
        );
      },
    );
  }
}
