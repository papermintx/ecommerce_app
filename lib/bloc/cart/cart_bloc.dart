import 'package:bloc/bloc.dart';
import 'package:e_apps/database/product_databas_helper.dart';
import 'package:e_apps/models/product_model.dart';
import 'package:equatable/equatable.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartInitial()) {
    on<AddToCart>((event, emit) async {
      emit(CartLoading());
      try {
        final database = DatabaseHelper.instance;

        ProductModel product = await database.queryProduct(event.product.id);
        if (product.isCart) {
          await database.updateProduct(
              product.copyWith(isCart: true, quantity: product.quantity + 1));
        } else {
          await database
              .updateProduct(product.copyWith(isCart: true, quantity: 1));
        }
        add(LoadCartFromDatabase());
      } catch (e) {
        emit(CartError(message: e.toString()));
      }
    });

    on<RemoveFromCart>((event, emit) async {
      try {
        final database = DatabaseHelper.instance;
        await database
            .updateProduct(event.product.copyWith(isCart: false, quantity: 1));
        add(LoadCartFromDatabase());
      } catch (e) {
        emit(CartError(message: e.toString()));
      }
    });

    on<AddCheckout>((event, emit) async {
      try {
        final database = DatabaseHelper.instance;
        await database.updateProduct(
            event.products.copyWith(isCheckout: !event.products.isCheckout));
        add(LoadCartFromDatabase());
      } catch (e) {
        emit(CartError(message: e.toString()));
      }
    });

    on<LoadCartFromDatabase>((event, emit) async {
      try {
        final database = DatabaseHelper.instance;
        final products = await database.queryAllProducts();
        final List<ProductModel> data = products
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

        final cart = data.where((e) => e.isCart).toList();

        if (cart.isEmpty) {
          emit(const CartError(message: 'Cart is empty'));
          return;
        }
        emit(CartLoaded(products: cart));
      } catch (e) {
        emit(CartError(message: e.toString()));
      }
    });

    on<UpdateQuantity>((event, emit) async {
      try {
        final database = DatabaseHelper.instance;

        if (event.quantity <= 0) {
          // await database.updateProduct(
          //     event.product.copyWith(isCart: false, quantity: 1));
          // add(LoadCartFromDatabase());
          return;
        }
        await database
            .updateProduct(event.product.copyWith(quantity: event.quantity));
        add(LoadCartFromDatabase());
      } catch (e) {
        emit(CartError(message: e.toString()));
      }
    });
  }
}
