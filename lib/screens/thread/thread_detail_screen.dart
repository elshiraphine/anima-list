import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:anima_list/models/thread_model.dart';
import 'package:anima_list/theme/colors.dart';
import 'package:anima_list/theme/text_styles.dart';
import 'package:anima_list/services/thread_service.dart';
import 'package:intl/intl.dart';

class ThreadDetailScreen extends StatefulWidget {
  final String threadId;
  final String isLoggedIn;

  const ThreadDetailScreen({
    required this.threadId,
    required this.isLoggedIn,
    Key? key,
  }) : super(key: key);

  @override
  State<ThreadDetailScreen> createState() => _ThreadDetailScreenState();
}

class _ThreadDetailScreenState extends State<ThreadDetailScreen> {
  final ThreadService threadService = ThreadService();

  bool isLiked = false;
  int likeCounter = 0;

  @override
  void initState() {
    super.initState();
    _initializeLikeStatus();
  }

  Future<void> _initializeLikeStatus() async {
    final thread = await threadService.getThread(widget.threadId);
    setState(() {
      likeCounter = thread.likeCounter;
    });
    final isUserLiked = await threadService.isLoggedInUserUpvote(widget.threadId);
    setState(() {
      isLiked = isUserLiked;
    });
  }

  Future<void> _toggleLike() async {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;

    if (user != null) {
      if (isLiked) {
        await threadService.removeThreadUpvote(widget.threadId, user.uid);
        setState(() {
          isLiked = false;
          likeCounter--;
        });
      } else {
        await threadService.addThreadUpvote(widget.threadId, user.uid);
        setState(() {
          isLiked = true;
          likeCounter++;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discussion')
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            StreamBuilder<Map<String, dynamic>>(
              stream: threadService.getThreadAndAuthorData(widget.threadId),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final data = snapshot.data!;
                final threadData = data['threadData'];
                final userData = data['userData'];
                final Thread thread = Thread.fromDocument(threadData as Map<String, dynamic>);
                final String author = userData['username'];
                final String avatarUrl = userData['photoUrl'] ?? 'https://ui-avatars.com/api/?name=${userData['username']}&background=random&size=100';

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: const BoxDecoration(
                              color: AppColors.lightSurfaceBackgroundColor,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                thread.title,
                                style: AppTextStyles.titleMedium.copyWith(color: Colors.black87),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.lightSurfaceBackgroundColor),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(2),
                            child: Image.network(
                              avatarUrl,
                              width: 48,
                              height: 48,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      author,
                                      style: AppTextStyles.titleLarge.copyWith(
                                        color: AppColors.lightPrimaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      DateFormat('yyyy-MM-dd kk:mm').format(thread.updatedAt.toDate().toLocal()),
                                        style: AppTextStyles.bodyMedium.copyWith(
                                        color: AppColors.onLightSurfaceNonActive,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  thread.content,
                                  style: AppTextStyles.bodyMedium,
                                  textAlign: TextAlign.justify,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    if (widget.isLoggedIn == thread.userId)
                                      Text(
                                          'Edit',
                                          style: AppTextStyles.bodyMedium.copyWith(
                                              color: AppColors.lightPrimaryColor)
                                      ),
                                    const SizedBox(width: 12),
                                    GestureDetector(
                                      onTap: _toggleLike,
                                      child: Icon(
                                        isLiked ? CupertinoIcons.suit_heart_fill : CupertinoIcons.suit_heart,
                                        color: AppColors.lightPrimaryColor,
                                        size: 16,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                        likeCounter.toString(),
                                        style: AppTextStyles.bodyMedium.copyWith(
                                            color: AppColors.lightPrimaryColor)
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 16),

            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: threadService.getReplyStream(widget.threadId),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No replies'));
                  }

                  final List<DocumentSnapshot> docs = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final replyId = docs[index].id;
                      final replyData = docs[index].data() as Map<String, dynamic>?;

                      if (replyData == null) {
                        print('Reply data is null for doc id: $replyId');
                        return const ListTile(
                          title: Text('Reply data is not available'),
                        );
                      }

                      return StreamBuilder<Map<String, dynamic>>(
                        stream: threadService.getReplyAndAuthorData(widget.threadId, replyId),
                        builder: (context, authorSnapshot) {
                          if (authorSnapshot.hasError) {
                            return Center(child: Text('Error: ${authorSnapshot.error}'));
                          }

                          if (!authorSnapshot.hasData) {
                            return const Center(child: CircularProgressIndicator());
                          }

                          final data = authorSnapshot.data!;
                          final replyData = data['replyData'] as Map<String, dynamic>?;
                          final userData = data['userData'] as Map<String, dynamic>?;

                          if (replyData == null) {
                            print('Reply data is null for reply id: $replyId');
                            return const ListTile(
                              title: Text('Reply data is not available'),
                            );
                          }

                          if (userData == null) {
                            print('User data is null for user id: ${replyData['userId']}');
                            return const ListTile(
                              title: Text('User data is not available'),
                            );
                          }

                          final reply = Reply.fromDocument(replyData);
                          final String replyAuthor = userData['username'];
                          final String avatarUrl = userData['photoUrl'] ?? 'https://ui-avatars.com/api/?name=${userData['username']}&background=random&size=100';

                          return Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(2),
                                      child: Image.network(
                                        avatarUrl,
                                        width: 40,
                                        height: 40,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            replyAuthor,
                                            style: AppTextStyles.titleMedium.copyWith(
                                              color: AppColors.lightPrimaryColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            reply.reply,
                                            style: AppTextStyles.bodyMedium,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(color: AppColors.lightSurfaceBackgroundColor),
                                const SizedBox(height: 4),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}