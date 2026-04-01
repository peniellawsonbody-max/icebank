import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/api_service.dart';

class AIScreen extends StatefulWidget {
  const AIScreen({super.key});

  @override
  State<AIScreen> createState() => _AIScreenState();
}

class _AIScreenState extends State<AIScreen> {
  final _messageCtrl   = TextEditingController();
  final _scrollCtrl    = ScrollController();
  bool _isLoading      = false;

  final List<Map<String, String>> _messages = [
    {
      'role':    'bot',
      'content': 'Bonjour ! Je suis IceAI, votre assistant bancaire '
          'intelligent. Je peux vous aider à analyser vos dépenses, '
          'surveiller vos cryptos, planifier vos virements ou répondre '
          'à vos questions. Comment puis-je vous aider ?',
    },
  ];

  final List<String> _suggestions = [
    '📊 Analyser mes dépenses',
    '₿ Prix Bitcoin',
    '↗ Faire un virement',
    '💡 Conseils épargne',
  ];

  @override
  void dispose() {
    _messageCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add({'role': 'user', 'content': text});
      _isLoading = true;
    });

    _messageCtrl.clear();
    _scrollToBottom();

    try {
      final response = await ApiService.post('/ai/chat', {
        'message': text,
      });

      setState(() {
        _messages.add({
          'role':    'bot',
          'content': response['reply'] ??
              'Désolé, je ne peux pas répondre pour le moment.',
        });
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _messages.add({
          'role':    'bot',
          'content': 'Erreur de connexion. Vérifiez votre réseau.',
        });
        _isLoading = false;
      });
    }

    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve:    Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header IA
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width:  44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [AppTheme.secondary, AppTheme.purple],
                      ),
                    ),
                    child: const Icon(
                      Icons.auto_awesome,
                      color: Colors.white,
                      size:  22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'IceAI Assistant',
                        style: TextStyle(
                          color:      AppTheme.textPrimary,
                          fontSize:   16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Row(
                        children: [
                          CircleAvatar(
                            radius:          4,
                            backgroundColor: AppTheme.green,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'En ligne',
                            style: TextStyle(
                              color:   AppTheme.green,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Messages
            Expanded(
              child: ListView.builder(
                controller: _scrollCtrl,
                padding:    const EdgeInsets.symmetric(horizontal: 16),
                itemCount:  _messages.length + (_isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _messages.length && _isLoading) {
                    return const _TypingIndicator();
                  }
                  final msg   = _messages[index];
                  final isBot = msg['role'] == 'bot';
                  return _MessageBubble(
                    content: msg['content']!,
                    isBot:   isBot,
                  );
                },
              ),
            ),
            // Suggestions
            if (_messages.length <= 2)
              SizedBox(
                height: 40,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _suggestions.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => _sendMessage(_suggestions[index]),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical:   8,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.card,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppTheme.primary.withOpacity(0.2),
                          ),
                        ),
                        child: Text(
                          _suggestions[index],
                          style: const TextStyle(
                            color:   AppTheme.primary,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 8),
            // Input
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageCtrl,
                      style: const TextStyle(color: AppTheme.textPrimary),
                      decoration: InputDecoration(
                        hintText:  'Posez votre question...',
                        hintStyle: const TextStyle(
                          color: AppTheme.textMuted,
                        ),
                        filled:     true,
                        fillColor:  AppTheme.card,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(
                            color: AppTheme.primary.withOpacity(0.2),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(
                            color: AppTheme.primary.withOpacity(0.2),
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical:   12,
                        ),
                      ),
                      onSubmitted: _sendMessage,
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => _sendMessage(_messageCtrl.text),
                    child: Container(
                      width:  46,
                      height: 46,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.secondary,
                      ),
                      child: const Icon(
                        Icons.send,
                        color: AppTheme.background,
                        size:  20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final String content;
  final bool isBot;

  const _MessageBubble({
    required this.content,
    required this.isBot,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isBot
          ? Alignment.centerLeft
          : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isBot
              ? AppTheme.card
              : const Color(0xFF1A3A6E),
          borderRadius: BorderRadius.only(
            topLeft:     const Radius.circular(16),
            topRight:    const Radius.circular(16),
            bottomLeft:  Radius.circular(isBot ? 4 : 16),
            bottomRight: Radius.circular(isBot ? 16 : 4),
          ),
          border: isBot
              ? Border.all(
                  color: AppTheme.primary.withOpacity(0.15),
                )
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isBot)
              const Text(
                'IceAI',
                style: TextStyle(
                  color:         AppTheme.secondary,
                  fontSize:      10,
                  fontWeight:    FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            if (isBot) const SizedBox(height: 4),
            Text(
              content,
              style: const TextStyle(
                color:      AppTheme.textPrimary,
                fontSize:   13,
                height:     1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TypingIndicator extends StatelessWidget {
  const _TypingIndicator();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin:  const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color:        AppTheme.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppTheme.primary.withOpacity(0.15),
          ),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _Dot(delay: 0),
            SizedBox(width: 4),
            _Dot(delay: 200),
            SizedBox(width: 4),
            _Dot(delay: 400),
          ],
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  final int delay;
  const _Dot({required this.delay});

  @override
  Widget build(BuildContext context) {
    return Container(
      width:  8,
      height: 8,
      decoration: const BoxDecoration(
        color: AppTheme.textMuted,
        shape: BoxShape.circle,
      ),
    );
  }
}
