import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seda_driver/src/constants/end_points.dart';
import 'package:seda_driver/src/constants/shared_preference_keys.dart';
import 'package:seda_driver/src/constants/tools/log_util.dart';
import 'package:seda_driver/src/models/message_model.dart';
import 'package:seda_driver/src/models/response/chat_response.dart';
import 'package:seda_driver/src/services/cache_helper.dart';
import 'package:seda_driver/src/services/dio_helper.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());

  static ChatCubit get(context) => BlocProvider.of(context);

  ChatRoom? room;
  List<MessageModel> allMessages = [];
  int? roomId;
  int? toUserId;

  updateChatList(MessageModel message) {
    allMessages.add(message);
    allMessages.sort((a, b) => a.id!.compareTo(b.id!));
    emit(MessagesSuccess());
  }

  Future getMessages({required int orderId}) async {
    logWarning("tye chat");
    logWarning(
        "token: ${CacheHelper.getDataFromSharedPreference(key: SharedPreferenceKeys.apiToken)}");
    logWarning("order: $orderId");
    emit(MessagesLoading());
    try {
      final Map<String, dynamic> queryMap = {
        "order_id": orderId,
      };
      await DioHelper.getData(url: EndPoints.getMassages, query: queryMap)
          .then((value) {
        logSuccess("GetMassages Response: $value");
        ChatResponse messagesResponse = ChatResponse.fromJson(value.data);
        allMessages.clear();
        allMessages.addAll(messagesResponse.data!.massages!);
        room = messagesResponse.data;
        roomId = messagesResponse.data!.roomId!;
        toUserId = messagesResponse.data!.toUser!.id;
        emit(MessagesSuccess());
      });
    } on DioError catch (dioError) {
      logError(dioError.toString());
      logError("GetMassages Error Response: ${dioError.response}");
      emit(MessagesFail());
    } catch (error) {
      logError("GetMassages Unknown Error: $error");
      emit(MessagesFail());
    }
  }

  Future sendMessages({
    String? message,
    String? mediafile,
    String? fileType,
    String? type,
    required Function() afterSuccess,
  }) async {
    emit(MessagesLoading());
    try {
      var formData = {
        "room_id": roomId,
        "user_id": toUserId,
        "message": message,
        'media[filename]': mediafile != null
            ? await MultipartFile.fromFile(
                mediafile,
              )
            : null,
        'media[filetype]': fileType,
        'media[type]': type,
      };
      await DioHelper.postData(
        url: EndPoints.sendMassages,
        body: formData,
        isForm: true,
      ).then((value) {
        logSuccess("SendMessage Response: $value");
        final newMessage = MessageModel.fromJson(value.data['data']["data"]);
        allMessages.add(newMessage);
        allMessages.sort((a, b) => a.id!.compareTo(b.id!));
        afterSuccess();
        emit(MessagesSuccess());
      });
    } on DioError catch (dioError) {
      logError("SendMessage Error request: ${dioError.requestOptions}");
      logError("SendMessage Error Response: ${dioError.response}");
      emit(MessagesFail());
    } catch (error) {
      logError("SendMessage Unknown Error: $error");
      emit(MessagesFail());
    }
  }
}
