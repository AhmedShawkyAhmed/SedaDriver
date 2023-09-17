part of 'orders_cubit.dart';

@immutable
abstract class OrdersState {}

class OrdersInitial extends OrdersState {}

class OrdersSendOfferLoading extends OrdersState {}

class OrdersSendOfferSuccess extends OrdersState {}

class OrdersSendOfferFail extends OrdersState {}

class OrdersAcceptLoading extends OrdersState {}

class OrdersAcceptSuccess extends OrdersState {}

class OrdersAcceptFail extends OrdersState {}

class OrdersCancelLoading extends OrdersState {}

class OrdersCancelSuccess extends OrdersState {}

class OrdersCancelFail extends OrdersState {}

class OrdersStartLoading extends OrdersState {}

class OrdersStartSuccess extends OrdersState {}

class OrdersStartFail extends OrdersState {}

class ArrivedOrderFromByDriverLoading extends OrdersState {}

class ArrivedOrderFromByDriverSuccess extends OrdersState {}

class ArrivedOrderFromByDriverFail extends OrdersState {}

class OrdersEndLoading extends OrdersState {}

class OrdersEndSuccess extends OrdersState {}

class OrdersEndFail extends OrdersState {}

class ShareTripLoading extends OrdersState {}

class ShareTripSuccess extends OrdersState {}

class ShareTripFail extends OrdersState {}

class AddMoneyToWalletLoading extends OrdersState {}

class AddMoneyToWalletSuccess extends OrdersState {}

class AddMoneyToWalletFail extends OrdersState {}

class GetOrderHistoryLoadingState extends OrdersState {}

class GetOrderHistorySuccessState extends OrdersState {}

class GetOrderHistoryProblemState extends OrdersState {}

class GetOrderHistoryFailureState extends OrdersState {}

class GetOrderDetailsLoadingState extends OrdersState {}

class GetOrderDetailsSuccessState extends OrdersState {}

class GetOrderDetailsProblemState extends OrdersState {}

class GetOrderDetailsFailureState extends OrdersState {}

class GetDriverStatisticsLoadingState extends OrdersState {}

class GetDriverStatisticsSuccessState extends OrdersState {}

class GetDriverStatisticsProblemState extends OrdersState {}

class GetDriverStatisticsFailureState extends OrdersState {}

class GetDriverEarningsLoadingState extends OrdersState {}

class GetDriverEarningsSuccessState extends OrdersState {}

class GetDriverEarningsProblemState extends OrdersState {}

class GetDriverEarningsFailureState extends OrdersState {}

class GetTodayEarningStatisticsLoadingState extends OrdersState {}

class GetTodayEarningStatisticsSuccessState extends OrdersState {}

class GetTodayEarningStatisticsProblemState extends OrdersState {}

class GetTodayEarningStatisticsFailureState extends OrdersState {}
