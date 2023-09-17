part of 'wallet_cubit.dart';

abstract class WalletStates {}

class WalletInitial extends WalletStates {}

class WalletLoading extends WalletStates {}

class WalletSuccess extends WalletStates {}

class WalletFailed extends WalletStates {}

class PointsInitial extends WalletStates {}

class PointsLoading extends WalletStates {}

class PointsSuccess extends WalletStates {}

class PointsFailed extends WalletStates {}
