part of 'favorite_bloc.dart';

sealed class FavoriteState extends Equatable {
  const FavoriteState();

  @override
  List<Object> get props => [];
}

final class FavoriteInitial extends FavoriteState {}

final class FavoriteLoading extends FavoriteState {}

final class FavoriteLoaded extends FavoriteState {
  final List<ProductModel> products;

  const FavoriteLoaded({
    required this.products,
  });
}

final class FavoriteError extends FavoriteState {
  final String message;

  const FavoriteError({
    required this.message,
  });
}

final class FavoriteEmpty extends FavoriteState {}
