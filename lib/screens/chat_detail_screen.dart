// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:sistem_peminjaman_buku_mobile_app/const/api_url.dart';
// // import 'package:intl/intl.dart'; // Opsional: Gunakan jika ingin format tanggal yang lebih kompleks

// class ChatDetailScreen extends StatefulWidget {
//   final int otherUserId;
//   final String otherUserName;
//   final String? otherUserAvatar;

//   const ChatDetailScreen({
//     super.key,
//     required this.otherUserId,
//     required this.otherUserName,
//     this.otherUserAvatar,
//   });

//   @override
//   State<ChatDetailScreen> createState() => _ChatDetailScreenState();
// }

// class _ChatDetailScreenState extends State<ChatDetailScreen> {
//   List messages = [];
//   bool loading = true;
//   Timer? timer;
//   final controller = TextEditingController();
//   final scrollController = ScrollController();
//   int? myId;

//   @override
//   void initState() {
//     super.initState();
//     init();
//     timer = Timer.periodic(
//       const Duration(seconds: 1),
//       (_) => loadMessages(),
//     );
//   }

//   Future<void> init() async {
//     final prefs = await SharedPreferences.getInstance();
//     final user = jsonDecode(prefs.getString("auth_user")!);
//     myId = user['id'];
//     loadMessages();
//   }

//   Future<String?> token() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString("auth_token");
//   }

//   Future<void> loadMessages() async {
//     final t = await token();
//     if (t == null) return;

//     final res = await http.get(
//       Uri.parse("$baseurl/api/chat/messages/${widget.otherUserId}"),
//       headers: {'Authorization': 'Bearer $t'},
//     );

//     if (res.statusCode == 200) {
//       final json = jsonDecode(res.body);
//       if (!mounted) return;

//       // Cek apakah ada pesan baru sebelum set state agar tidak scroll jump terus menerus
//       // Namun untuk sederhananya, kita ikuti logic awal Anda
//       setState(() {
//         messages = json['data'];
//         loading = false;
//       });

//       // Auto scroll ke bawah hanya jika user baru masuk atau mengirim pesan
//       // (Logic scroll bisa disesuaikan kebutuhan)
//       // Future.delayed(const Duration(milliseconds: 100), () {
//       //   if (scrollController.hasClients) {
//       //     scrollController.jumpTo(scrollController.position.maxScrollExtent);
//       //   }
//       // });
//     }
//   }

//   Future<void> sendMessage() async {
//     if (controller.text.trim().isEmpty) return;
//     final t = await token();

//     await http.post(
//       Uri.parse("$baseurl/api/chat/send/${widget.otherUserId}"),
//       headers: {
//         'Authorization': 'Bearer $t',
//         'Content-Type': 'application/json'
//       },
//       body: jsonEncode({"message": controller.text.trim()}),
//     );

//     controller.clear();
//     loadMessages();

//     // Scroll ke bawah setelah kirim
//     Future.delayed(const Duration(milliseconds: 300), () {
//       if (scrollController.hasClients) {
//         scrollController.animateTo(
//           scrollController.position.maxScrollExtent,
//           duration: const Duration(milliseconds: 300),
//           curve: Curves.easeOut,
//         );
//       }
//     });
//   }

//   @override
//   void dispose() {
//     timer?.cancel();
//     scrollController.dispose();
//     controller.dispose();
//     super.dispose();
//   }

//   // Helper untuk memformat jam (HH:mm)
//   String _formatTime(String dateString) {
//     try {
//       DateTime dt = DateTime.parse(dateString);
//       String hour = dt.hour.toString().padLeft(2, '0');
//       String minute = dt.minute.toString().padLeft(2, '0');
//       return "$hour:$minute";
//     } catch (e) {
//       return "";
//     }
//   }

//   // Helper untuk memformat tanggal (dd-MM-yyyy)
//   String _formatDate(DateTime dt) {
//     return "${dt.day.toString().padLeft(2, '0')}-${dt.month.toString().padLeft(2, '0')}-${dt.year}";
//   }

