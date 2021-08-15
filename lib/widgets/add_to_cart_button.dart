import 'package:fgcart/hrv/api.dart';
import 'package:fgcart/hrv/model.dart';
import 'package:fgcart/test_cases/config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddToCartButton extends StatelessWidget {
  final int id;
  final List<int>? outfitAdd;
  final List<int>? outfitDrop;
  final List<int>? outfitRemove;
  final String? text;

  AddToCartButton({
    int? id,
    this.outfitAdd,
    this.outfitDrop,
    this.outfitRemove,
    this.text,
    Key? key,
  })  : id = id ?? config.v0,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final api = context.watch<HrvApi>();
    return AnimatedBuilder(
      animation: api.isLoading,
      builder: (_, __) => ElevatedButton(
        onPressed: api.isLoading.value ? null : () => _addToCart(context),
        child: Text(text ?? '$id'),
      ),
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
