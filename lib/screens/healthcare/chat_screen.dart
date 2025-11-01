import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  void _initializeChat() {
    // Add some sample messages
    _messages.addAll([
      ChatMessage(
        message:
            "Hello! I'm your virtual health assistant. How can I help you today?",
        isFromUser: false,
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        senderName: "Health Assistant",
        senderImageUrl:
            "https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=100&h=100&fit=crop&crop=face",
      ),
      ChatMessage(
        message: "I have a question about my upcoming appointment",
        isFromUser: true,
        timestamp: DateTime.now().subtract(const Duration(minutes: 3)),
        senderName: "You",
      ),
      ChatMessage(
        message:
            "I'd be happy to help! What would you like to know about your appointment?",
        isFromUser: false,
        timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
        senderName: "Health Assistant",
        senderImageUrl:
            "https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=100&h=100&fit=crop&crop=face",
      ),
    ]);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: const DecorationImage(
                  image: NetworkImage(
                    "https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=100&h=100&fit=crop&crop=face",
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Health Assistant',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'Online now',
                  style: TextStyle(
                    color: Color(0xFF00E676),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.videocam, color: Colors.black87),
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.call, color: Colors.black87),
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _buildMessageBubble(message);
              },
            ),
          ),

          // Quick Reply Buttons
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildQuickReplyButton("Book Appointment"),
                _buildQuickReplyButton("Reschedule"),
                _buildQuickReplyButton("Cancel Appointment"),
                _buildQuickReplyButton("Find Doctor"),
                _buildQuickReplyButton("Health Tips"),
              ],
            ),
          ),

          // Message Input
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Attachment button
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.attach_file, color: Colors.grey),
                    onPressed: () {},
                  ),
                ),
                const SizedBox(width: 12),

                // Text field
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        hintText: 'Type your message...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Send button
                Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFF7B68EE),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment:
            message.isFromUser
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isFromUser) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                  image: NetworkImage(message.senderImageUrl ?? ''),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color:
                    message.isFromUser ? const Color(0xFF7B68EE) : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(message.isFromUser ? 16 : 4),
                  bottomRight: Radius.circular(message.isFromUser ? 4 : 16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.message,
                    style: TextStyle(
                      color: message.isFromUser ? Colors.white : Colors.black87,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(message.timestamp),
                    style: TextStyle(
                      color:
                          message.isFromUser
                              ? Colors.white70
                              : Colors.grey.shade500,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (message.isFromUser) ...[
            const SizedBox(width: 8),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: const Color(0xFF7B68EE),
              ),
              child: const Icon(Icons.person, color: Colors.white, size: 20),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildQuickReplyButton(String text) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: ElevatedButton(
        onPressed: () => _sendQuickReply(text),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF7B68EE),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Color(0xFF7B68EE), width: 1),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final userMessage = ChatMessage(
      message: _messageController.text.trim(),
      isFromUser: true,
      timestamp: DateTime.now(),
      senderName: "You",
    );

    setState(() {
      _messages.add(userMessage);
    });

    _messageController.clear();

    // Simulate assistant response
    Future.delayed(const Duration(seconds: 1), () {
      final assistantMessage = ChatMessage(
        message: _getAssistantResponse(userMessage.message),
        isFromUser: false,
        timestamp: DateTime.now(),
        senderName: "Health Assistant",
        senderImageUrl:
            "https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=100&h=100&fit=crop&crop=face",
      );

      setState(() {
        _messages.add(assistantMessage);
      });
    });
  }

  void _sendQuickReply(String text) {
    _messageController.text = text;
    _sendMessage();
  }

  String _getAssistantResponse(String userMessage) {
    final message = userMessage.toLowerCase();

    if (message.contains('book') || message.contains('appointment')) {
      return "I can help you book an appointment! You can browse our available doctors and schedule directly through the app. Would you like me to show you available time slots?";
    } else if (message.contains('reschedule')) {
      return "To reschedule your appointment, go to 'My Appointments' tab and select the appointment you'd like to change. You can pick a new date and time from there.";
    } else if (message.contains('cancel')) {
      return "You can cancel your appointment through the 'My Appointments' section. Is there a specific appointment you'd like to cancel?";
    } else if (message.contains('doctor') || message.contains('find')) {
      return "I can help you find the right doctor! We have specialists in Cardiology, Neurology, General Medicine, and Dental care. What type of specialist are you looking for?";
    } else if (message.contains('health') || message.contains('tips')) {
      return "Here are some quick health tips: 💡 Stay hydrated, 🥗 Eat balanced meals, 🏃‍♂️ Exercise regularly, 😴 Get enough sleep, and 🧘‍♀️ Practice stress management.";
    } else {
      return "Thank you for your message! I'm here to help with appointments, finding doctors, health tips, and any questions about our services. How can I assist you?";
    }
  }

  String _formatTime(DateTime time) {
    final hour = time.hour > 12 ? time.hour - 12 : time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}

class ChatMessage {
  final String message;
  final bool isFromUser;
  final DateTime timestamp;
  final String senderName;
  final String? senderImageUrl;

  ChatMessage({
    required this.message,
    required this.isFromUser,
    required this.timestamp,
    required this.senderName,
    this.senderImageUrl,
  });
}