//   // Helper cek apakah tanggal sama
//   bool _isSameDay(String date1, String date2) {
//     DateTime dt1 = DateTime.parse(date1);
//     DateTime dt2 = DateTime.parse(date2);
//     return dt1.year == dt2.year && dt1.month == dt2.month && dt1.day == dt2.day;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF9FAFB),
//       appBar: AppBar(
//         elevation: 3,
//         titleSpacing: 0,
//         title: Row(
//           children: [
//             CircleAvatar(
//               backgroundImage: widget.otherUserAvatar != null
//                   ? NetworkImage(
//                       "https://cellar-c2.services.clever-cloud.com/book-image-bucket/${widget.otherUserAvatar}")
//                   : const AssetImage("assets/profile.png") as ImageProvider,
//             ),
//             const SizedBox(width: 10),
//             Text(widget.otherUserName),
//           ],
//         ),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: loading
//                 ? const Center(child: CircularProgressIndicator())
//                 : ListView.builder(
//                     controller: scrollController,
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 10, vertical: 20),
//                     itemCount: messages.length,
//                     itemBuilder: (_, i) {
//                       final msg = messages[i];
//                       final isMe = msg['from_id'] == myId;

//                       // Logic Tanggal: Cek pesan sebelumnya
//                       bool showDateHeader = false;
//                       if (i == 0) {
//                         showDateHeader = true;
//                       } else {
//                         final prevMsg = messages[i - 1];
//                         if (!_isSameDay(
//                             msg['created_at'], prevMsg['created_at'])) {
//                           showDateHeader = true;
//                         }
//                       }

