import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sistem_peminjaman_buku_mobile_app/blocs/book/book_bloc.dart';
import 'package:sistem_peminjaman_buku_mobile_app/blocs/book/book_event.dart';
import 'package:sistem_peminjaman_buku_mobile_app/blocs/book/book_state.dart';
import 'package:sistem_peminjaman_buku_mobile_app/blocs/category/category_bloc.dart';
import 'package:sistem_peminjaman_buku_mobile_app/blocs/category/category_event.dart';
import 'package:sistem_peminjaman_buku_mobile_app/blocs/category/category_state.dart';
import 'package:sistem_peminjaman_buku_mobile_app/blocs/favorite/favorite_bloc.dart';
import 'package:sistem_peminjaman_buku_mobile_app/blocs/favorite/favorite_event.dart';
import 'package:sistem_peminjaman_buku_mobile_app/blocs/favorite/favorite_state.dart';
import 'package:sistem_peminjaman_buku_mobile_app/blocs/profile/profile_bloc.dart';
import 'package:sistem_peminjaman_buku_mobile_app/blocs/profile/profile_state.dart';
import 'package:sistem_peminjaman_buku_mobile_app/main.dart';
import 'package:sistem_peminjaman_buku_mobile_app/screens/book_search_screen.dart';
import 'package:sistem_peminjaman_buku_mobile_app/screens/category_search_screen.dart';
import '../repositories/book_repository.dart';
import '../repositories/category_repository.dart';
import '../repositories/favorite_repository.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final BookRepository _bookRepo;
  late final CategoryRepository _categoryRepo;
  late final FavoriteRepository _favoriteRepo;

  String userName = 'Guest';
  // String? profileImage;

  @override
  void initState() {
    super.initState();
    _bookRepo = BookRepository();
    _categoryRepo = CategoryRepository();
    _favoriteRepo = FavoriteRepository();

    // Provide blocs directly here or via parent MultiBlocProvider
    // We'll create local providers using BlocProvider.value in build.
    // _loadUserAndFetch();
  }

  // Future<void> _loadUserAndFetch() async {
  //   await _loadUser();
  //   // dispatch events after a short delay to ensure Blocs are available
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     if (!mounted) return;
  //     context.read<BookBloc>().add(FetchBooksEvent());
  //     context.read<CategoryBloc>().add(FetchCategoriesEvent());
  //     context.read<FavoriteBloc>().add(FetchFavoritesEvent());
  //   });
  // }

  // Future<void> _loadUser() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final userJson = prefs.getString('auth_user');
  //   if (userJson != null) {
  //     try {
  //       final user = jsonDecode(userJson);
  //       setState(() {
  //         userName = user['name'] ?? 'Guest';
  //       });
  //     } catch (_) {}
  //   }

  //   // fetch profile image from endpoint (optional) using repository
  //   try {
  //     final token = prefs.getString('auth_token');
  //     if (token != null) {
  //       // try to call profile-image endpoint to get full S3 url
  //       final uri = Uri.parse('${BookRepository.baseUrl}/user/profile-image');
  //       final res = await _bookRepo == null
  //           ? null
  //           : await _bookRepo; // noop: placeholder to satisfy analyzer
  //     }
  //   } catch (_) {}
  // }

  // Future<void> _loadUser() async {
  //   final prefs = await SharedPreferences.getInstance();

  //   // Load user name dari local storage
  //   final userJson = prefs.getString('auth_user');
  //   if (userJson != null) {
  //     try {
  //       final user = jsonDecode(userJson);
  //       setState(() {
  //         userName = user['name'] ?? 'Guest';
  //       });
  //     } catch (_) {}
  //   }

  //   // Load profile image dari endpoint
  //   try {
  //     final token = prefs.getString('auth_token');
  //     if (token != null) {
  //       final uri =
  //           Uri.parse('${BookRepository.baseUrl}/api/user/profile-image');
  //       final res = await http.get(uri, headers: {
  //         'Authorization': 'Bearer $token',
  //       });

  //       if (res.statusCode == 200) {
  //         final data = jsonDecode(res.body);
  //         if (data['profile_image'] != null && data['profile_image'] != "") {
  //           setState(() {
  //             profileImage = data['profile_image'];
  //           });
  //         }
  //       }
  //     }
  //   } catch (_) {
  //     // jika error, biarkan profileImage tetap null
  //   }
  // }

  // Future<void> _loadUser() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final userJson = prefs.getString('auth_user');
  //   if (userJson != null) {
  //     final user = jsonDecode(userJson);

  //     setState(() {
  //       userName = user['name'] ?? 'Guest';
  //       // profileImage = user['profile_image'];
  //     });
  //   }
  // }

  Future<void> _onRefresh() async {
    context.read<BookBloc>().add(FetchBooksEvent());
    context.read<CategoryBloc>().add(FetchCategoriesEvent());
    context.read<FavoriteBloc>().add(FetchFavoritesEvent());
  }

  Widget _buildCategoryCard(dynamic item) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/categoryDetail', arguments: {
          'categoryId': item['id'],
          'categoryName': item['name'],
        });
      },
      child: Container(
        width: 110,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [BoxShadow(blurRadius: 6, color: Colors.black12)],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/default-category.png', height: 60, width: 60),
            const SizedBox(height: 8),
            Expanded(
              child: Text(
                // overflow: TextOverflow.ellipsis,
                // maxLines: 2,
                item['name'] ?? '',
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookCard(dynamic item, List<int> favoriteIds) {
    // final bool isFavorited = favoriteIds.contains((item['id'] as num).toInt());
    final bool isReserved = item['is_reserved_by_user'] == true;
    final bookId = (item['id'] as num).toInt();
    final bool isFavorited = favoriteIds.contains(bookId);

    final imageUrl = item['image_url'] as String?;
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/bookDetail',
            arguments: {'bookId': item['id']});
      },
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isReserved ? Colors.green[50] : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: isReserved ? Border.all(color: Colors.green.shade200) : null,
          boxShadow: const [BoxShadow(blurRadius: 6, color: Colors.black12)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 150,
                  width: double.infinity,
                  child: imageUrl == null || imageUrl.isEmpty
                      ? Image.asset('assets/avatar.png', fit: BoxFit.contain)
                      : Image.network(
                          imageUrl,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              Image.asset('assets/avatar.png',
                                  fit: BoxFit.contain),
                        ),
                ),
                Positioned(
                  right: 6,
                  top: 6,
                  child: GestureDetector(
                    onTap: () {
                      context.read<FavoriteBloc>().add(ToggleFavoriteEvent(
                            bookId: (item['id'] as num).toInt(),
                            currentlyFavorited: isFavorited,
                          ));
                    },
                    child: Icon(
                      isFavorited ? Icons.favorite : Icons.favorite_border,
                      color: Colors.red,
                      size: 22,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              item['title'] ?? '',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Expanded(
              child: Text(
                item['author'] ?? '',
                style: const TextStyle(fontSize: 14),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Provide repos and blocs above this screen in actual app (MultiBlocProvider).
    // For convenience, assert that required blocs already provided by parent.
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home',
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        centerTitle: true,
        backgroundColor: orangeThemeColor,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: const Color(0xFFF3F4F6), // gray-100
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                // Header user
                // Container(
                //   color: Colors.white,
                //   padding:
                //       const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                //   child: Row(
                //     children: [
                //       CircleAvatar(
                //         radius: 28,
                //         backgroundImage: profileImage != null
                //             ? NetworkImage(profileImage!)
                //             : const AssetImage('assets/profile.png')
                //                 as ImageProvider,
                //         onBackgroundImageError: (_, __) {
                //           setState(() {
                //             profileImage = null; // fallback ke default
                //           });
                //         },
                //       ),
                //       const SizedBox(width: 12),
                //       Expanded(
                //         child: Text(
                //           'Hi, $userName',
                //           style: const TextStyle(
                //               fontSize: 22, fontWeight: FontWeight.bold),
                //         ),
                //       ),
                //       GestureDetector(
                //         onTap: () => Navigator.push(
                //           context,
                //           MaterialPageRoute(
                //               builder: (context) => const BookSearchScreen()),
                //         ),
                //         child: const Icon(Icons.search, size: 28),
                //       ),
                //     ],
                //   ),
                // ),

                Container(
                  color: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: BlocBuilder<ProfileBloc, ProfileState>(
                    buildWhen: (prev, curr) => curr is ProfileLoaded,
                    builder: (context, state) {
                      if (state is ProfileLoaded) {
                        return Row(
                          children: [
                            // CircleAvatar(
                            //   radius: 28,
                            //   backgroundImage: state.profileImage != null
                            //       ? NetworkImage('https://cellar-c2.services.clever-cloud.com/book-image-bucket/profile_images/${state.profileImage}')
                            //       : const AssetImage('assets/profile.png')
                            //           as ImageProvider,
                            // ),
                            CircleAvatar(
                              radius: 28,
                              backgroundColor: Colors.grey.shade200,
                              child: ClipOval(
                                child: Image.network(
                                  // KONDISI 1
                                  state.profileImage ?? '',
                                  width: 112,
                                  height: 112,
                                  fit: BoxFit.cover,

                                  errorBuilder: (context, error, stackTrace) {
                                    // KONDISI 2
                                    return Image.network(
                                      'https://cellar-c2.services.clever-cloud.com/book-image-bucket/profile_images/${state.profileImage}',
                                      width: 112,
                                      height: 112,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        // KONDISI 3 (FINAL FALLBACK)
                                        return Image.asset(
                                          'assets/profile.png',
                                          width: 112,
                                          height: 112,
                                          fit: BoxFit.cover,
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ),

                            // CircleAvatar(
                            //   radius: 28,
                            //   backgroundColor: Colors.grey.shade200,
                            //   backgroundImage: state.profileImage != null &&
                            //           state.profileImage!.isNotEmpty
                            //       ? NetworkImage(state.profileImage!)
                            //       : const AssetImage('assets/profile.png')
                            //           as ImageProvider,
                            // ),

                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Hi, ${state.name}',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/search');
                              },
                              child: const Icon(Icons.search, size: 28),
                            ),
                          ],
                        );
                      }

                      return const SizedBox(height: 56); // placeholder
                    },
                  ),
                ),

                const SizedBox(height: 16),
                // Welcome text
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Selamat Datang!',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

                // Categories section
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Categories',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const CategorySearchScreen()),
                        ),
                        child: const Text('Search Category',
                            style: TextStyle(color: Colors.blue)),
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: 160,
                  child: BlocBuilder<CategoryBloc, CategoryState>(
                    builder: (context, state) {
                      if (state is CategoryLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is CategoryLoaded) {
                        final cats = state.categories;
                        return ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          scrollDirection: Axis.horizontal,
                          itemCount: cats.length,
                          itemBuilder: (context, index) =>
                              _buildCategoryCard(cats[index]),
                        );
                      } else if (state is CategoryError) {
                        return Center(child: Text('Error: ${state.message}'));
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                ),

                // Books section header
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Books',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const BookSearchScreen()),
                        ),
                        child: const Text('Search Book',
                            style: TextStyle(color: Colors.blue)),
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: 260,
                  child: BlocBuilder<BookBloc, BookState>(
                    builder: (context, bookState) {
                      return BlocBuilder<FavoriteBloc, FavoriteState>(
                        builder: (context, favState) {
                          List<int> favIds = [];
                          if (favState is FavoriteLoaded)
                            // favIds = favState.favoriteBookIds;
                            favIds = favState.books
                                .map<int>((b) => (b['id'] as num).toInt())
                                .toList();
                          if (bookState is BookLoading) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (bookState is BookLoaded) {
                            final books = bookState.books;
                            return ListView.builder(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              scrollDirection: Axis.horizontal,
                              itemCount: books.length,
                              itemBuilder: (context, index) {
                                return _buildBookCard(books[index], favIds);
                              },
                            );
                          } else if (bookState is BookError) {
                            return Center(
                                child: Text('Error: ${bookState.message}'));
                          } else {
                            return const SizedBox.shrink();
                          }
                        },
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
