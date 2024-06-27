part of 'product_bloc.dart';

@immutable
sealed class ProductState {}

final class ProductInitial extends ProductState {}

final class ProductLoading extends ProductState {}

final class ProductLoaded extends ProductState {
  final List<ProductModel> products;

  ProductLoaded({
    required this.products,
  });
}

final class LoadProductFromApiSucces extends ProductState {}

final class ProductError extends ProductState {
  final String message;
  ProductError({
    required this.message,
  });
}


final class CategoryLoaded extends ProductState {
  final List<String> categories;
  

  CategoryLoaded({
    required this.categories,
  });
}