//                       return Column(
//                         children: [
//                           // 1. TAMPILKAN TANGGAL JIKA HARI BERBEDA
//                           if (showDateHeader)
//                             Container(
//                               margin: const EdgeInsets.symmetric(vertical: 15),
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 12, vertical: 4),
//                               decoration: BoxDecoration(
//                                 color: Colors.grey[300],
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               child: Text(
//                                 _formatDate(DateTime.parse(msg['created_at'])),
//                                 style: const TextStyle(
//                                     fontSize: 11, color: Colors.black54),
//                               ),
//                             ),

//                           // 2. TAMPILKAN BUBBLE CHAT + WAKTU
//                           Padding(
//                             padding: const EdgeInsets.symmetric(vertical: 4),
//                             child: Row(
//                               mainAxisAlignment: isMe
//                                   ? MainAxisAlignment.end
//                                   : MainAxisAlignment.start,
//                               crossAxisAlignment: CrossAxisAlignment
//                                   .end, // Agar waktu sejajar dengan bawah bubble
//                               children: [
//                                 // Waktu di Kiri (Jika bukan saya / Incoming message) - Opsional
//                                 // Jika ingin waktu selalu di sisi dalam, logicnya berbeda.
//                                 // Di sini saya taruh waktu di sisi "Ekor" pesan.

//                                 if (isMe) ...[
//                                   // Waktu untuk pesan Saya (di sebelah kiri bubble)
//                                   Padding(
//                                     padding: const EdgeInsets.only(
//                                         right: 4, bottom: 2),
//                                     child: Text(
//                                       _formatTime(msg['created_at']),
//                                       style: const TextStyle(
//                                           fontSize: 10, color: Colors.grey),
//                                     ),
//                                   ),
//                                 ],

//                                 // BUBBLE CHAT
//                                 Flexible(
//                                   child: Container(
//                                     constraints: BoxConstraints(
//                                       maxWidth:
//                                           MediaQuery.of(context).size.width *
//                                               0.75, // Maksimal 75% lebar layar
//                                     ),
//                                     padding: const EdgeInsets.symmetric(
//                                         horizontal: 14, vertical: 10),
//                                     decoration: BoxDecoration(
//                                       color: isMe
//                                           ? const Color(0xFF23B882)
//                                           : const Color(0xFFE5E7EB),
//                                       // Membuat sudut bubble lebih dinamis
//                                       borderRadius: BorderRadius.only(
//                                         topLeft: const Radius.circular(16),
//                                         topRight: const Radius.circular(16),
//                                         bottomLeft: isMe
//                                             ? const Radius.circular(16)
//                                             : const Radius.circular(4),
//                                         bottomRight: isMe
//                                             ? const Radius.circular(4)
//                                             : const Radius.circular(16),
//                                       ),
//                                     ),
//                                     child: Text(
//                                       msg['body'],
//                                       style: TextStyle(
//                                         color: isMe
//                                             ? Colors.white
//                                             : Colors.black87,
//                                         fontSize: 15,
//                                       ),
//                                     ),
//                                   ),
//                                 ),

//                                 if (!isMe) ...[
//                                   // Waktu untuk pesan Orang Lain (di sebelah kanan bubble)
//                                   Padding(
//                                     padding: const EdgeInsets.only(
//                                         left: 4, bottom: 2),
//                                     child: Text(
//                                       _formatTime(msg['created_at']),
//                                       style: const TextStyle(
//                                           fontSize: 10, color: Colors.grey),
//                                     ),
//                                   ),
//                                 ],
//                               ],
//                             ),
//                           ),
//                         ],
//                       );
//                     },
//                   ),
//           ),

//           // INPUT FIELD AREA
//           Container(
//             padding: const EdgeInsets.all(10),
//             color: Colors.white,
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: controller,
//                     decoration: InputDecoration(
//                       hintText: "Type a message...",
//                       contentPadding: const EdgeInsets.symmetric(
//                           horizontal: 20, vertical: 10),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(30),
//                         borderSide: const BorderSide(color: Colors.grey),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(30),
//                         borderSide: BorderSide(color: Colors.grey.shade300),
//                       ),
//                       filled: true,
//                       fillColor: Colors.grey.shade50,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 InkWell(
//                   onTap: sendMessage,
//                   child: Container(
//                     padding: const EdgeInsets.all(12),
//                     decoration: const BoxDecoration(
//                       color: Colors.orange,
//                       shape: BoxShape.circle,
//                     ),
//                     child:
//                         const Icon(Icons.send, color: Colors.white, size: 20),
//                   ),
//                 )
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:sistem_peminjaman_buku_mobile_app/const/api_url.dart';

// class ChatDetailScreen extends StatefulWidget {
//   final int otherUserId;
//   final String otherUserName;
//   final String? otherUserAvatar;

//   const ChatDetailScreen({
//     super.key,
//     required this.otherUserId,
//     required this.otherUserName,
//     this.otherUserAvatar,
//   });

//   @override
//   State<ChatDetailScreen> createState() => _ChatDetailScreenState();
// }

// class _ChatDetailScreenState extends State<ChatDetailScreen> {
//   final List messages = [];
//   final controller = TextEditingController();
//   final scrollController = ScrollController();

//   late PusherChannelsFlutter pusher;
//   int? myId;

//   @override
//   void initState() {
//     super.initState();
//     _initUser();
//     _initPusher();
//     _loadInitialMessages();
//   }

//   Future<void> _initUser() async {
//     final prefs = await SharedPreferences.getInstance();
//     final user = jsonDecode(prefs.getString("auth_user")!);
//     myId = user['id'];
//   }

//   Future<String?> _token() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString("auth_token");
//   }

//   // 🔹 LOAD CHAT PERTAMA KALI
//   Future<void> _loadInitialMessages() async {
//     final t = await _token();
//     if (t == null) return;

//     final res = await http.get(
//       Uri.parse("$baseurl/api/chat/messages/${widget.otherUserId}"),
//       headers: {'Authorization': 'Bearer $t'},
//     );

//     if (res.statusCode == 200) {
//       final json = jsonDecode(res.body);
//       setState(() => messages.addAll(json['data']));
//       _scrollBottom();
//     }
//   }

//   // 🔥 INIT PUSHER
//   Future<void> _initPusher() async {
//     final token = await _token();
//     if (token == null) return;

//     pusher = PusherChannelsFlutter.getInstance();

//     await pusher.init(
//       apiKey: "124bce746e660c70dfb6",
//       cluster: "ap1",
//       onEvent: _onPusherEvent,
//       authEndpoint: "$baseurl/broadcasting/auth",
//       onAuthorizer: (channelName, socketId, options) async {
//         return {
//           "headers": {
//             "Authorization": "Bearer $token",
//             "Accept": "application/json",
//           }
//         };
//       },
//     );

//     // 🔹 PRIVATE CHANNEL USER
//     await pusher.subscribe(
//       channelName: "private-chat.$myId",
//     );

//     await pusher.connect();
//   }

//   // 🔔 EVENT DARI PUSHER
//   void _onPusherEvent(PusherEvent event) {
//     if (event.eventName != "message.sent") return;

//     final data = jsonDecode(event.data);
//     setState(() => messages.add(data));
//     _scrollBottom();
//   }

//   // 📩 SEND MESSAGE
//   Future<void> sendMessage() async {
//     if (controller.text.trim().isEmpty) return;

//     final t = await _token();
//     await http.post(
//       Uri.parse("$baseurl/api/chat/send/${widget.otherUserId}"),
//       headers: {
//         'Authorization': 'Bearer $t',
//         'Content-Type': 'application/json',
//       },
//       body: jsonEncode({"message": controller.text.trim()}),
//     );

//     controller.clear();
//   }

//   void _scrollBottom() {
//     Future.delayed(const Duration(milliseconds: 100), () {
//       if (scrollController.hasClients) {
//         scrollController.animateTo(
//           scrollController.position.maxScrollExtent,
//           duration: const Duration(milliseconds: 300),
//           curve: Curves.easeOut,
//         );
//       }
//     });
//   }

//   @override
//   void dispose() {
//     pusher.disconnect();
//     controller.dispose();
//     scrollController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF9FAFB),
//       appBar: AppBar(
//         title: Row(
//           children: [
//             CircleAvatar(
//               backgroundImage: widget.otherUserAvatar != null
//                   ? NetworkImage(
//                       "https://cellar-c2.services.clever-cloud.com/book-image-bucket/${widget.otherUserAvatar}")
//                   : const AssetImage("assets/profile.png") as ImageProvider,
//             ),
//             const SizedBox(width: 10),
//             Text(widget.otherUserName),
//           ],
//         ),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               controller: scrollController,
//               padding: const EdgeInsets.all(12),
//               itemCount: messages.length,
//               itemBuilder: (_, i) {
//                 final msg = messages[i];
//                 final isMe = msg['from_id'] == myId;

//                 return Align(
//                   alignment:
//                       isMe ? Alignment.centerRight : Alignment.centerLeft,
//                   child: Container(
//                     margin: const EdgeInsets.symmetric(vertical: 6),
//                     padding: const EdgeInsets.all(12),
//                     constraints: const BoxConstraints(maxWidth: 280),
//                     decoration: BoxDecoration(
//                       color: isMe
//                           ? const Color(0xFF23B882)
//                           : const Color(0xFFE5E7EB),
//                       borderRadius: BorderRadius.circular(14),
//                     ),
//                     child: Text(
//                       msg['body'],
//                       style: TextStyle(
//                         color: isMe ? Colors.white : Colors.black,
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),

