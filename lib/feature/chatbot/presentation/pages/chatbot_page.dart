import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/locale/app_strings.dart';
import '../../../../app/locale/locale_state.dart';
import '../../../../app/locale/locale_view_model.dart';
import '../../../../app/theme/app_colors.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../state/chatbot_state.dart';
import '../view_model/chatbot_view_model.dart';

class ChatbotPage extends ConsumerStatefulWidget {
  const ChatbotPage({super.key});

  @override
  ConsumerState<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends ConsumerState<ChatbotPage> {
  final _inputCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(chatbotViewModelProvider.notifier).loadHistory());
  }

  @override
  void dispose() {
    _inputCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (!_scrollCtrl.hasClients) return;
      _scrollCtrl.animateTo(
        _scrollCtrl.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> _send() async {
    final text = _inputCtrl.text;
    if (text.trim().isEmpty) return;
    _inputCtrl.clear();
    await ref.read(chatbotViewModelProvider.notifier).sendMessage(text);
    _scrollToBottom();
  }

  Future<void> _confirmClear(AppLanguage lang) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(AppStrings.get('clearChat', lang)),
        content: Text(AppStrings.get('clearChatConfirm', lang)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(AppStrings.get('cancel', lang)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(AppStrings.get('clearChat', lang), style: const TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(chatbotViewModelProvider.notifier).clearChat();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(chatbotViewModelProvider);
    final lang = ref.watch(localeViewModelProvider).language;

    ref.listen(chatbotViewModelProvider, (previous, next) {
      if (next.messages.length != previous?.messages.length) _scrollToBottom();
    });

    return Scaffold(
      backgroundColor: context.appBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.primary,
              child: const Icon(Icons.coffee, size: 18, color: Colors.white),
            ),
            const SizedBox(width: 10),
            Text(
              AppStrings.get('coffeeAssistant', lang),
              style: const TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w800,
                fontSize: 16,
                color: AppColors.primaryDark,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_outline, color: state.messages.isEmpty ? context.appTextMuted : AppColors.error),
            onPressed: state.messages.isEmpty ? null : () => _confirmClear(lang),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: _buildMessageList(state, lang)),
            _buildInputBar(state, lang),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageList(ChatbotState state, AppLanguage lang) {
    if (state.status == ChatbotStatus.loading && state.messages.isEmpty) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primary));
    }

    if (state.status == ChatbotStatus.error && state.messages.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                state.errorMessage ?? AppStrings.get('somethingWentWrong', lang),
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: 'Montserrat', color: context.appTextSecondary),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => ref.read(chatbotViewModelProvider.notifier).loadHistory(),
                child: Text(AppStrings.get('retry', lang)),
              ),
            ],
          ),
        ),
      );
    }

    if (state.messages.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.coffee, size: 32, color: AppColors.primary),
              ),
              const SizedBox(height: 16),
              Text(
                AppStrings.get('askMeAnythingCoffee', lang),
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: 'Montserrat', fontSize: 13, color: context.appTextSecondary),
              ),
            ],
          ),
        ),
      );
    }

    final isSending = state.status == ChatbotStatus.sending;
    final itemCount = state.messages.length + (isSending ? 1 : 0);

    return ListView.builder(
      controller: _scrollCtrl,
      padding: const EdgeInsets.all(16),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        if (isSending && index == itemCount - 1) {
          return _buildTypingBubble();
        }
        return _buildBubble(state.messages[index]);
      },
    );
  }

  Widget _buildBubble(ChatMessageEntity message) {
    final isUser = message.role == ChatRole.user;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: isUser ? AppColors.primary : context.appSurface,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(14),
            topRight: const Radius.circular(14),
            bottomLeft: Radius.circular(isUser ? 14 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 14),
          ),
          boxShadow: isUser
              ? null
              : [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6, offset: const Offset(0, 2))],
        ),
        child: Text(
          message.content,
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 14,
            height: 1.4,
            color: isUser ? Colors.white : context.appTextPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildTypingBubble() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: context.appSurface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(14),
            topRight: Radius.circular(14),
            bottomRight: Radius.circular(14),
            bottomLeft: Radius.circular(4),
          ),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6, offset: const Offset(0, 2))],
        ),
        child: const SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
        ),
      ),
    );
  }

  Widget _buildInputBar(ChatbotState state, AppLanguage lang) {
    final isSending = state.status == ChatbotStatus.sending;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Container(
                constraints: const BoxConstraints(maxHeight: 120),
                decoration: BoxDecoration(
                  color: context.appSurface,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: context.appBorder),
                ),
                child: TextField(
                  controller: _inputCtrl,
                  maxLines: 4,
                  minLines: 1,
                  textCapitalization: TextCapitalization.sentences,
                  style: TextStyle(fontFamily: 'Montserrat', fontSize: 14, color: context.appTextPrimary),
                  decoration: InputDecoration(
                    hintText: AppStrings.get('typeYourMessage', lang),
                    hintStyle: TextStyle(fontFamily: 'Montserrat', fontSize: 14, color: context.appTextSecondary),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  ),
                  onSubmitted: (_) => _send(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: isSending ? null : _send,
              child: Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: isSending ? context.appBorder : AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.arrow_upward_rounded, color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
