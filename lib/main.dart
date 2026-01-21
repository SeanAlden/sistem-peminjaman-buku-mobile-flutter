// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:sistem_peminjaman_buku_mobile_app/repositories/auth_repository.dart';
// import 'package:sistem_peminjaman_buku_mobile_app/screens/chat_screen.dart';
// import 'package:sistem_peminjaman_buku_mobile_app/screens/home_screen.dart';
// import 'package:sistem_peminjaman_buku_mobile_app/screens/loan_screen.dart';
// import 'package:sistem_peminjaman_buku_mobile_app/screens/login_screen.dart';
// import 'package:sistem_peminjaman_buku_mobile_app/screens/profile_screen.dart';
// import 'package:sistem_peminjaman_buku_mobile_app/screens/register_screen.dart';

// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'blocs/auth/auth_bloc.dart';
// import 'screens/splash_screen.dart';

// void main() {
//   runApp(const MyApp());
// }

// const Color orangeThemeColor = Color(0xFFF4511E);

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   Future<bool> checkToken() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.containsKey("auth_token");
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Library App',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primaryColor: orangeThemeColor,
//         appBarTheme: const AppBarTheme(
//           backgroundColor: orangeThemeColor,
//           foregroundColor: Colors.white,
//           centerTitle: true,
//           titleTextStyle: TextStyle(
//             fontSize: 22,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//       home: MultiBlocProvider(
//         providers: [
//           BlocProvider(
//             create: (_) => AuthBloc(AuthRepository()),
//           )
//         ],
//         child: MaterialApp(
//           debugShowCheckedModeBanner: false,
//           title: 'Library App',
//           theme: ThemeData(
//             primaryColor: orangeThemeColor,
//           ),
//           home: const SplashScreen(),
//         ),
//       ),
//       routes: {
//         "/login": (_) => const LoginScreen(),
//         "/register": (_) => const RegisterScreen(),
//         "/main": (_) => const MainTabs(),
//       },
//     );
//   }
// }

// class MainTabs extends StatefulWidget {
//   const MainTabs({super.key});

//   @override
//   State<MainTabs> createState() => _MainTabsState();
// }

// class _MainTabsState extends State<MainTabs> {
//   int _currentIndex = 0;

//   final List<Widget> _screens = const [
//     HomeScreen(),
//     LoanScreen(),
//     ChatScreen(),
//     ProfileScreen(),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _screens[_currentIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _currentIndex,
//         selectedItemColor: Colors.white,
//         unselectedItemColor: Colors.orange.shade100,
//         backgroundColor: orangeThemeColor,
//         type: BottomNavigationBarType.fixed,
//         onTap: (index) => setState(() => _currentIndex = index),
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home_outlined),
//             activeIcon: Icon(Icons.home),
//             label: "Home",
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.book_outlined),
//             activeIcon: Icon(Icons.book),
//             label: "Loan",
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.chat_bubble_outline),
//             activeIcon: Icon(Icons.chat_bubble),
//             label: "Chat",
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person_outline),
//             activeIcon: Icon(Icons.person),
//             label: "Profile",
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sistem_peminjaman_buku_mobile_app/blocs/category_detail/category_detail_bloc.dart';
import 'package:sistem_peminjaman_buku_mobile_app/blocs/profile/profile_bloc.dart';

import 'package:sistem_peminjaman_buku_mobile_app/repositories/auth_repository.dart';
import 'package:sistem_peminjaman_buku_mobile_app/repositories/category_repository.dart';
import 'package:sistem_peminjaman_buku_mobile_app/repositories/book_repository.dart';
import 'package:sistem_peminjaman_buku_mobile_app/repositories/favorite_repository.dart';

import 'package:sistem_peminjaman_buku_mobile_app/blocs/auth/auth_bloc.dart';
import 'package:sistem_peminjaman_buku_mobile_app/blocs/category/category_bloc.dart';
import 'package:sistem_peminjaman_buku_mobile_app/blocs/book/book_bloc.dart';
import 'package:sistem_peminjaman_buku_mobile_app/blocs/favorite/favorite_bloc.dart';
import 'package:sistem_peminjaman_buku_mobile_app/repositories/profile_repository.dart';
import 'package:sistem_peminjaman_buku_mobile_app/screens/book_detail_screen.dart';
import 'package:sistem_peminjaman_buku_mobile_app/screens/category_detail_screen.dart';
import 'package:sistem_peminjaman_buku_mobile_app/screens/chat_list_screen.dart';
import 'package:sistem_peminjaman_buku_mobile_app/screens/edit_password_screen.dart';
import 'package:sistem_peminjaman_buku_mobile_app/screens/edit_profile_screen.dart';
import 'package:sistem_peminjaman_buku_mobile_app/screens/favorite_book_screen.dart';
import 'package:sistem_peminjaman_buku_mobile_app/services/auth_gate.dart';

import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/loan_screen.dart';
// import 'screens/chat_screen.dart';
import 'screens/profile_screen.dart';

const Color orangeThemeColor = Color(0xFFF4511E);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => AuthRepository()),
        RepositoryProvider(create: (_) => ProfileRepository()),
        RepositoryProvider(create: (_) => CategoryRepository()),
        RepositoryProvider(create: (_) => BookRepository()),
        RepositoryProvider(create: (_) => FavoriteRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(context.read<AuthRepository>()),
          ),
          BlocProvider(
            create: (context) => ProfileBloc(context.read<ProfileRepository>()),
          ),
          BlocProvider(
            create: (context) =>
                CategoryBloc(context.read<CategoryRepository>()),
          ),
          BlocProvider(
            create: (context) => BookBloc(context.read<BookRepository>()),
          ),
          BlocProvider(
            create: (context) =>
                FavoriteBloc(context.read<FavoriteRepository>()),
          ),
          BlocProvider(create: (_) => CategoryDetailBloc()),
        ],
        child: MaterialApp(
          title: 'Library App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: orangeThemeColor,
            ),
            inputDecorationTheme: InputDecorationTheme(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: orangeThemeColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
            brightness: Brightness.light,
            // primaryColor: orangeThemeColor,
            appBarTheme: const AppBarTheme(
              backgroundColor: orangeThemeColor,
              foregroundColor: Colors.white,
              centerTitle: true,
              titleTextStyle: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // home: const SplashScreen(),
          home: AuthGate(),
          routes: {
            "/login": (_) => const LoginScreen(),
            "/register": (_) => const RegisterScreen(),
            "/main": (_) => const MainTabs(),
            '/categoryDetail': (context) => const CategoryDetailScreen(),
            '/bookDetail': (context) => const BookDetailScreen(),
            '/loanScreen': (context) => const LoanScreen(),
            '/edit-profile': (context) => const EditProfileScreen(),
            '/edit-password': (context) => const EditPasswordScreen(),
            '/favorite-books': (context) => const FavoriteBookScreen(),
          },
        ),
      ),
    );
  }
}

class MainTabs extends StatefulWidget {
  const MainTabs({super.key});

  @override
  State<MainTabs> createState() => _MainTabsState();
}

class _MainTabsState extends State<MainTabs> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    LoanScreen(),
    ChatListScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.orange.shade100,
        backgroundColor: orangeThemeColor,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_outlined),
            activeIcon: Icon(Icons.book),
            label: "Loan",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            activeIcon: Icon(Icons.chat_bubble),
            label: "Chat",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
