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

  const ChatDetailScreen({
    super.key,
    required this.otherUserId,
    required this.otherUserName,
    this.otherUserAvatar,
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
