part of 'cart_bloc.dart';

sealed class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}


final class LoadCartFromDatabase extends CartEvent {}

final class AddToCart extends CartEvent {
  final ProductModel product;

  const AddToCart(this.product);

  @override
  List<Object> get props => [product];
}

final class RemoveFromCart extends CartEvent {
  final ProductModel product;

  const RemoveFromCart(this.product);

  @override
  List<Object> get props => [product];
}


final class UpdateQuantity extends CartEvent {
  final ProductModel product;
  final int quantity;

  const UpdateQuantity({
    required this.product,
    required this.quantity,
  });

  @override
  List<Object> get props => [product, quantity];
}

final class AddCheckout extends CartEvent {
  final ProductModel products;

  const AddCheckout(this.products);

  @override
  List<Object> get props => [products];
}