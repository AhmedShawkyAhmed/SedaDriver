part of 'global_cubit.dart';

@immutable
abstract class GlobalState {}

class GlobalInitial extends GlobalState {}
class GlobalLoading extends GlobalState {}
class GlobalSuccess extends GlobalState {}
class GlobalFailure extends GlobalState {}

// class SocketLoading extends GlobalState {}
// class SocketSuccess extends GlobalState {}
// class SocketFail extends GlobalState {}

// class SocketNewMessage extends GlobalState {}
// class SocketNewMessageDone extends GlobalState {}

class ActiveLocationLoadingState extends GlobalState {}
class ActiveLocationSuccessState extends GlobalState {
  final Position position;

  ActiveLocationSuccessState(this.position);
}
class ActiveLocationProblemState extends GlobalState {}
class ActiveLocationFailureState extends GlobalState {}