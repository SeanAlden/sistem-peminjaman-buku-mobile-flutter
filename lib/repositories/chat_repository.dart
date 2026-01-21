import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sistem_peminjaman_buku_mobile_app/const/api_url.dart';

typedef OnMessage = void Function(Map<String, dynamic>);

class ChatRepository {
  late PusherChannelsFlutter pusher;

  Future<String?> _token() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("auth_token");
  }

  Future<int?> myUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final user = jsonDecode(prefs.getString("auth_user")!);
    return user['id'];
  }

  Future<List<Map<String, dynamic>>> fetchMessages(int otherUserId) async {
    final token = await _token();
    final res = await http.get(
      Uri.parse("$baseurl/api/chat/messages/$otherUserId"),
      headers: {'Authorization': 'Bearer $token'},
    );

    final json = jsonDecode(res.body);
    return List<Map<String, dynamic>>.from(json['data']);
  }

  Future<void> sendMessage(int otherUserId, String message) async {
    final token = await _token();
    await http.post(
      Uri.parse("$baseurl/api/chat/send/$otherUserId"),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({"message": message}),
    );
  }

  Future<void> initPusher(OnMessage onMessage) async {
    final token = await _token();
    final myId = await myUserId();

    if (token == null || myId == null) return;

    pusher = PusherChannelsFlutter.getInstance();

    await pusher.init(
      apiKey: "124bce746e660c70dfb6",
      cluster: "ap1",
      authEndpoint: "$baseurl/broadcasting/auth",
      onEvent: (event) {
        if (event.eventName != "message.sent") return;
        final payload = jsonDecode(event.data);
        onMessage(payload['message']);
      },
      onAuthorizer: (channel, socketId, options) async {
        return {
          "headers": {
            "Authorization": "Bearer $token",
            "Accept": "application/json",
          }
        };
      },
    );

    await pusher.subscribe(channelName: "chat.$myId");
    await pusher.connect();
  }

  void dispose() {
    pusher.disconnect();
  }
}