//           // INPUT
//           Container(
//             padding: const EdgeInsets.all(10),
//             color: Colors.white,
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: controller,
//                     decoration: InputDecoration(
//                       hintText: "Type a message...",
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(30),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 InkWell(
//                   onTap: sendMessage,
//                   child: const CircleAvatar(
//                     backgroundColor: Colors.orange,
//                     child: Icon(Icons.send, color: Colors.white),
//                   ),
//                 )
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:sistem_peminjaman_buku_mobile_app/const/api_url.dart';
// import 'package:sistem_peminjaman_buku_mobile_app/helper/utils.dart';

// class ChatDetailScreen extends StatefulWidget {
//   final int otherUserId;
//   final String otherUserName;
//   final String? otherUserAvatar;

//   const ChatDetailScreen({
//     super.key,
//     required this.otherUserId,
//     required this.otherUserName,
//     this.otherUserAvatar,
//   });

//   @override
//   State<ChatDetailScreen> createState() => _ChatDetailScreenState();
// }

// class _ChatDetailScreenState extends State<ChatDetailScreen> {
//   final List<Map<String, dynamic>> messages = [];
//   final Set<int> messageIds = {}; // 🧠 anti-duplicate
//   final controller = TextEditingController();
//   final scrollController = ScrollController();

//   late PusherChannelsFlutter pusher;
//   int? myId;
//   bool loading = true;

//   /* ================= INIT ================= */

//   @override
//   void initState() {
//     super.initState();
//     _init();
//   }

//   Future<void> _init() async {
//     await _initUser();
//     await _loadInitialMessages();
//     await _initPusher();
//   }

//   Future<void> _initUser() async {
//     final prefs = await SharedPreferences.getInstance();
//     final user = jsonDecode(prefs.getString("auth_user")!);
//     myId = user['id'];
//   }

//   Future<String?> _token() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString("auth_token");
//   }

//   /* ================= LOAD INITIAL ================= */

//   Future<void> _loadInitialMessages() async {
//     final t = await _token();
//     if (t == null) return;

//     final res = await http.get(
//       Uri.parse("$baseurl/api/chat/messages/${widget.otherUserId}"),
//       headers: {'Authorization': 'Bearer $t'},
//     );

//     if (res.statusCode == 200) {
//       final json = jsonDecode(res.body);

//       messages.clear();
//       messageIds.clear();

//       for (final msg in json['data']) {
//         messages.add(msg);
//         messageIds.add(msg['id']);
//       }

//       setState(() => loading = false);
//       _scrollBottom(force: true);
//     }
//   }

//   /* ================= PUSHER ================= */

//   Future<void> _initPusher() async {
//     final token = await _token();
//     if (token == null || myId == null) return;

//     pusher = PusherChannelsFlutter.getInstance();

//     await pusher.init(
//       apiKey: "124bce746e660c70dfb6",
//       cluster: "ap1",
//       authEndpoint: "$baseurl/broadcasting/auth",
//       onEvent: _onPusherEvent,
//       onAuthorizer: (channel, socketId, options) async {
//         return {
//           "headers": {
//             "Authorization": "Bearer $token",
//             "Accept": "application/json",
//           }
//         };
//       },
//     );

//     await pusher.subscribe(channelName: "chat.$myId");
//     await pusher.connect();
//   }

//   void _onPusherEvent(PusherEvent event) {
//     if (event.eventName != "message.sent") return;

//     final payload = jsonDecode(event.data);
//     final msg = payload['message'];

//     if (messageIds.contains(msg['id'])) return;

//     setState(() {
//       messages.add(msg);
//       messageIds.add(msg['id']);
//     });

//     _scrollBottom();
//   }

//   /* ================= SEND ================= */

//   Future<void> sendMessage() async {
//     final text = controller.text.trim();
//     if (text.isEmpty) return;

//     controller.clear();

//     // ✅ pastikan ID bertipe int
//     final int tempId = DateTime.now().millisecondsSinceEpoch;

//     final Map<String, dynamic> tempMessage = {
//       "id": tempId,
//       "from_id": myId,
//       "body": text,
//       // "created_at": DateTime.now().toIso8601String(),
//       // "created_at" : DateTime.now().toUtc().toIso8601String(),
//       "created_at" : DateTime.now().subtract(const Duration(hours: 7)).toIso8601String(),
//     };

//     setState(() {
//       messages.add(tempMessage);
//       messageIds.add(tempId); // ✅ aman
//     });

//     _scrollBottom();

//     final t = await _token();
//     await http.post(
//       Uri.parse("$baseurl/api/chat/send/${widget.otherUserId}"),
//       headers: {
//         'Authorization': 'Bearer $t',
//         'Content-Type': 'application/json',
//       },
//       body: jsonEncode({"message": text}),
//     );
//   }

//   /* ================= UI HELPERS ================= */

//   void _scrollBottom({bool force = false}) {
//     Future.delayed(const Duration(milliseconds: 100), () {
//       if (!scrollController.hasClients) return;

//       final max = scrollController.position.maxScrollExtent;
//       final current = scrollController.offset;

//       if (force || (max - current < 200)) {
//         scrollController.animateTo(
//           max,
//           duration: const Duration(milliseconds: 300),
//           curve: Curves.easeOut,
//         );
//       }
//     });
//   }

//   @override
//   void dispose() {
//     pusher.disconnect();
//     controller.dispose();
//     scrollController.dispose();
//     super.dispose();
//   }

//   /* ================= UI ================= */

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF9FAFB),
//       appBar: AppBar(
//         title: Row(
//           children: [
//             CircleAvatar(
//               backgroundImage: widget.otherUserAvatar != null
//                   ? NetworkImage(
//                       "https://cellar-c2.services.clever-cloud.com/book-image-bucket/${widget.otherUserAvatar}")
//                   : const AssetImage("assets/profile.png") as ImageProvider,
//             ),
//             const SizedBox(width: 10),
//             Text(widget.otherUserName),
//           ],
//         ),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//               child: loading
//                   ? const Center(child: CircularProgressIndicator())
//                   :
//                   // ListView.builder(
//                   //     controller: scrollController,
//                   //     padding: const EdgeInsets.all(12),
//                   //     itemCount: messages.length,
//                   //     itemBuilder: (_, i) {
//                   //       final msg = messages[i];
//                   //       final isMe = msg['from_id'] == myId;

