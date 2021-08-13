import 'package:fgcart/hrv/api.dart';
import 'package:fgcart/hrv/model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddToCartButton extends StatelessWidget {
  final int id;
  final List<int>? outfitAdd;
  final List<int>? outfitDrop;
  final List<int>? outfitRemove;
  final String? text;

  const AddToCartButton({
    required this.id,
    this.outfitAdd,
    this.outfitDrop,
    this.outfitRemove,
    this.text,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _addToCart(context),
      child: Text(text ?? 'Add $id'),
    );
  }

  void _addToCart(BuildContext context) {
    final api = context.read<HrvApi>();
    api.addToCart(AddToCartRequest(
      id: id,
      properties: CartItemProperties(
        outfitAdd: outfitAdd != null ? outfitAdd!.join(',') : null,
        outfitDrop: outfitDrop != null ? outfitDrop!.join(',') : null,
        outfitRemove: outfitRemove != null ? outfitRemove!.join(',') : null,
      ),
    ));
  }
}
