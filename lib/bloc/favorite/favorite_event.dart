part of 'favorite_bloc.dart';

@immutable
sealed class FavoriteEvent {}

final class LoadFavorite extends FavoriteEvent {}

final class AddFavorite extends FavoriteEvent {
  final ProductModel product;

  AddFavorite({required this.product});
}

final class RemoveFavorite extends FavoriteEvent {
  final ProductModel product;

  RemoveFavorite({required this.product});
}