//                   //       return Align(
//                   //         alignment:
//                   //             isMe ? Alignment.centerRight : Alignment.centerLeft,
//                   //         child: Container(
//                   //           margin: const EdgeInsets.symmetric(vertical: 6),
//                   //           padding: const EdgeInsets.all(12),
//                   //           constraints: const BoxConstraints(maxWidth: 280),
//                   //           decoration: BoxDecoration(
//                   //             color: isMe
//                   //                 ? const Color(0xFF23B882)
//                   //                 : const Color(0xFFE5E7EB),
//                   //             borderRadius: BorderRadius.circular(14),
//                   //           ),
//                   //           child: Text(
//                   //             msg['body'],
//                   //             style: TextStyle(
//                   //               color: isMe ? Colors.white : Colors.black,
//                   //             ),
//                   //           ),
//                   //         ),
//                   //       );
//                   //     },
//                   //   ),
//                   ListView.builder(
//                       controller: scrollController,
//                       padding: const EdgeInsets.all(12),
//                       itemCount: messages.length,
//                       itemBuilder: (_, i) {
//                         final msg = messages[i];
//                         final isMe = msg['from_id'] == myId;

//                         final currentDate = formatDateWib(msg['created_at']);
//                         final prevDate = i > 0
//                             ? formatDateWib(messages[i - 1]['created_at'])
//                             : null;

