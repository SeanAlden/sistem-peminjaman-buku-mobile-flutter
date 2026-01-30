import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sistem_peminjaman_buku_mobile_app/repositories/chat_repository.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository repo;
  final int otherUserId;
  int? myId;

  final List<Map<String, dynamic>> _messages = [];
  final Set<int> _messageIds = {};

  ChatBloc({
    required this.repo,
    required this.otherUserId,
  }) : super(ChatInitial()) {
    on<ChatStarted>(_onStarted);
    on<ChatSendMessage>(_onSend);
    on<ChatMessageReceived>(_onReceive);
  }

  Future<void> _onStarted(
    ChatStarted event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());

    try {
      myId = await repo.myUserId();
      final msgs = await repo.fetchMessages(event.otherUserId);

      _messages.clear();
      _messageIds.clear();

      for (final m in msgs) {
        _messages.add(m);
        _messageIds.add(m['id']);
      }

      emit(ChatLoaded(List.from(_messages)));

      await repo.initPusher(
        (msg) => add(ChatMessageReceived(msg)),
      );
    } catch (e) {
      emit(ChatError("Failed to load chat"));
    }
  }

  Future<void> _onSend(
    ChatSendMessage event,
    Emitter<ChatState> emit,
  ) async {
    final tempId = DateTime.now().millisecondsSinceEpoch;

    final tempMessage = {
      "id": tempId,
      "from_id": myId,
      "body": event.message,
      "created_at":
          DateTime.now().subtract(const Duration(hours: 7)).toIso8601String(),
    };

    _messages.add(tempMessage);
    _messageIds.add(tempId);

    emit(ChatLoaded(List.from(_messages)));

    await repo.sendMessage(otherUserId, event.message);
  }

  void _onReceive(
    ChatMessageReceived event,
    Emitter<ChatState> emit,
  ) {
    final msg = event.message;

    if (_messageIds.contains(msg['id'])) return;

    _messages.add(msg);
    _messageIds.add(msg['id']);

    emit(ChatLoaded(List.from(_messages)));
  }

  @override
  Future<void> close() {
    repo.dispose();
    return super.close();
  }
}
