import 'package:bloc/bloc.dart';
import 'package:e_apps/database/product_databas_helper.dart';
import 'package:e_apps/models/product_model.dart';
import 'package:equatable/equatable.dart';

part 'favorite_event.dart';
part 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  FavoriteBloc() : super(FavoriteInitial()) {
    
    on<LoadFavoriteFromDatabase>((event, emit) async {
      try {
        final database = DatabaseHelper.instance;
        final products = await database.queryAllProducts();
        final List<ProductModel> data = products
            .where((e) => e['isFavorite'] != 0)
            .map((e) => ProductModel(
                  id: e['id'],
                  title: e['title'],
                  price: e['price'],
                  description: e['description'],
                  category: e['category'],
                  image: e['image'],
                  rating: Rating(
                    rate: e['rating_rate'],
                    count: e['rating_count'],
                  ),
                  isFavorite: e['isFavorite'] == 1,
                  isCart: e['isCart'] == 1,
                  quantity: e['quantity'],
                  isCheckout: e['isCheckout'] == 1,
                ))
            .toList();
        if (data.isEmpty) {
          emit(FavoriteEmpty());
        } else {
          emit(FavoriteLoaded(products: data));
        }
      } catch (e) {
        emit(FavoriteError(message: e.toString()));
      }
    });

    on<AddFavorite>((event, emit) async {
      final database = DatabaseHelper.instance;
      await database.updateProduct(event.product.copyWith(isFavorite: true));
      add(LoadFavoriteFromDatabase());
    });

    on<RemoveFavorite>((event, emit) async {
      final database = DatabaseHelper.instance;
      await database.updateProduct(event.product.copyWith(isFavorite: false));
      add(LoadFavoriteFromDatabase());
    });
  }
}
