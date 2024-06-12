import 'package:e_apps/bloc/auth/authentication_bloc.dart';
import 'package:e_apps/bloc/favorite/favorite_bloc.dart';
import 'package:e_apps/bloc/product/product_bloc.dart';
import 'package:e_apps/pages/favorite_page.dart';
import 'package:e_apps/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Add this import statement

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthenticationBloc(),
        ),
        BlocProvider(
          create: (context) => ProductBloc(),
        ),
        BlocProvider(create: (context) => FavoriteBloc()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          initialRoute: '/',
          routes: {
            '/': (context) => const HomePage(),
            '/favorite': (context) => const FavoritePage(),
          },
        ),
      ),
    );
  }
}
