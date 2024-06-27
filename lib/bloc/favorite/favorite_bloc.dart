import 'package:bloc/bloc.dart';
import 'package:e_apps/database/product_databas_helper.dart';
import 'package:e_apps/models/product_model.dart';
import 'package:equatable/equatable.dart';

part 'favorite_event.dart';
part 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  FavoriteBloc() : super(FavoriteInitial()) {
    on<UpdateFavorite>((event, emit) async {
      final database = DatabaseHelper.instance;
      await database.updateProduct(
          event.product.copyWith(isFavorite: !event.product.isFavorite));
    });
  }
}
