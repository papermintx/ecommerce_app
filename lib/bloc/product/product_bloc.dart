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
    on<LoadProductFromApi>(
      (event, emit) async {
        emit(ProductLoading());
        try {
          final response =
              await http.get(Uri.parse('https://fakestoreapi.com/products'));

          if (response.statusCode == 200) {
            final data = json.decode(response.body);
            final List<ProductModel> products = List<ProductModel>.from(
                data.map((i) => ProductModel.fromJson(i)));

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
      },
    );

    on<LoadProductFromDatabase>((event, emit) async {
      emit(ProductLoading());
      try {
        final dbHelper = DatabaseHelper.instance;
        final products = await dbHelper.queryAllProducts();
        List<ProductModel> data = products.map((e) {
          return ProductModel(
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
            isFavorite: e['isFavorite'] == 1 ? true : false,
          );
        }).toList();

        emit(ProductLoaded(products: data));
      } catch (e) {
        emit(ProductError(
            message: 'Gagal memuat data produk dari Database ${e.toString()}'));
      }
    });

    on<UpdateProducts>(
      (event, emit) async {
        emit(ProductLoading());
        final dbHelper = DatabaseHelper.instance;
        await dbHelper.updateProduct(event.product);
        add(LoadProductFromDatabase());
      },
    );
  }
}
