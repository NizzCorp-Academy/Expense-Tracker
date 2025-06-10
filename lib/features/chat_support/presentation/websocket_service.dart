import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  late WebSocketChannel _channel;
  Function(String message)? _onMessageCallback;

  void connect() {
    _channel = WebSocketChannel.connect(
      Uri.parse('wss://ws.postman-echo.com/raw'),
    );

    _channel.stream.listen(
      (message) {
        _onMessageCallback?.call(message);
      },
      onDone: () => print('🔌 WebSocket closed'),
      onError: (error) => print('❌ WebSocket error: $error'),
    );
  }

  void send(String message) {
    _channel.sink.add(message);
  }

  void disconnect() {
    _channel.sink.close();
  }

  void setOnMessageHandler(Function(String) handler) {
    _onMessageCallback = handler;
  }
}
