import 'package:e_apps/bloc/auth/authentication_bloc.dart';
import 'package:e_apps/bloc/cart/cart_bloc.dart';
import 'package:e_apps/bloc/checkout/checkout_bloc.dart';
import 'package:e_apps/bloc/favorite/favorite_bloc.dart';
import 'package:e_apps/bloc/product/product_bloc.dart';
import 'package:e_apps/pages/cart_page.dart';
import 'package:e_apps/pages/checkout_page.dart';
import 'package:e_apps/pages/home_page.dart';
import 'package:e_apps/pages/login_page.dart';
import 'package:e_apps/pages/profile_page.dart';
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
        BlocProvider(create: (context) => CartBloc()),
        BlocProvider(create: (context) => CheckoutBloc()),
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
            '/login': (context) => const LoginPage(),
            '/profilePage': (context) => const ProfilePage(),
            '/cart': (context) => const CartPage(),
            '/checkout': (context) => const CheckoutPage(),
          },
        ),
      ),
    );
  }
}
