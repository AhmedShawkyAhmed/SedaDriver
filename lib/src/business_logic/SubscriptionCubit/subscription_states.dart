part of 'subscription_cubit.dart';

abstract class SubscriptionStates {}

class SubscriptionInitial extends SubscriptionStates {}

class GetSubscriptionLoading extends SubscriptionStates {}

class GetSubscriptionSuccess extends SubscriptionStates {}

class GetSubscriptionFailed extends SubscriptionStates {}

class SubscriptionLoading extends SubscriptionStates {}

class SubscriptionSuccess extends SubscriptionStates {}

class SubscriptionFailed extends SubscriptionStates {}

class CheckSubscriptionLoading extends SubscriptionStates {}

class CheckSubscriptionSuccess extends SubscriptionStates {}

class CheckSubscriptionFailed extends SubscriptionStates {}
