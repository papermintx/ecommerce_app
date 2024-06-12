import 'package:bloc/bloc.dart';
import 'package:e_apps/database/database_helper_favorite.dart';
import 'package:e_apps/models/product_model.dart';
import 'package:flutter/material.dart';

part 'favorite_event.dart';
part 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  FavoriteBloc() : super(FavoriteInitial()) {
    on<AddFavorite>((event, emit) async {
      emit(FavoriteLoading());
      try {
        await DatabaseHelperFavorite.instance.insert(event.product.toJson());
        final data = await DatabaseHelperFavorite.instance.queryAllRows();
        List<ProductModel> products =
            data.map((e) => ProductModel.fromJson(e)).toList();
        emit(FavoriteLoaded(products: products));
      } catch (e) {
        emit(FavoriteError(
            message: 'Gagal menambahkan produk ke favorit ${e.toString()}'));
      }
    });

    on<LoadFavorite>((event, emit) async {
      emit(FavoriteLoading());
      try {
        final data = await DatabaseHelperFavorite.instance.queryAllRows();
        List<ProductModel> products =
            data.map((e) => ProductModel.fromJson(e)).toList();

        products.isEmpty
            ? emit(FavoriteError(message: 'Tidak ada produk favorit'))
            : emit(FavoriteLoaded(products: products));
      } catch (e) {
        emit(FavoriteError(
            message: 'Gagal memuat produk favorit ${e.toString()}'));
      }
    });

    on<RemoveFavorite>((event, emit) async {
      emit(FavoriteLoading());
      try {
        await DatabaseHelperFavorite.instance.delete(event.product.id);
        final data = await DatabaseHelperFavorite.instance.queryAllRows();
        List<ProductModel> products =
            data.map((e) => ProductModel.fromJson(e)).toList();
        emit(FavoriteLoaded(products: products));
      } catch (e) {
        emit(FavoriteError(
            message: 'Gagal menghapus produk favorit ${e.toString()}'));
      }
    });
  }
}
