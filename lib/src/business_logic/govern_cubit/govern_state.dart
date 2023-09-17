part of 'govern_cubit.dart';

@immutable
abstract class GovernState {}

class GovernInitial extends GovernState {}

class GovernTripCreateLoadingState extends GovernState {}

class GovernTripCreateSuccessState extends GovernState {}

class GovernTripCreateFailureState extends GovernState {}
