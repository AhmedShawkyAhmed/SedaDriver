// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:seda_driver/src/business_logic/auth_cubit/auth_cubit.dart';
import 'package:seda_driver/src/business_logic/chat_cubit/chat_cubit.dart';
import 'package:seda_driver/src/business_logic/socket_cubit/socket_cubit.dart';
import 'package:seda_driver/src/constants/end_points.dart';
import 'package:seda_driver/src/constants/localization/app_localization.dart';
import 'package:seda_driver/src/constants/tools/log_util.dart';
import 'package:seda_driver/src/constants/tools/toast.dart';
import 'package:seda_driver/src/presentation/styles/app_colors.dart';
import 'package:seda_driver/src/presentation/views/chat_screen_views/audio_message_bubble.dart';
import 'package:seda_driver/src/presentation/views/chat_screen_views/chat_send_view.dart';
import 'package:seda_driver/src/presentation/views/chat_screen_views/text_message_bubble.dart';
import 'package:seda_driver/src/presentation/widgets/default_app_button.dart';
import 'package:seda_driver/src/presentation/widgets/default_app_text.dart';
import 'package:seda_driver/src/services/dio_helper.dart';
import 'package:sizer/sizer.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String? _path;
  Directory? directory;
  bool _recordAllowed = false;
  late int orderId;

  final List<String> _defaultMessages = [
    'I am on my way to you',
    'Where are you ?',
    'I have just arrived'
  ];

  Future<void> _getDir() async {
    directory = Directory(
      "${(await getApplicationDocumentsDirectory()).path}/Seda/Records",
    );
    if (directory?.existsSync() == false) {
      await directory?.create(recursive: true);
    }
    _path = "${directory?.path}/recording.opus";
    setState(() {});
  }

  void _requestRecordPermissions() async {
    _recordAllowed = ((await Permission.storage.request()) ==
            PermissionStatus.granted) &&
        ((await Permission.microphone.request()) == PermissionStatus.granted);
    setState(() {});

    if ((await Permission.microphone.status) != PermissionStatus.granted) {
      showToast(context.micPermissionError, ToastState.warning);
    }
    if ((await Permission.storage.status) != PermissionStatus.granted) {
      showToast(context.storagePermissionError, ToastState.warning);
    }

    if (_recordAllowed) {
      await _getDir();
    }
  }

  @override
  void initState() {
    super.initState();
    _requestRecordPermissions();
    orderId = SocketCubit.get(context).orderResponse!.orderModel!.id!;
    ChatCubit.get(context).getMessages(
      orderId: orderId,
    );
  }

  Future<File?> _downloadMedia(int orderId, int mediaId) async {
    try {
      if (directory == null) return null;
      final file = File('${directory?.path}/$orderId/$mediaId.m4a');
      if (file.existsSync()) {
        logSuccess("file: ${file.path}");
        return file;
      }
      await DioHelper.downloadMedia(
        url: 'downloadFiles',
        path: file.path,
        onReceiveProgress: showDownloadProgress,
        query: {
          "id": mediaId,
        },
      );
      logSuccess("file: ${file.path}");
      logSuccess("===============================================");
      return file;
    } on DioError catch (e) {
      logError("downloadMedia Error Response: ${e.requestOptions}");
      logError("downloadMedia Error Response: ${e.response}");
    } catch (e) {
      logError("downloadMedia Error: $e");
    }
    return null;
  }

  void showDownloadProgress(received, total) {
    if (total != -1) {
      logSuccess((received / total * 100).toStringAsFixed(0) + "%");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SocketCubit, SocketState>(
      listener: (context, state) {
        if (state is NewMessage) {
          ChatCubit.get(context).updateChatList(state.newMessage);
          SocketCubit.get(context).changeStatus();
        } else if (state is OrderCancelByUser) {
          Navigator.pop(context);
        }
      },
      child: BlocConsumer<ChatCubit, ChatState>(
        listener: (context, state) {
          if (state is MessagesSuccess && _path != null && _path!.isNotEmpty) {
            final record = File(_path!);
            if (record.existsSync()) {
              record.deleteSync();
            }
          }
        },
        builder: (context, state) {
          final cubit = ChatCubit.get(context);
          logSuccess("orderId: $orderId");
          logSuccess("roomId: ${cubit.roomId}");
          return Scaffold(
            backgroundColor: AppColors.white,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(8.h),
              child: Material(
                elevation: 2,
                child: Container(
                  padding: EdgeInsets.only(bottom: 1.h),
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          color: AppColors.darkGrey,
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            SizedBox(
                              height: 5.h,
                              width: 5.h,
                              child: Container(
                                width: 13.h,
                                height: 13.h,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.midGrey.withOpacity(0.7),
                                ),
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                child: cubit.room?.toUser?.image != null
                                    ? Image.network(
                                        "${EndPoints.imageBaseUrl}${cubit.room!.toUser!.image!}",
                                        fit: BoxFit.cover,
                                      )
                                    : const Padding(
                                        padding: EdgeInsets.all(15),
                                        child: FittedBox(
                                          child: Icon(
                                            Icons.person,
                                            color: AppColors.white,
                                            size: 65,
                                          ),
                                        ),
                                      ),
                              ),
                            ),
                            SizedBox(
                              width: 4.w,
                            ),
                            DefaultAppText(
                              text: cubit.room?.toUser?.name ?? '',
                              fontWeight: FontWeight.w500,
                              fontSize: 12.sp,
                              color: AppColors.black,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 1.h),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      margin: EdgeInsets.only(bottom: 1.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: ListView.builder(
                        reverse: true,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          final receiver = cubit.room?.toUser?.id ==
                                  AuthCubit.get(context)
                                      .currentUser
                                      ?.userBasicInfo
                                      ?.id
                              ? cubit.room?.fromUser
                              : cubit.room?.toUser;
                          final chatList = cubit.allMessages;
                          final reversedIndex = chatList.length - 1 - index;
                          return chatList[reversedIndex].medias?.type == 'audio'
                              ? FutureBuilder<File?>(
                                  key: Key("${chatList[reversedIndex].id}"),
                                  future: _downloadMedia(
                                    orderId,
                                    chatList[reversedIndex].medias!.id!,
                                  ),
                                  builder: (context, snap) {
                                    if (snap.data == null) {
                                      return const SizedBox();
                                    }
                                    return AudioMessageBubble(
                                      isLast: (chatList.lastIndexWhere(
                                              (element) =>
                                                  element.fromUserIf !=
                                                  AuthCubit.get(context)
                                                      .currentUser
                                                      ?.userBasicInfo
                                                      ?.id)) ==
                                          reversedIndex,
                                      audioMessage: snap.data!,
                                      isSender:
                                          chatList[reversedIndex].toUserId !=
                                              AuthCubit.get(context)
                                                  .currentUser
                                                  ?.userBasicInfo
                                                  ?.id,
                                      userName: receiver?.name ?? '',
                                      userImage: receiver?.image != null
                                          ? "${EndPoints.imageBaseUrl}${receiver?.image}"
                                          : '',
                                    );
                                  })
                              : TextMessageBubble(
                                  isLast: (chatList.lastIndexWhere((element) =>
                                          element.fromUserIf !=
                                          AuthCubit.get(context)
                                              .currentUser
                                              ?.userBasicInfo
                                              ?.id)) ==
                                      reversedIndex,
                                  message: chatList[reversedIndex],
                                  isSender: chatList[reversedIndex].toUserId !=
                                      AuthCubit.get(context)
                                          .currentUser
                                          ?.userBasicInfo
                                          ?.id,
                                  userName: receiver?.name ?? '',
                                  userImage: receiver?.image != null
                                      ? "${EndPoints.imageBaseUrl}${receiver?.image}"
                                      : '',
                                );
                        },
                        itemCount: cubit.allMessages.length,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 1.w),
                  height: 5.h,
                  margin: EdgeInsets.zero,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) => Material(
                      color: AppColors.transparent,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 2.w),
                        child: DefaultAppButton(
                          backgroundColor: AppColors.lightGrey,
                          width: 60.w,
                          text: _defaultMessages[index],
                          textColor: AppColors.darkGrey,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          onTap: () {
                            cubit.sendMessages(
                              message: _defaultMessages[index],
                              afterSuccess: () {},
                            );
                          },
                        ),
                      ),
                    ),
                    itemCount: _defaultMessages.length,
                  ),
                ),
                ChatSendView(
                  requestPermissions: _requestRecordPermissions,
                  recordAllowed: _recordAllowed,
                  path: _path ?? '',
                  sendMessage: ({
                    String? message,
                    bool isMedia = false,
                    String? path,
                    String? type,
                    required Function() afterSuccess,
                  }) async {
                    if (isMedia) {
                      cubit.sendMessages(
                        mediafile: path,
                        type: type,
                        fileType: type,
                        afterSuccess: afterSuccess,
                      );
                    } else {
                      await cubit.sendMessages(
                        message: message,
                        afterSuccess: afterSuccess,
                      );
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
