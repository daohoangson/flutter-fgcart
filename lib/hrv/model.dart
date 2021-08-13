import 'package:freezed_annotation/freezed_annotation.dart';

part 'model.freezed.dart';
part 'model.g.dart';

@freezed
class Cart with _$Cart {
  factory Cart({
    @Default({}) Map<String, String> attributes,
    @Default('') String token,
    @Default(0) int itemCount,
    @Default([]) List<CartItem> items,
    @Default(0) int totalPrice,
    String? note,
  }) = _Cart;

  factory Cart.fromJson(Map<String, dynamic> json) => _$CartFromJson(json);

  Cart._();

  List<CartItemGroup> get groups {
    final result = <CartItemGroup>[];
    var others = CartItemGroup.others(items: []);

    for (final item in items) {
      final outfitId = item.properties.outfit;
      if (outfitId != null) {
        final outfitIndex = result.indexWhere(
          (element) => element.maybeMap(
            outfit: (outfit) => outfit.id == outfitId,
            orElse: () => false,
          ),
        );
        if (outfitIndex > -1) {
          final outfit = result[outfitIndex] as CartOutfit;
          result[outfitIndex] = outfit.copyWith(items: [...outfit.items, item]);
        } else {
          result.add(CartItemGroup.outfit(id: outfitId, items: [item]));
        }
      } else {
        others = others.copyWith(items: [...others.items, item]);
      }
    }

    if (others.items.isNotEmpty) {
      result.add(others);
    }

    return result;
  }
}

@freezed
class CartItem with _$CartItem {
  factory CartItem({
    required int id,
    required int priceOriginal,
    required int price,
    required int quantity,
    required CartItemProperties properties,
    required String title,
    required int productId,
    required String url,
    required int variantId,
    List<String>? variantOptions,
    String? image,
    String? sku,
    String? barcode,
  }) = _CartItem;

  factory CartItem.fromJson(Map<String, dynamic> json) =>
      _$CartItemFromJson(json);
}

@freezed
class CartItemGroup with _$CartItemGroup {
  factory CartItemGroup.outfit({
    required String id,
    required List<CartItem> items,
  }) = CartOutfit;

  factory CartItemGroup.others({
    required List<CartItem> items,
  }) = CartItems;
}

@freezed
class CartItemProperties with _$CartItemProperties {
  factory CartItemProperties({
    @JsonKey(name: 'Outfit') String? outfit,
    @JsonKey(name: 'AddOutfit') String? outfitAdd,
    @JsonKey(name: 'DropOutfit') String? outfitDrop,
    @JsonKey(name: 'RemoveOutfit') String? outfitRemove,
  }) = _CartItemProperties;

  factory CartItemProperties.fromJson(Map<String, dynamic> json) =>
      _$CartItemPropertiesFromJson(json);
}

@freezed
class AddToCartRequest with _$AddToCartRequest {
  factory AddToCartRequest({
    required int id,
    @Default(1) int quantity,
    CartItemProperties? properties,
  }) = _AddToCartRequest;

  factory AddToCartRequest.fromJson(Map<String, dynamic> json) =>
      _$AddToCartRequestFromJson(json);
}
