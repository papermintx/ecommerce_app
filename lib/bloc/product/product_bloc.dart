import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:e_apps/database/product_databas_helper.dart';
import 'package:e_apps/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc() : super(ProductInitial()) {
    on<LoadProductFromApi>(loadProductFromAPI);
    on<LoadProductFromDatabase>(loadProductFromDatabase);
    on<UpdateProducts>(updateProducts);
    on<FilterProduct>(filterProducts);
  }

  FutureOr<void> filterProducts(event, emit) async {
    final dbHelper = DatabaseHelper.instance;
    final products = await dbHelper.queryAllProducts();
    if (event.query == 'All') {
      add(LoadProductFromDatabase());
      return;
    }

    if (event.query == 'Favorite') {
      List<ProductModel> data = products
          .map((e) {
            return ProductModel.fromMap(e);
          })
          .where((element) => element.isFavorite)
          .toList();

      emit(ProductLoaded(products: data));
      return;
    }

    List<ProductModel> data = products
        .map((e) {
          return ProductModel.fromMap(e);
        })
        .where((element) => element.category == event.query)
        .toList();

    emit(ProductLoaded(products: data));
  }

  FutureOr<void> updateProducts(event, emit) async {
    // emit(ProductLoading());
    final dbHelper = DatabaseHelper.instance;
    await dbHelper.updateProduct(event.product);
    add(LoadProductFromDatabase(query: event.product.category));
  }

  FutureOr<void> loadProductFromDatabase(event, emit) async {
    // emit(ProductLoading());
    try {
      final dbHelper = DatabaseHelper.instance;
      final products = await dbHelper.queryAllProducts();
      List<ProductModel> data = products.map((e) {
        return ProductModel.fromMap(e);
      }).toList();
      if (event.query == "Favorite") {
        add(FilterProduct(query: "Favorite"));
      }
      if (event.query == "All") {
        emit(ProductLoaded(products: data));
        return;
      }

      if (event.query != null) {
        data = products
            .map((e) {
              return ProductModel.fromMap(e);
            })
            .where((element) => element.category == event.query)
            .toList();
      }

      emit(ProductLoaded(products: data));
    } catch (e) {
      emit(ProductError(
          message: 'Gagal memuat data produk dari Database ${e.toString()}'));
    }
  }

  FutureOr<void> loadProductFromAPI(event, emit) async {
    // emit(ProductLoading());
    try {
      final response =
          await http.get(Uri.parse('https://fakestoreapi.com/products'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        List<ProductModel> products = data.map((e) {
          return ProductModel.fromJson(e);
        }).toList();

        final dbHelper = DatabaseHelper.instance;

        for (var product in products) {
          dbHelper.insertProduct(product);
        }

        emit(LoadProductFromApiSucces());
        add(LoadProductFromDatabase());
      } else {
        emit(ProductError(message: 'Server error ${response.statusCode}'));
      }
    } catch (e) {
      emit(ProductError(
          message: 'Gagal memuat data produk dari API${e.toString()}'));
    }
  }
}
