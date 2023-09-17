import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seda_driver/src/business_logic/app_cubit/app_cubit.dart';
import 'package:seda_driver/src/business_logic/auth_cubit/auth_cubit.dart';
import 'package:seda_driver/src/presentation/views/home_screen_views/home_connected_hidden_view.dart';
import 'package:seda_driver/src/presentation/views/home_screen_views/home_connected_vissible_view.dart';
import 'package:seda_driver/src/presentation/views/home_screen_views/home_disconnected_view.dart';
import 'package:sizer/sizer.dart';

import '../../../business_logic/SubscriptionCubit/subscription_cubit.dart';

class HomeBottomSheet extends StatefulWidget {
  const HomeBottomSheet({Key? key}) : super(key: key);

  @override
  State<HomeBottomSheet> createState() => _HomeBottomSheetState();
}

class _HomeBottomSheetState extends State<HomeBottomSheet> {
  bool _view = false;
  bool _showStop = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppCubit, AppState>(
      listener: (BuildContext context, state) {
        if (state is AppThemeUpdateState) {
          setState(() {});
        }
      },
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          final cubit = AuthCubit.get(context);
          final subscriptionCubit = SubscriptionCubit.get(context);
          return AnimatedContainer(
            onEnd: () {
              if (_view) {
                setState(() {
                  _showStop = true;
                });
              } else {
                setState(() {
                  _showStop = false;
                });
              }
            },
            duration: const Duration(milliseconds: 300),
            height: cubit.isConnected == false
                ? subscriptionCubit.subscribed &&
                        !subscriptionCubit.subscriptionStatus
                    ? 50.h
                    : 26.h
                : !_view
                    ? 26.h
                    : 53.h,
            child: cubit.isConnected == false
                ? HomeDisConnectedView(
                    connect: () {
                      cubit.toggleOnline(isOnline: true);
                    },
                  )
                : !_view
                    ? HomeConnectedVisibleView(
                        showHidden: () {
                          setState(() {
                            _view = true;
                          });
                        },
                      )
                    : HomeConnectedHiddenView(
                        showStop: _showStop,
                        disconnect: () async {
                          await cubit.toggleOnline(isOnline: false);
                          setState(() {
                            _view = false;
                          });
                        },
                        showVisible: () {
                          setState(() {
                            _view = false;
                          });
                        },
                      ),
          );
        },
      ),
    );
  }
}