//                         final showDateHeader =
//                             i == 0 || currentDate != prevDate;

//                         return Column(
//                           children: [
//                             if (showDateHeader)
//                               Padding(
//                                 padding:
//                                     const EdgeInsets.symmetric(vertical: 12),
//                                 child: Center(
//                                   child: Container(
//                                     padding: const EdgeInsets.symmetric(
//                                         horizontal: 12, vertical: 6),
//                                     decoration: BoxDecoration(
//                                       color: Colors.grey.shade300,
//                                       borderRadius: BorderRadius.circular(20),
//                                     ),
//                                     child: Text(
//                                       currentDate,
//                                       style: const TextStyle(
//                                         fontSize: 12,
//                                         color: Colors.black54,
//                                         fontWeight: FontWeight.w500,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             Align(
//                               alignment: isMe
//                                   ? Alignment.centerRight
//                                   : Alignment.centerLeft,
//                               child: Container(
//                                 margin: const EdgeInsets.symmetric(vertical: 4),
//                                 padding: const EdgeInsets.all(12),
//                                 constraints:
//                                     const BoxConstraints(maxWidth: 280),
//                                 decoration: BoxDecoration(
//                                   color: isMe
//                                       ? const Color(0xFF23B882)
//                                       : const Color(0xFFE5E7EB),
//                                   borderRadius: BorderRadius.circular(14),
//                                 ),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.end,
//                                   children: [
//                                     Text(
//                                       msg['body'],
//                                       style: TextStyle(
//                                         color:
//                                             isMe ? Colors.white : Colors.black,
//                                       ),
//                                     ),
//                                     const SizedBox(height: 4),
//                                     Text(
//                                       formatTimeWib(msg['created_at']),
//                                       style: TextStyle(
//                                         fontSize: 10,
//                                         color: isMe
//                                             ? Colors.white70
//                                             : Colors.black54,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ],
//                         );
//                       },
//                     )),

