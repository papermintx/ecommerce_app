import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:e_apps/bloc/auth/authentication_bloc.dart';
import 'package:e_apps/pages/product_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<AuthenticationBloc>().add(LoadUserData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title:  Text('Profile', style: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              context.read<AuthenticationBloc>().add(LogOut());
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  awesomeSnakeBare(
                    'Success',
                    'Logout Success',
                    ContentType.success,
                  ),
                );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
        flexibleSpace: Container(
// Suggested code may be subject to a license. Learn more: ~LicenseLog:1872909426.
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF3366FF),
                Color(0xFF00CCFF),
              ],
            ),
          ),
        ),
      ),
      body: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is AuthSuccess) {
            context.read<AuthenticationBloc>().add(LoadUserData());
          }

          if (state is AuthUnauthenticated) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('You are not logged in'),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    child: const Text('Login'),
                  ),
                ],
              ),
            );
          }

          if (state is AuthError) {
            return Center(
              child: Text(state.message),
            );
          }

          if (state is UserLoaded) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(state.user.name),
                  Text(state.user.email),
                  Text(state.user.role),
                  Image.network(state.user.avatar),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
