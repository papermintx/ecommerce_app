// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'product_bloc.dart';

@immutable
sealed class ProductEvent {}

class LoadProductFromDatabase extends ProductEvent {}

class LoadProductFromApi extends ProductEvent {}

class UpdateProducts extends ProductEvent {
  final ProductModel product;

  UpdateProducts(this.product);
}

class FilterProduct extends ProductEvent {
  final String query;

  FilterProduct(
     {
    required this.query,
  });
}
