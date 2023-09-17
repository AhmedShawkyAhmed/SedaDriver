import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:seda_driver/src/business_logic/SubscriptionCubit/subscription_cubit.dart';
import 'package:seda_driver/src/business_logic/app_cubit/app_cubit.dart';
import 'package:seda_driver/src/business_logic/auth_cubit/auth_cubit.dart';
import 'package:seda_driver/src/business_logic/bloc_observer.dart';
import 'package:seda_driver/src/business_logic/chat_cubit/chat_cubit.dart';
import 'package:seda_driver/src/business_logic/global_cubit/global_cubit.dart';
import 'package:seda_driver/src/business_logic/govern_cubit/govern_cubit.dart';
import 'package:seda_driver/src/business_logic/notification_cubit/notification_cubit.dart';
import 'package:seda_driver/src/business_logic/orders_cubit/orders_cubit.dart';
import 'package:seda_driver/src/business_logic/rate_cubit/rate_cubit.dart';
import 'package:seda_driver/src/business_logic/socket_cubit/socket_cubit.dart';
import 'package:seda_driver/src/business_logic/walletCubit/wallet_cubit.dart';
import 'package:seda_driver/src/constants/constant_methods.dart';
import 'package:seda_driver/src/constants/constants_variables.dart';
import 'package:seda_driver/src/constants/tools/log_util.dart';
import 'package:seda_driver/src/presentation/router/router.dart';
import 'package:seda_driver/src/services/cache_helper.dart';
import 'package:seda_driver/src/services/dio_helper.dart';
import 'package:seda_driver/src/services/notification_service.dart';
import 'package:sizer/sizer.dart';
import 'package:wakelock/wakelock.dart';

Future<void> main() async {
  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      Wakelock.enable();
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
      methodChannel = const MethodChannel("UserChannel");
      await Firebase.initializeApp();
      service = NotificationService();
      await service.initialize();
      await initialize(service);
      Bloc.observer = MyBlocObserver();
      await CacheHelper.init();
      DioHelper.init();
      runApp(const MyApp());
    },
    (error, stackTrace) async {
      FirebaseCrashlytics.instance.recordError(error, stackTrace);
      logError("Global Error: $error");
      logError("Global StackTrace: $stackTrace");
    },
  );
}

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: ((context) => GlobalCubit()
            ..checkConnection()
            ..determinePosition()),
        ),
        BlocProvider(
          create: ((context) => AuthCubit(FirebaseAuth.instance)),
        ),
        BlocProvider(
          create: ((context) => OrdersCubit()),
        ),
        BlocProvider(
          create: ((context) => GovernCubit()),
        ),
        BlocProvider(
          create: ((context) => RateCubit()),
        ),
        BlocProvider(
          create: ((context) => ChatCubit()),
        ),
        BlocProvider(
          create: ((context) => SocketCubit()),
        ),
        BlocProvider(
          create: ((context) => NotificationCubit()),
        ),
        BlocProvider(
          create: ((context) => WalletCubit()),
        ),
        BlocProvider(
          create: ((context) => SubscriptionCubit()),
        ),
        BlocProvider(
          create: ((context) => AppCubit()
            ..initAppCubit()
            ..startNetworkStream()),
          lazy: false,
        ),
      ],
      child: BlocBuilder<AppCubit, AppState>(
        builder: (context, state) {
          final cubit = AppCubit.get(context);
          return Sizer(
            builder: (context, orientation, deviceType) {
              return MaterialApp(
                navigatorKey: navigatorKey,
                title: 'Seda Driver',
                debugShowCheckedModeBanner: false,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                locale: cubit.locale,
                theme: cubit.lightTheme,
                darkTheme: cubit.darkTheme,
                themeMode: cubit.themeMode,
                onGenerateRoute: appRouter,
              );
            },
          );
        },
      ),
    );
  }
}
