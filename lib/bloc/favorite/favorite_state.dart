part of 'favorite_bloc.dart';

@immutable
sealed class FavoriteState {}

final class FavoriteInitial extends FavoriteState {}

final class FavoriteLoading extends FavoriteState {}

final class FavoriteLoaded extends FavoriteState {
  final List<ProductModel> products;

  FavoriteLoaded({required this.products});
}

final class FavoriteError extends FavoriteState {
  final String message;

  FavoriteError({required this.message});
}
