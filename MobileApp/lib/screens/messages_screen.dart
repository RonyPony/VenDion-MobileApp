import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendion/config/app_constants.dart';
import 'package:vendion/l10n/app_localizations.dart';
import 'package:vendion/models/conversation.dart';
import 'package:vendion/providers/messages_provider.dart';
import 'package:vendion/screens/chat_screen.dart';
import 'package:vendion/widgets/drawer.dart';

class MessagesScreen extends StatefulWidget {
  static String routeName = '/messagesScreen';

  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MessagesProvider>(context, listen: false).loadConversations();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const GeneralDrawer(),
      appBar: AppBar(
        title: Text(context.l10n.t('messages')),
      ),
      body: Consumer<MessagesProvider>(
        builder: (context, provider, child) {
          if (provider.loading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (provider.error != null) {
            return _MessagesState(
              icon: Icons.wifi_off_rounded,
              text: context.l10n.t('messagesError'),
              actionText: context.l10n.t('retry'),
              onPressed: provider.loadConversations,
            );
          }

          if (provider.conversations.isEmpty) {
            return _MessagesState(
              icon: Icons.forum_outlined,
              text: context.l10n.t('emptyMessages'),
            );
          }

          return RefreshIndicator(
            onRefresh: provider.loadConversations,
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
              itemCount: provider.conversations.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(height: AppSpacing.sm),
              itemBuilder: (context, index) {
                return _ConversationTile(
                  conversation: provider.conversations[index],
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      ChatScreen.routeName,
                      arguments: provider.conversations[index].id,
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _ConversationTile extends StatelessWidget {
  const _ConversationTile({
    required this.conversation,
    required this.onTap,
  });

  final Conversation conversation;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final lastMessage = conversation.lastMessage;
    final hasUnread = conversation.unreadCount > 0;
    final theme = Theme.of(context);

    return Material(
      color: theme.cardColor,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: AppColors.primary.withValues(alpha: .15),
                child: Text(
                  conversation.sellerName.characters.first.toUpperCase(),
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            conversation.sellerName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight:
                                  hasUnread ? FontWeight.w800 : FontWeight.w600,
                            ),
                          ),
                        ),
                        Text(
                          _formatTime(lastMessage?.sentAt),
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      conversation.vehicleName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            lastMessage?.text ?? context.l10n.t('noData'),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: hasUnread
                                  ? FontWeight.w700
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                        if (hasUnread)
                          Container(
                            margin: const EdgeInsets.only(left: AppSpacing.sm),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              conversation.unreadCount.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime? date) {
    if (date == null) {
      return '';
    }

    final now = DateTime.now();
    if (now.difference(date).inDays >= 1) {
      return '${date.day}/${date.month}';
    }

    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}

class _MessagesState extends StatelessWidget {
  const _MessagesState({
    required this.icon,
    required this.text,
    this.actionText,
    this.onPressed,
  });

  final IconData icon;
  final String text;
  final String? actionText;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 72,
              color: AppColors.primary.withValues(alpha: .5),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(text, textAlign: TextAlign.center),
            if (actionText != null) ...[
              const SizedBox(height: AppSpacing.md),
              OutlinedButton(
                onPressed: onPressed,
                child: Text(actionText!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
