import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_apps/bloc/auth/authentication_bloc.dart';
import 'package:e_apps/bloc/favorite/favorite_bloc.dart';
import 'package:e_apps/bloc/product/product_bloc.dart';
import 'package:e_apps/pages/product_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late bool isFavorite;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<ProductBloc>().add(LoadProductFromApi());
    context.read<AuthenticationBloc>().add(LoadUserData());
  }

  List<String> favoriteList = [
    "All",
    "Favorite",
    "electronics",
    "jewelery",
    "men's clothing",
    "women's clothing"
  ];

  String query = 'All';
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Home',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 16.sp,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pushNamed(context, '/profilePage');
          },
          icon: const Icon(
            Ionicons.person_circle_outline,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/cart');
            },
            icon: const Icon(
              Ionicons.cart,
              color: Colors.white,
            ),
          ),
        ],
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.purple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is ProductError) {
            return Center(
              child: Text(state.message),
            );
          }

          if (state is ProductLoaded) {
            return Column(
              children: [
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: favoriteList.map((e) {
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          child: ElevatedButton(
                            onPressed: () {
                              context.read<ProductBloc>().add(
                                    FilterProduct(
                                      query: e,
                                    ),
                                  );
                              query = e;
                              currentIndex = favoriteList.indexOf(e);
                            },
                            child: Text(
                              e,
                              style: GoogleFonts.poppins(
                                  color: Colors.purple,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                if (state.products.isEmpty && query == 'Favorite')
                  Column(
                    children: [
                      SizedBox(height: 100.h),
                      Icon(
                        Ionicons.help_circle_outline,
                        color: Colors.red,
                        size: 100.sp,
                      ),
                      SizedBox(height: 8.h),
                      Center(
                        child: Text(
                          'No Favorite Product Found!',
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  Expanded(
                    child: GridView.builder(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisSpacing: 8.h,
                        crossAxisSpacing: 8.w,
                        childAspectRatio: 1.6 / 1.8,
                        crossAxisCount: 2,
                      ),
                      itemCount: state.products.length,
                      itemBuilder: (context, index) {
                        final product = state.products[index];

                        return Stack(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ProductDetailPage(product: product),
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.grey.withOpacity(0.6),
                                      width: 4),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  children: <Widget>[
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: CachedNetworkImage(
                                          imageUrl: product.image,
                                          fit: BoxFit.fill,
                                          placeholder: (context, url) =>
                                              const Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16.w, vertical: 8.h),
                                      decoration: const BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                              color: Color.fromARGB(
                                                  255, 160, 66, 177),
                                              blurRadius: 5,
                                              offset: Offset(0, 2)),
                                        ],
                                        borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(5),
                                            bottomRight: Radius.circular(5)),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            product.title,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontSize: 12.sp,
                                            ),
                                          ),
                                          Text(
                                            '\$${product.price}',
                                            style: GoogleFonts.poppins(
                                              color: Colors.blue,
                                              fontSize: 10.sp,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: IconButton(
                                onPressed: () {
                                  context.read<FavoriteBloc>().add(
                                        UpdateFavorite(product: product),
                                      );
                                  context.read<ProductBloc>().add(
                                        LoadProductFromDatabase(query: query),
                                      );
                                },
                                icon: Icon(
                                  product.isFavorite
                                      ? Ionicons.heart
                                      : Ionicons.heart_outline,
                                  color: product.isFavorite
                                      ? Colors.red
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
