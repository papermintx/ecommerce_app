import 'package:bloc/bloc.dart';
import 'package:e_apps/database/product_databas_helper.dart';
import 'package:e_apps/models/product_model.dart';
import 'package:equatable/equatable.dart';

part 'checkout_event.dart';
part 'checkout_state.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  CheckoutBloc() : super(CheckoutInitial()) {
    on<UpdateCheckout>((event, emit) async {
      final database = DatabaseHelper.instance;
      await database
          .updateProduct(event.product.copyWith(isCart: !event.product.isCart));
    });

    on<LoadCheckoutFromDatabase>((event, emit) async {
      emit(CheckoutLoading());
      try {
        final database = DatabaseHelper.instance;
        final products = await database.queryAllProducts();
        final List<ProductModel> data = products
            .where((e) => e['isCart'] != 0)
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
        emit(CheckoutLoaded(products: data));
      } catch (e) {
        emit(CheckoutError(message: e.toString()));
      }
    });
  }
}
