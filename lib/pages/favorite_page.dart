import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_apps/bloc/favorite/favorite_bloc.dart';
import 'package:e_apps/bloc/product/product_bloc.dart';
import 'package:e_apps/pages/product_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<FavoriteBloc>().add(LoadFavoriteFromDatabase());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Favorite',
          style: GoogleFonts.poppins(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<FavoriteBloc, FavoriteState>(
        listener: (context, state) {
          if (state is FavoriteError) {
            final snackBar = awesomeSnakeBare(
              'Error',
              state.message,
              ContentType.failure,
            );

            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(snackBar);
          }
        },
        builder: (context, state) {
          if (state is FavoriteLoaded) {
            return ListView.builder(
              itemCount: state.products.length,
              itemBuilder: (context, index) {
                final product = state.products[index];
                return Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                  child: Card(
                    child: ListTile(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) {
                          return ProductDetailPage(product: product);
                        }));
                      },
                      contentPadding: EdgeInsets.all(8.w),
                      leading: CachedNetworkImage(
                        imageUrl: product.image,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                      title: Text(
                        product.title,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(fontSize: 13),
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          context
                              .read<FavoriteBloc>()
                              .add(RemoveFavorite(product: product));
                          context.read<ProductBloc>().add(UpdateProducts(
                              product.copyWith(isFavorite: false)));

                          final snackBar = awesomeSnakeBare(
                            'Success',
                            'Product has been removed from favorite!',
                            ContentType.success,
                          );

                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(snackBar);
                        },
                        icon: const Icon(Icons.delete),
                      ),
                    ),
                  ),
                );
              },
            );
          }

          if (state is FavoriteEmpty) {
            return message('Favorite is empty', Ionicons.help_circle_outline);
          }

          if (state is FavoriteError) {
            return message(state.message, Ionicons.close_circle_outline);
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Center message(String message, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Colors.red,
            size: 90,
          ),
          Text(
            message,
            style: GoogleFonts.poppins(
              fontSize: 16.sp,
              // fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
