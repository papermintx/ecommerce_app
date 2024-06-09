import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:e_apps/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc() : super(ProductInitial()) {
    on<LoadProduct>((event, emit) async {
      emit(ProductLoading());
      try {
        final response =
            await http.get(Uri.parse('https://fakestoreapi.com/products'));

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final List<ProductModel> products = List<ProductModel>.from(
              data.map((i) => ProductModel.fromJson(i)));

          emit(ProductLoaded(products: products));
        } else {
          emit(ProductError(message: 'Server error ${response.statusCode}'));
        }
      } catch (e) {
        emit(ProductError(message: 'Gagal memuat data produk ${e.toString()}'));
      }
    });
  }
}
