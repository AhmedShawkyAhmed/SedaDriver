part of 'socket_cubit.dart';

abstract class SocketState extends Equatable {
  const SocketState();

  @override
  List<Object> get props => [];
}

class SocketCubitInitial extends SocketState {}

class SocketLoading extends SocketState {}

class SocketNewOrder extends SocketState {}

class SocketSecondNewOrder extends SocketState {}

class SocketOrderAcceptedByDriver extends SocketState {}

class SocketArrivedOrderFromByDriver extends SocketState {}

class UserAddedDropOffArrived extends SocketArrivedOrderFromByDriver {}

class UserAddedDropOffSecondArrived extends UserAddedDropOffStarted {}

class SocketOrderStartedByDriver extends SocketState {}

class UserAddedDropOffStarted extends SocketOrderStartedByDriver {}

class UserAddedDropOffSecondStarted extends UserAddedDropOffStarted {}

class SocketNewOrderOffer extends SocketState {}

class SocketAcceptOfferByUser extends SocketState {}

class SocketNewHoursOrder extends SocketState {}

class OrderCancelByUser extends SocketState {}

class OrderSecondCancelByUser extends OrderCancelByUser {}

class AutoCancelDriver extends SocketState {}

class AutoSecondCancelDriver extends SocketState {}

abstract class NewMessage extends SocketState{
  final MessageModel newMessage;
  const NewMessage(this.newMessage);
}

class SocketNewMessageAfterArrived extends SocketArrivedOrderFromByDriver implements NewMessage {
  @override
  final MessageModel newMessage;

  SocketNewMessageAfterArrived(this.newMessage);
}

class SocketNewMessageAfterAccept extends SocketOrderAcceptedByDriver implements NewMessage {
  @override
  final MessageModel newMessage;

  SocketNewMessageAfterAccept(this.newMessage);
}

class SocketOrderAlertTimeOut extends SocketState {}

class SocketOrderGone extends SocketState {}

class SocketFailure extends SocketState {}

class GetLastOrderStatusLoading extends SocketState {}

class GetLastOrderStatusSuccess extends SocketState {}

class GetLastOrderStatusFail extends SocketState {}

class SocketTripRecording extends SocketState {}

class SendRecordLoading extends SocketState {}

class SendRecordSuccess extends SocketState {}

class SendRecordFail extends SocketState {}
