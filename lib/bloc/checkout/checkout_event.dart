part of 'checkout_bloc.dart';

sealed class CheckoutEvent extends Equatable {
  const CheckoutEvent();

  @override
  List<Object> get props => [];
}

final class LoadCheckoutFromDatabase extends CheckoutEvent {}

final class UpdateCheckout extends CheckoutEvent {
  final ProductModel product;

  const UpdateCheckout({
    required this.product,
  });

  @override
  List<Object> get props => [product];
}
