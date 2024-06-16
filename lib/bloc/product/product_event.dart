part of 'product_bloc.dart';

@immutable
sealed class ProductEvent {}

class LoadProductFromDatabase extends ProductEvent {}

class LoadProductFromApi extends ProductEvent {}

class UpdateProducts extends ProductEvent {
  final ProductModel product;

  UpdateProducts(this.product);
}