//           // INPUT
//           Container(
//             padding: const EdgeInsets.all(10),
//             color: Colors.white,
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: controller,
//                     decoration: InputDecoration(
//                       hintText: "Type a message...",
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(30),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 InkWell(
//                   onTap: sendMessage,
//                   child: const CircleAvatar(
//                     backgroundColor: Colors.orange,
//                     child: Icon(Icons.send, color: Colors.white),
//                   ),
//                 )
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sistem_peminjaman_buku_mobile_app/blocs/chat/chat_bloc.dart';
import 'package:sistem_peminjaman_buku_mobile_app/blocs/chat/chat_event.dart';
import 'package:sistem_peminjaman_buku_mobile_app/blocs/chat/chat_state.dart';
import 'package:sistem_peminjaman_buku_mobile_app/repositories/chat_repository.dart';
import 'package:sistem_peminjaman_buku_mobile_app/helper/utils.dart';

class ChatDetailScreen extends StatelessWidget {
  final int otherUserId;
  final String otherUserName;
  final String? otherUserAvatar;
  // final int myId;

  const ChatDetailScreen({
    super.key,
    required this.otherUserId,
    required this.otherUserName,
    this.otherUserAvatar,
    // required this.myId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChatBloc(
        repo: ChatRepository(),
        otherUserId: otherUserId,
      )..add(ChatStarted(otherUserId)),
      child: _ChatView(
        otherUserName: otherUserName,
        otherUserAvatar: otherUserAvatar,
      ),
    );
  }
}

/* ================= VIEW ================= */

class _ChatView extends StatefulWidget {
  final String otherUserName;
  final String? otherUserAvatar;

  const _ChatView({
    required this.otherUserName,
    this.otherUserAvatar,
  });

  @override
  State<_ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<_ChatView> {
  final controller = TextEditingController();
  final scrollController = ScrollController();

  void _scrollBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!scrollController.hasClients) return;
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: widget.otherUserAvatar != null
                  ? NetworkImage(
                      "https://cellar-c2.services.clever-cloud.com/book-image-bucket/${widget.otherUserAvatar}")
                  : const AssetImage("assets/profile.png") as ImageProvider,
            ),
            const SizedBox(width: 10),
            Expanded(child: Text(widget.otherUserName)),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocConsumer<ChatBloc, ChatState>(
              listener: (_, state) {
                if (state is ChatLoaded) _scrollBottom();
              },
              builder: (_, state) {
                if (state is ChatLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is ChatLoaded) {
                  final messages = state.messages;

                  return ListView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.all(12),
                    itemCount: messages.length,
                    itemBuilder: (_, i) {
                      final msg = messages[i];
                      // final isMe = msg['from_id'] == null;
                      final isMe = msg['from_id'] != null &&
                          msg['from_id'] == context.read<ChatBloc>().myId;
                      return Align(
                        alignment:
                            isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.all(12),
                          constraints: const BoxConstraints(maxWidth: 280),
                          decoration: BoxDecoration(
                            color: isMe
                                ? const Color(0xFF23B882)
                                : const Color(0xFFE5E7EB),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                msg['body'],
                                style: TextStyle(
                                  color: isMe ? Colors.white : Colors.black,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                formatTimeWib(msg['created_at']),
                                style: TextStyle(
                                  fontSize: 10,
                                  color: isMe ? Colors.white70 : Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }

                return const SizedBox();
              },
            ),
          ),

          /* ================= INPUT ================= */

          Container(
            padding: const EdgeInsets.all(10),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: () {
                    final text = controller.text.trim();
                    if (text.isEmpty) return;
                    controller.clear();
                    context.read<ChatBloc>().add(ChatSendMessage(text));
                  },
                  child: const CircleAvatar(
                    backgroundColor: Colors.orange,
                    child: Icon(Icons.send, color: Colors.white),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
