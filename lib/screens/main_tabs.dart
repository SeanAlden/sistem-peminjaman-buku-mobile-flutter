// import 'package:flutter/material.dart';

// class MainTabs extends StatefulWidget {
//   const MainTabs({super.key});

//   @override
//   State<MainTabs> createState() => _MainTabsState();
// }

// const Color orangeThemeColor = Color(0xFFF4511E);

// class _MainTabsState extends State<MainTabs> {
//   int _currentIndex = 0;

//   final List<Widget> _screens = const [
//     DashboardScreen(),
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
//         onTap: (index) {
//           setState(() {
//             _currentIndex = index;
//           });
//         },
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home_outlined),
//             activeIcon: Icon(Icons.home),
//             label: "Dashboard",
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

// /* ============================================
//    HALAMAN – HALAMAN KOSONG
//    ============================================ */

// class DashboardScreen extends StatelessWidget {
//   const DashboardScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Dashboard")),
//       body: const Center(
//         child: Text("Dashboard Screen"),
//       ),
//     );
//   }
// }

// class LoanScreen extends StatelessWidget {
//   const LoanScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Loan")),
//       body: const Center(
//         child: Text("Loan Screen"),
//       ),
//     );
//   }
// }

// class ChatScreen extends StatelessWidget {
//   const ChatScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Chat")),
//       body: const Center(
//         child: Text("Chat Screen"),
//       ),
//     );
//   }
// }

// class ProfileScreen extends StatelessWidget {
//   const ProfileScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Profile")),
//       body: const Center(
//         child: Text("Profile Screen"),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class MainTabs extends StatelessWidget {
  const MainTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Main Tabs"),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                
              },
            ),
          ],
        ),
        body: const Center(child: Text("Isi Tab di sini")),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 0,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Dashboard",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.book),
              label: "Loan",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              label: "Chat",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }
}
