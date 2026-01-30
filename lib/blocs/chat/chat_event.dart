import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class ChatStarted extends ChatEvent {
  final int otherUserId;

  const ChatStarted(this.otherUserId);

  @override
  List<Object?> get props => [otherUserId];
}

class ChatSendMessage extends ChatEvent {
  final String message;

  const ChatSendMessage(this.message);

  @override
  List<Object?> get props => [message];
}

class ChatMessageReceived extends ChatEvent {
  final Map<String, dynamic> message;

  const ChatMessageReceived(this.message);

  @override
  List<Object?> get props => [message];
}
