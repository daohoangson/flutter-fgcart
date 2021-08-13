import 'package:cached_network_image/cached_network_image.dart';
import 'package:fgcart/hrv/api.dart';
import 'package:fgcart/hrv/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem item;

  const CartItemWidget(this.item, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final priceOriginal =
        item.priceOriginal != item.price ? '<s>${item.priceOriginal}</s> ' : '';

    return ListTile(
      title: Text(
        '${item.title} ${item.variantOptions?.join(' ')}',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: HtmlWidget('$priceOriginal${item.price} x${item.quantity}'),
      leading: item.image != null
          ? SizedBox(
              width: 50,
              child: CachedNetworkImage(
                imageUrl: item.image!,
                fit: BoxFit.contain,
              ),
            )
          : null,
      onTap: () => _openUrl(context),
    );
  }

  void _openUrl(BuildContext context) {
    final hrvConfig = context.read<HrvApi>().config;
    launch('https://${hrvConfig.domain}${item.url}');
  }
}
