import 'package:alice/alice.dart';
import 'package:fgcart/hrv/api.dart';
import 'package:fgcart/widgets/add_to_cart_button.dart';
import 'package:fgcart/widgets/cart_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_palette/flutter_palette.dart';
import 'package:provider/provider.dart';

import 'config.dart';

final appBarItems = <_AppBarItem>[
  _AppBarItem(
    'Refresh',
    (context) => context.read<HrvApi>().updateCart(),
  ),
  _AppBarItem(
    'HTTP requests',
    (context) => context.read<Alice>().showInspector(),
  ),
  _AppBarItem(
    'Reset',
    (context) => Navigator.pushReplacement(context,
        PageRouteBuilder(pageBuilder: (_, __, ___) => const OutfitTest())),
  ),
];

class OutfitTest extends StatelessWidget {
  const OutfitTest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pallete = ColorPalette.adjacent(
      Theme.of(context).primaryColor,
      numberOfColors: config.outfits.length,
    );

    return Provider(
      create: (_) => HrvApi(config),
      builder: (_, __) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Outfit Test'),
            actions: [
              Builder(
                builder: (context) => PopupMenuButton<String>(
                  onSelected: (id) =>
                      appBarItems[int.parse(id)].onSelected(context),
                  itemBuilder: (_) => appBarItems
                      .asMap()
                      .map((key, value) => MapEntry(
                            key,
                            PopupMenuItem(
                              value: key.toString(),
                              child: Text(value.label),
                            ),
                          ))
                      .values
                      .toList(growable: false),
                ),
              ),
            ],
          ),
          body: ListView(
            children: [
              const CartWidget(),
              ...config.outfits
                  .asMap()
                  .map((i, outfit) => MapEntry(
                      i,
                      _AddOutfit(
                        color: pallete.elementAt(i).withOpacity(.1),
                        name: 'Outfit ${i + 1}',
                        outfit: outfit,
                      )))
                  .values,
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: _Jquery(),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AddOutfit extends StatelessWidget {
  final Color color;
  final String name;
  final List<int> outfit;

  const _AddOutfit({
    required this.color,
    required this.name,
    required this.outfit,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Text(
                  name,
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
            ),
            ...outfit.map(
              (id) => Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: AddToCartButton(
                    id: id,
                    outfitAdd: outfit,
                  ),
                ),
              ),
            ),
          ]),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: AddToCartButton(
                    outfitAdd: outfit,
                    text: 'quantity++',
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: AddToCartButton(
                    outfitRemove: outfit,
                    text: 'quantity--',
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: AddToCartButton(
                    outfitDrop: outfit,
                    text: 'quantity=0',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AppBarItem {
  final String label;
  final void Function(BuildContext) onSelected;

  _AppBarItem(this.label, this.onSelected);
}

class _Jquery extends StatelessWidget {
  const _Jquery({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<HrvApi>(
      builder: (_, api, __) {
        final jQuery = api.jQuery;
        return AnimatedBuilder(
          animation: jQuery,
          builder: (_, __) => InkWell(
            onTap: () async {
              await Clipboard.setData(ClipboardData(text: jQuery.value));
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Copied jQuery into clipboard')));
            },
            child: Text(
              jQuery.value,
            ),
          ),
        );
      },
    );
  }
}
