part of 'favorite_bloc.dart';

sealed class FavoriteEvent extends Equatable {
  const FavoriteEvent();

  @override
  List<Object> get props => [];
}

final class LoadFavoriteFromDatabase extends FavoriteEvent {}

final class AddFavorite extends FavoriteEvent {
  final ProductModel product;

  const AddFavorite({
    required this.product,
    
  });

  @override
  List<Object> get props => [product];
}

final class UpdateFavorite extends FavoriteEvent {
  final ProductModel product;

  const UpdateFavorite({
    required this.product,
  });

  @override
  List<Object> get props => [product];
}

final class RemoveFavorite extends FavoriteEvent {
  final ProductModel product;

  const RemoveFavorite({
    required this.product,
  });

  @override
  List<Object> get props => [product];
}


