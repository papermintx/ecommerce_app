import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_apps/bloc/cart/cart_bloc.dart';
import 'package:e_apps/bloc/checkout/checkout_bloc.dart';
import 'package:e_apps/pages/product_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<CartBloc>().add(LoadCartFromDatabase());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart Page'),
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartError) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Ionicons.alert_circle_outline,
                  color: Colors.red,
                  size: 90,
                ),
                SizedBox(
                  height: 3.h,
                ),
                Center(
                  child: Text(
                    state.message,
                    style: GoogleFonts.poppins(
                      fontSize: 16.sp,
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            );
          }

          if (state is CartLoaded) {
            return ListView.builder(
              itemCount: state.products.length,
              itemBuilder: (context, index) {
                final product = state.products[index];
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
                  child: Slidable(
                    endActionPane: ActionPane(
                      extentRatio: 0.25,
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (_) {
                            context
                                .read<CartBloc>()
                                .add(RemoveFromCart(product));

                            ScaffoldMessenger.of(context)
                                .showSnackBar(awesomeSnakeBare(
                              'Success',
                              'Product has been removed from cart!',
                              ContentType.success,
                            ));
                          },
                          backgroundColor: Colors.red,
                          borderRadius: BorderRadius.circular(8),
                          label: 'Delete',
                          icon: Icons.delete,
                        ),
                      ],
                    ),
                    child: Container(
                      margin: EdgeInsets.only(right: 4.w, left: 4.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 7,
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailPage(
                                product: product,
                              ),
                            ),
                          );
                        },
                        child: Row(
                          children: <Widget>[
                            Checkbox(
                              value: product.isCheckout,
                              onChanged: (value) {
                                context
                                    .read<CartBloc>()
                                    .add(AddCheckout(product));
                              },
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10.w, vertical: 8.h),
                              child: CachedNetworkImage(
                                imageUrl: product.image,
                                width: 100.w,
                                height: 80.h,
                                fit: BoxFit.fill,
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      product.title,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'price: ${product.price.toString()}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              context.read<CartBloc>().add(
                                                  UpdateQuantity(
                                                      product: product,
                                                      quantity:
                                                          product.quantity -
                                                              1));
                                            },
                                            icon: const Icon(Icons.remove)),
                                        SizedBox(
                                          width: 10.w,
                                        ),
                                        Text(product.quantity.toString()),
                                        SizedBox(
                                          width: 10.w,
                                        ),
                                        IconButton(
                                            onPressed: () {
                                              context.read<CartBloc>().add(
                                                  UpdateQuantity(
                                                      product: product,
                                                      quantity:
                                                          product.quantity +
                                                              1));
                                            },
                                            icon: const Icon(Icons.add)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
      bottomNavigationBar: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoaded) {
            double totalPrice = 0;

            final data = state.products.where((element) => element.isCheckout);

            if (data.isEmpty) {
              return const SizedBox.shrink();
            }

            for (var item in data) {
              totalPrice += item.price * item.quantity;
            }

            return state.products.isNotEmpty
                ? Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {},
                            child: Text('Checkout \$$totalPrice'),
                          ),
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink();
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
