import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension AppLocalization on BuildContext {
  bool get isAr => AppLocalizations.of(this)!.localeName == 'ar';

  List<Locale> get supportedLocales => AppLocalizations.supportedLocales;

  String get seda => AppLocalizations.of(this)!.seda;

  String get login => AppLocalizations.of(this)!.login;

  String get loginGreeting => AppLocalizations.of(this)!.loginGreeting;

  String get phoneNumber => AppLocalizations.of(this)!.phoneNumber;

  String get phoneNumberRequired =>
      AppLocalizations.of(this)!.phoneNumberRequired;

  String get phoneNumberShort => AppLocalizations.of(this)!.phoneNumberShort;

  String get socialLogin => AppLocalizations.of(this)!.socialLogin;

  String get phoneVerification => AppLocalizations.of(this)!.phoneVerification;

  String get noAvailPredictions =>
      AppLocalizations.of(this)!.noAvailPredictions;

  String get enterVerificationCode =>
      AppLocalizations.of(this)!.enterVerificationCode;

  String get enter4Digits => AppLocalizations.of(this)!.enter4Digits;

  String get invalidVerificationCode =>
      AppLocalizations.of(this)!.invalidVerificationCode;

  String get resendCode => AppLocalizations.of(this)!.resendCode;

  String get continueT => AppLocalizations.of(this)!.continueT;

  String get verificationCodeRequired =>
      AppLocalizations.of(this)!.verificationCodeRequired;

  String minutesLeft(String val) => AppLocalizations.of(this)!.minutesLeft(val);

  String get invalidSendCode => AppLocalizations.of(this)!.invalidSendCode;

  String get basicInfo => AppLocalizations.of(this)!.basicInfo;

  String get certificateOfGoodConduct =>
      AppLocalizations.of(this)!.certificateOfGoodConduct;

  String get vehicleInfo => AppLocalizations.of(this)!.vehicleInfo;

  String get carLicensePhoto => AppLocalizations.of(this)!.carLicensePhoto;

  String get nationalId => AppLocalizations.of(this)!.nationalId;

  String get registration => AppLocalizations.of(this)!.registration;

  String get fillRequiredFields =>
      AppLocalizations.of(this)!.fillRequiredFields;

  String get registerText1 => AppLocalizations.of(this)!.registerText1;

  String get registerText2 => AppLocalizations.of(this)!.registerText2;

  String get registerText3 => AppLocalizations.of(this)!.registerText3;

  String get registerText4 => AppLocalizations.of(this)!.registerText4;

  String get save => AppLocalizations.of(this)!.save;

  String get termsAndCondition => AppLocalizations.of(this)!.termsAndCondition;

  String get privacyPolicy => AppLocalizations.of(this)!.privacyPolicy;

  String get fullName => AppLocalizations.of(this)!.fullName;

  String get emailOptional => AppLocalizations.of(this)!.emailOptional;

  String get dateOfBirthOptional =>
      AppLocalizations.of(this)!.dateOfBirthOptional;

  String get invalidEmail => AppLocalizations.of(this)!.invalidEmail;

  String get customerSupportText =>
      AppLocalizations.of(this)!.customerSupportText;

  String get customerSupport => AppLocalizations.of(this)!.customerSupport;

  String get done => AppLocalizations.of(this)!.done;

  String get driverLicenseNumber =>
      AppLocalizations.of(this)!.driverLicenseNumber;

  String get expirationDate => AppLocalizations.of(this)!.expirationDate;

  String get driverLicensePhoto =>
      AppLocalizations.of(this)!.driverLicensePhoto;

  String get frontDriverLicense =>
      AppLocalizations.of(this)!.frontDriverLicense;

  String get frontCarLicense => AppLocalizations.of(this)!.frontCarLicense;

  String get backCarLicense => AppLocalizations.of(this)!.backCarLicense;

  String get backDriverLicense => AppLocalizations.of(this)!.backDriverLicense;

  String get addPhoto => AppLocalizations.of(this)!.addPhoto;

  String get idConfirmation1 => AppLocalizations.of(this)!.idConfirmation1;

  String get idConfirmation2 => AppLocalizations.of(this)!.idConfirmation2;

  String get idConfirmation3 => AppLocalizations.of(this)!.idConfirmation3;

  String get certificateOfGoodConductLink =>
      AppLocalizations.of(this)!.certificateOfGoodConductLink;

  String get vehicleNumber => AppLocalizations.of(this)!.vehicleNumber;

  String get vehicleBrand => AppLocalizations.of(this)!.vehicleBrand;

  String get vehicleModel => AppLocalizations.of(this)!.vehicleModel;

  String get vehicleColor => AppLocalizations.of(this)!.vehicleColor;

  String get location => AppLocalizations.of(this)!.location;

  String get numberPlatePhoto => AppLocalizations.of(this)!.numberPlatePhoto;

  String get vehiclePhoto => AppLocalizations.of(this)!.vehiclePhoto;

  String get vehicleRegistrationCertificate =>
      AppLocalizations.of(this)!.vehicleRegistrationCertificate;

  String get vehicleBrandSearch =>
      AppLocalizations.of(this)!.vehicleBrandSearch;

  String get vehicleModelSearch =>
      AppLocalizations.of(this)!.vehicleModelSearch;

  String get searchPlaces => AppLocalizations.of(this)!.searchPlaces;

  String get noAvailVehicleBrands =>
      AppLocalizations.of(this)!.noAvailVehicleBrands;

  String get fetchVehicleBrands =>
      AppLocalizations.of(this)!.fetchVehicleBrands;

  String get noAvailVehicleModels =>
      AppLocalizations.of(this)!.noAvailVehicleModels;

  String get fetchVehicleModels =>
      AppLocalizations.of(this)!.fetchVehicleModels;

  String get noAvailVehicleColors =>
      AppLocalizations.of(this)!.noAvailVehicleColors;

  String get fetchVehicleColors =>
      AppLocalizations.of(this)!.fetchVehicleColors;

  String get photoOfNumberPlate =>
      AppLocalizations.of(this)!.photoOfNumberPlate;

  String get frontCertificate => AppLocalizations.of(this)!.frontCertificate;

  String get backCertificate => AppLocalizations.of(this)!.backCertificate;

  String get obtainCriminalRecord =>
      AppLocalizations.of(this)!.obtainCriminalRecord;

  String get nationalIdNumber => AppLocalizations.of(this)!.nationalIdNumber;

  String get frontNational => AppLocalizations.of(this)!.frontNational;

  String get backNational => AppLocalizations.of(this)!.backNational;

  String get refineLocation => AppLocalizations.of(this)!.refineLocation;

  String get area => AppLocalizations.of(this)!.area;

  String get street => AppLocalizations.of(this)!.street;

  String get buildingNumber => AppLocalizations.of(this)!.buildingNumber;

  String get places => AppLocalizations.of(this)!.places;

  String get placesSearch => AppLocalizations.of(this)!.placesSearch;

  String get search => AppLocalizations.of(this)!.search;

  String get phoneCodeSelect => AppLocalizations.of(this)!.phoneCodeSelect;

  String get gallery => AppLocalizations.of(this)!.gallery;

  String get camera => AppLocalizations.of(this)!.camera;

  String get notification => AppLocalizations.of(this)!.notification;

  String get request => AppLocalizations.of(this)!.request;

  String get history => AppLocalizations.of(this)!.history;

  String get wallet => AppLocalizations.of(this)!.wallet;

  String get earning => AppLocalizations.of(this)!.earning;

  String get points => AppLocalizations.of(this)!.points;

  String get settings => AppLocalizations.of(this)!.settings;

  String get inviteFriends => AppLocalizations.of(this)!.inviteFriends;

  String get subscriptions => AppLocalizations.of(this)!.subscriptions;

  String get logout => AppLocalizations.of(this)!.logout;

  String get profile => AppLocalizations.of(this)!.profile;

  String get pointsCalculation => AppLocalizations.of(this)!.pointsCalculation;

  String get threeMonthPeriod => AppLocalizations.of(this)!.threeMonthPeriod;

  String countPoints(String val) => AppLocalizations.of(this)!.countPoints(val);

  String get yourPointsEvaluation =>
      AppLocalizations.of(this)!.yourPointsEvaluation;

  String get yourBonus => AppLocalizations.of(this)!.yourBonus;

  String get tripCancellationRate =>
      AppLocalizations.of(this)!.tripCancellationRate;

  String get starReviews => AppLocalizations.of(this)!.starReviews;

  String get keepHighRating => AppLocalizations.of(this)!.keepHighRating;

  String get maintainService => AppLocalizations.of(this)!.maintainService;

  String get earn1PointEveryTrip =>
      AppLocalizations.of(this)!.earn1PointEveryTrip;

  String get howToUse => AppLocalizations.of(this)!.howToUse;

  String get diamondLevel => AppLocalizations.of(this)!.diamondLevel;

  String get platinumLevel => AppLocalizations.of(this)!.platinumLevel;

  String get goldenLevel => AppLocalizations.of(this)!.goldenLevel;

  String get silverLevel => AppLocalizations.of(this)!.silverLevel;

  String get subscriptionType => AppLocalizations.of(this)!.subscriptionType;

  String get commissionType => AppLocalizations.of(this)!.commissionType;

  String get subscriptionAndCommissionType =>
      AppLocalizations.of(this)!.subscriptionAndCommissionType;

  String get inviteFriendsToGetReward =>
      AppLocalizations.of(this)!.inviteFriendsToGetReward;

  String get sendInviteFriendCoupon =>
      AppLocalizations.of(this)!.sendInviteFriendCoupon;

  String get notificationsSetting =>
      AppLocalizations.of(this)!.notificationsSetting;

  String get messagesSetting => AppLocalizations.of(this)!.messagesSetting;

  String get darkModeSetting => AppLocalizations.of(this)!.darkModeSetting;

  String get languageSetting => AppLocalizations.of(this)!.languageSetting;

  String get healthInsurance => AppLocalizations.of(this)!.healthInsurance;

  String get familyInsurance => AppLocalizations.of(this)!.familyInsurance;

  String get bankLoan => AppLocalizations.of(this)!.bankLoan;

  String get freeFuelShipping => AppLocalizations.of(this)!.freeFuelShipping;

  String get discounts => AppLocalizations.of(this)!.discounts;

  String get silverLevelBonus => AppLocalizations.of(this)!.silverLevelBonus;

  String get levelUpForMoreBonus =>
      AppLocalizations.of(this)!.levelUpForMoreBonus;

  String get previousTrips => AppLocalizations.of(this)!.previousTrips;

  String get previousEarns => AppLocalizations.of(this)!.previousEarns;

  String get dailyProfit => AppLocalizations.of(this)!.dailyProfit;

  String get trips => AppLocalizations.of(this)!.trips;

  String tripCounter(String counter) =>
      AppLocalizations.of(this)!.tripCounter(counter);

  String get onlineHours => AppLocalizations.of(this)!.onlineHours;

  String get cashTrips => AppLocalizations.of(this)!.cashTrips;

  String get appFees => AppLocalizations.of(this)!.appFees;

  String get tripFares => AppLocalizations.of(this)!.tripFares;

  String get tax => AppLocalizations.of(this)!.tax;

  String get tolls => AppLocalizations.of(this)!.tolls;

  String get discount => AppLocalizations.of(this)!.discount;

  String get topUpAdded => AppLocalizations.of(this)!.topUpAdded;

  String get totalEarning => AppLocalizations.of(this)!.totalEarning;

  String get availableBalance => AppLocalizations.of(this)!.availableBalance;

  String get walletRecharge => AppLocalizations.of(this)!.walletRecharge;

  String get today => AppLocalizations.of(this)!.today;

  String tripsCompletedCounter(String counter) =>
      AppLocalizations.of(this)!.tripsCompletedCounter(counter);

  String get upgradePointsCalculation =>
      AppLocalizations.of(this)!.upgradePointsCalculation;

  String get promotions => AppLocalizations.of(this)!.promotions;

  String get promotionsText => AppLocalizations.of(this)!.promotionsText;

  String get clickForMore => AppLocalizations.of(this)!.clickForMore;

  String get start => AppLocalizations.of(this)!.start;

  String get notConnected => AppLocalizations.of(this)!.notConnected;

  String upPaidSubscription(String month) =>
      AppLocalizations.of(this)!.upPaidSubscription(month);

  String get warning => AppLocalizations.of(this)!.warning;

  String get seeDrivingTime => AppLocalizations.of(this)!.seeDrivingTime;

  String get walletWithdraw => AppLocalizations.of(this)!.walletWithdraw;

  String get subscriptionWeekly =>
      AppLocalizations.of(this)!.subscriptionWeekly;

  String get subscriptionMonthly =>
      AppLocalizations.of(this)!.subscriptionMonthly;

  String get subscriptionFeatureCityRides =>
      AppLocalizations.of(this)!.subscriptionFeatureCityRides;

  String get subscriptionFeatureCityToCity =>
      AppLocalizations.of(this)!.subscriptionFeatureCityToCity;

  String get subscriptionFeatureReservationOfHour =>
      AppLocalizations.of(this)!.subscriptionFeatureReservationOfHour;

  String get subscriptionFeatureCustomisedPrice =>
      AppLocalizations.of(this)!.subscriptionFeatureCustomisedPrice;

  String get cityToCity => AppLocalizations.of(this)!.cityToCity;

  String get reservationOfHour => AppLocalizations.of(this)!.reservationOfHour;

  String weeklySubscriptionText(String fees) =>
      AppLocalizations.of(this)!.weeklySubscriptionText(fees);

  String get featuresOffered => AppLocalizations.of(this)!.featuresOffered;

  String get servicesCanJoin => AppLocalizations.of(this)!.servicesCanJoin;

  String get subscribe => AppLocalizations.of(this)!.subscribe;

  String get weeklySubscribeErr =>
      AppLocalizations.of(this)!.weeklySubscribeErr;

  String get rewardOffered => AppLocalizations.of(this)!.rewardOffered;

  String get chooseYourCity => AppLocalizations.of(this)!.chooseYourCity;

  String get chooseCityYouCanGoTo =>
      AppLocalizations.of(this)!.chooseCityYouCanGoTo;

  String get chooseAnotherCityYouCanGoTo =>
      AppLocalizations.of(this)!.chooseAnotherCityYouCanGoTo;

  String get when => AppLocalizations.of(this)!.when;

  String get numberOfHours => AppLocalizations.of(this)!.numberOfHours;

  String get hourPrice => AppLocalizations.of(this)!.hourPrice;

  String get sendMessage => AppLocalizations.of(this)!.sendMessage;

  String get requestRides => AppLocalizations.of(this)!.requestRides;

  String get close => AppLocalizations.of(this)!.close;

  String get send => AppLocalizations.of(this)!.send;

  String get priceOffer => AppLocalizations.of(this)!.priceOffer;

  String get suggestPrice => AppLocalizations.of(this)!.suggestPrice;

  String get cash => AppLocalizations.of(this)!.cash;

  String get rateSeda => AppLocalizations.of(this)!.rateSeda;

  String get cancelled => AppLocalizations.of(this)!.cancelled;

  String get completed => AppLocalizations.of(this)!.completed;

  String get more => AppLocalizations.of(this)!.more;

  String get reloadPage => AppLocalizations.of(this)!.reloadPage;

  String get noInternet => AppLocalizations.of(this)!.noInternet;

  String get slowOrNoInternet => AppLocalizations.of(this)!.slowOrNoInternet;

  String get youConnected => AppLocalizations.of(this)!.youConnected;

  String away(String time) => AppLocalizations.of(this)!.away(time);

  String get arrived => AppLocalizations.of(this)!.arrived;

  String get startTheTrip => AppLocalizations.of(this)!.startTheTrip;

  String get endTheTrip => AppLocalizations.of(this)!.endTheTrip;

  String get viewTheReceipt => AppLocalizations.of(this)!.viewTheReceipt;

  String get cancel => AppLocalizations.of(this)!.cancel;

  String get receiptForTheTrip => AppLocalizations.of(this)!.receiptForTheTrip;

  String get subtotal => AppLocalizations.of(this)!.subtotal;

  String get designTextExample => AppLocalizations.of(this)!.designTextExample;

  String get facilitateText => AppLocalizations.of(this)!.facilitateText;

  String get english => AppLocalizations.of(this)!.english;

  String get arabic => AppLocalizations.of(this)!.arabic;

  String get rideStarted => AppLocalizations.of(this)!.rideStarted;

  String get codeSent => AppLocalizations.of(this)!.codeSent;

  String get enterName => AppLocalizations.of(this)!.enterName;

  String get shortName => AppLocalizations.of(this)!.shortName;

  String get needToAgree => AppLocalizations.of(this)!.needToAgree;

  String get selectLocation => AppLocalizations.of(this)!.selectLocation;

  String get rideTypesError => AppLocalizations.of(this)!.rideTypesError;

  String get errorOccurred => AppLocalizations.of(this)!.errorOccurred;

  String get promoAdded => AppLocalizations.of(this)!.promoAdded;

  String get rideRequested => AppLocalizations.of(this)!.rideRequested;

  String get micAllow => AppLocalizations.of(this)!.micAllow;

  String get language => AppLocalizations.of(this)!.language;

  String get appLangCh => AppLocalizations.of(this)!.appLangCh;

  String get appLangChErrAr => AppLocalizations.of(this)!.appLangChErrAr;

  String get appLangChErrEn => AppLocalizations.of(this)!.appLangChErrEn;

  String get appLangChErrEmpty => AppLocalizations.of(this)!.appLangChErrEmpty;

  String get terms => AppLocalizations.of(this)!.terms;

  String get termsText => AppLocalizations.of(this)!.termsText;

  String get termsAndPolicy => AppLocalizations.of(this)!.termsAndPolicy;

  String get yourTrip => AppLocalizations.of(this)!.yourTrip;

  String get notifications => AppLocalizations.of(this)!.notifications;

  String get security => AppLocalizations.of(this)!.security;

  String get contactUs => AppLocalizations.of(this)!.contactUs;

  String get myWallet => AppLocalizations.of(this)!.myWallet;

  String get inviteFriendsGift => AppLocalizations.of(this)!.inviteFriendsGift;

  String get fillProfile => AppLocalizations.of(this)!.fillProfile;

  String get checkout => AppLocalizations.of(this)!.checkout;

  String get home => AppLocalizations.of(this)!.home;

  String get payment => AppLocalizations.of(this)!.payment;

  String get totalPrice => AppLocalizations.of(this)!.totalPrice;

  String get distance => AppLocalizations.of(this)!.distance;

  String get time => AppLocalizations.of(this)!.time;

  String get price => AppLocalizations.of(this)!.price;

  String get cont => AppLocalizations.of(this)!.cont;

  String get select => AppLocalizations.of(this)!.select;

  String get selectRide => AppLocalizations.of(this)!.selectRide;

  String get whereTo => AppLocalizations.of(this)!.whereTo;

  String get now => AppLocalizations.of(this)!.now;

  String get rateDriver => AppLocalizations.of(this)!.rateDriver;

  String get choosePayment => AppLocalizations.of(this)!.choosePayment;

  String get chooseRide => AppLocalizations.of(this)!.chooseRide;

  String get choose => AppLocalizations.of(this)!.choose;

  String get termsApprove => AppLocalizations.of(this)!.termsApprove;

  String get ride => AppLocalizations.of(this)!.ride;

  String get online => AppLocalizations.of(this)!.online;

  String get govern => AppLocalizations.of(this)!.govern;

  String get edit => AppLocalizations.of(this)!.edit;

  String get go => AppLocalizations.of(this)!.go;

  String get addOne => AppLocalizations.of(this)!.addOne;

  String get addFavourite => AppLocalizations.of(this)!.addFavourite;

  String get stopPoint => AppLocalizations.of(this)!.stopPoint;

  String get startPoint => AppLocalizations.of(this)!.startPoint;

  String get whyCancel => AppLocalizations.of(this)!.whyCancel;

  String get cancelTrip => AppLocalizations.of(this)!.cancelTrip;

  String get personalReason => AppLocalizations.of(this)!.personalReason;

  String get anotherCarArrived => AppLocalizations.of(this)!.anotherCarArrived;

  String get reasonRelatedTo => AppLocalizations.of(this)!.reasonRelatedTo;

  String get capOrCar => AppLocalizations.of(this)!.capOrCar;

  String get sedaSorry => AppLocalizations.of(this)!.sedaSorry;

  String get yes => AppLocalizations.of(this)!.yes;

  String get no => AppLocalizations.of(this)!.no;

  String get playAudioRecord => AppLocalizations.of(this)!.playAudioRecord;

  String get capProf => AppLocalizations.of(this)!.capProf;

  String get carType => AppLocalizations.of(this)!.carType;

  String get myCards => AppLocalizations.of(this)!.myCards;

  String get emptyCards => AppLocalizations.of(this)!.emptyCards;

  String get error => AppLocalizations.of(this)!.error;

  String get addressConf => AppLocalizations.of(this)!.addressConf;

  String get checkDrId => AppLocalizations.of(this)!.checkDrId;

  String get tripStart => AppLocalizations.of(this)!.tripStart;

  String get tripLocation => AppLocalizations.of(this)!.tripLocation;

  String get tripTime => AppLocalizations.of(this)!.tripTime;

  String get arrivalTime => AppLocalizations.of(this)!.arrivalTime;

  String get sedaServe => AppLocalizations.of(this)!.sedaServe;

  String get periodStop => AppLocalizations.of(this)!.periodStop;

  String get periodStopDesc => AppLocalizations.of(this)!.periodStopDesc;

  String get sedaOpinion => AppLocalizations.of(this)!.sedaOpinion;

  String get off => AppLocalizations.of(this)!.off;

  String get moreTrips => AppLocalizations.of(this)!.moreTrips;

  String get doNotHave => AppLocalizations.of(this)!.doNotHave;

  String get validCoupon => AppLocalizations.of(this)!.validCoupon;

  String get myPromos => AppLocalizations.of(this)!.myPromos;

  String get cong => AppLocalizations.of(this)!.cong;

  String get recharge => AppLocalizations.of(this)!.recharge;

  String get saveChanges => AppLocalizations.of(this)!.saveChanges;

  String get around => AppLocalizations.of(this)!.around;

  String get favPlaces => AppLocalizations.of(this)!.favPlaces;

  String get myVouchers => AppLocalizations.of(this)!.myVouchers;

  String get apply => AppLocalizations.of(this)!.apply;

  String get qrScan => AppLocalizations.of(this)!.qrScan;

  String get qrScanText => AppLocalizations.of(this)!.qrScanText;

  String get openFlash => AppLocalizations.of(this)!.openFlash;

  String get addCode => AppLocalizations.of(this)!.addCode;

  String get me => AppLocalizations.of(this)!.me;

  String get newPassenger => AppLocalizations.of(this)!.newPassenger;

  String get friendsAgreed => AppLocalizations.of(this)!.friendsAgreed;

  String get compDisabled => AppLocalizations.of(this)!.compDisabled;

  String get capRequestSent => AppLocalizations.of(this)!.capRequestSent;

  String get disabled => AppLocalizations.of(this)!.disabled;

  String get takePic => AppLocalizations.of(this)!.takePic;

  String get selectGallery => AppLocalizations.of(this)!.selectGallery;

  String get locationAdd => AppLocalizations.of(this)!.locationAdd;

  String get leftWindowClosed => AppLocalizations.of(this)!.leftWindowClosed;

  String get carCond => AppLocalizations.of(this)!.carCond;

  String get impol => AppLocalizations.of(this)!.impol;

  String get arrLate => AppLocalizations.of(this)!.arrLate;

  String get badDrive => AppLocalizations.of(this)!.badDrive;

  String get leaveComment => AppLocalizations.of(this)!.leaveComment;

  String get writePrice => AppLocalizations.of(this)!.writePrice;

  String get usageTime => AppLocalizations.of(this)!.usageTime;

  String get safetyWelcome => AppLocalizations.of(this)!.safetyWelcome;

  String get tripShare => AppLocalizations.of(this)!.tripShare;

  String get recordingAudio => AppLocalizations.of(this)!.recordingAudio;

  String get safetyText1 => AppLocalizations.of(this)!.safetyText1;

  String get rideVerify => AppLocalizations.of(this)!.rideVerify;

  String get safetyText2 => AppLocalizations.of(this)!.safetyText2;

  String get sedaHotline => AppLocalizations.of(this)!.sedaHotline;

  String get safetyText3 => AppLocalizations.of(this)!.safetyText3;

  String get trustedCont => AppLocalizations.of(this)!.trustedCont;

  String get safetyText4 => AppLocalizations.of(this)!.safetyText4;

  String get whiteThing => AppLocalizations.of(this)!.whiteThing;

  String get newT => AppLocalizations.of(this)!.newT;

  String get special => AppLocalizations.of(this)!.special;

  String tripDate(String date) => AppLocalizations.of(this)!.tripDate(date);

  String get paid => AppLocalizations.of(this)!.paid;

  String get end => AppLocalizations.of(this)!.end;

  String get goodMorning => AppLocalizations.of(this)!.goodMorning;

  String get confirm => AppLocalizations.of(this)!.confirm;

  String get singIn => AppLocalizations.of(this)!.signIn;

  String get next => AppLocalizations.of(this)!.next;

  String get or => AppLocalizations.of(this)!.or;

  String get nickName => AppLocalizations.of(this)!.nickName;

  String get birthDate => AppLocalizations.of(this)!.birthDate;

  String get email => AppLocalizations.of(this)!.email;

  String get phone => AppLocalizations.of(this)!.phone;

  String get verify => AppLocalizations.of(this)!.verify;

  String get otpCode => AppLocalizations.of(this)!.otpCode;

  String get walletBalance => AppLocalizations.of(this)!.walletBalance;

  String get addCoin => AppLocalizations.of(this)!.addCoin;

  String get addCard => AppLocalizations.of(this)!.addCard;

  String get cards => AppLocalizations.of(this)!.cards;

  String get savedCards => AppLocalizations.of(this)!.savedCards;

  String get cardName => AppLocalizations.of(this)!.cardName;

  String get cardNumber => AppLocalizations.of(this)!.cardNumber;

  String get exprDate => AppLocalizations.of(this)!.exprDate;

  String get cvv => AppLocalizations.of(this)!.cvv;

  String get messages => AppLocalizations.of(this)!.messages;

  String get credit => AppLocalizations.of(this)!.credit;

  String get finish => AppLocalizations.of(this)!.finish;

  String get shortPhone => AppLocalizations.of(this)!.shortPhone;

  String get sendOffer => AppLocalizations.of(this)!.sendOffer;

  String get joinSeda => AppLocalizations.of(this)!.joinSeda;

  String get message => AppLocalizations.of(this)!.message;

  String get driverOffline => AppLocalizations.of(this)!.driverOffline;

  String get makeSure => AppLocalizations.of(this)!.makeSure;

  String get rideOpinion => AppLocalizations.of(this)!.rideOpinion;

  String get designLongTextExample =>
      AppLocalizations.of(this)!.designLongTextExample;

  String get drCancelRide => AppLocalizations.of(this)!.drCancelRide;

  String get waitUserAccept => AppLocalizations.of(this)!.waitUserAccept;

  String get prevEarnings => AppLocalizations.of(this)!.prevEarnings;

  String get prevTrips => AppLocalizations.of(this)!.prevTrips;

  String tripNumber(String num) => AppLocalizations.of(this)!.tripNumber(num);

  String get onlineHrs => AppLocalizations.of(this)!.onlineHrs;

  String get cashTrip => AppLocalizations.of(this)!.cashTrip;

  String get topUp => AppLocalizations.of(this)!.topUp;

  String get termsError => AppLocalizations.of(this)!.termsError;

  String get enterTaxLicenseError =>
      AppLocalizations.of(this)!.enterTaxLicenseError;

  String get enterVehicleLicenseError =>
      AppLocalizations.of(this)!.enterVehicleLicenseError;

  String get enterDriverLicenseError =>
      AppLocalizations.of(this)!.enterDriverLicenseError;

  String get pickVehicleColorError =>
      AppLocalizations.of(this)!.pickVehicleColorError;

  String get selectVehicleTypeError =>
      AppLocalizations.of(this)!.selectVehicleTypeError;

  String get enterCarYearError => AppLocalizations.of(this)!.enterCarYearError;

  String get enterCarNumError => AppLocalizations.of(this)!.enterCarNumError;

  String get taxLicense => AppLocalizations.of(this)!.taxLicense;

  String get vehicleLicense => AppLocalizations.of(this)!.vehicleLicense;

  String get drLicense => AppLocalizations.of(this)!.drLicense;

  String get pickVehicleColor => AppLocalizations.of(this)!.pickVehicleColor;

  String get vehicleCompanyType =>
      AppLocalizations.of(this)!.vehicleCompanyType;

  String get vehicleCompany => AppLocalizations.of(this)!.vehicleCompany;

  String get vehicleYear => AppLocalizations.of(this)!.vehicleYear;

  String package(String from, String to, String cost) =>
      AppLocalizations.of(this)!.package(
        from,
        to,
        cost,
      );

  String get subPlans => AppLocalizations.of(this)!.subPlans;

  String get ratings => AppLocalizations.of(this)!.ratings;

  String date(String date) => AppLocalizations.of(this)!.date(date);

  String day(String day) => AppLocalizations.of(this)!.day(day);

  String get placeTooFar => AppLocalizations.of(this)!.placeTooFar;

  String get wrongPoint => AppLocalizations.of(this)!.wrongPoint;

  String get passengerAsk => AppLocalizations.of(this)!.passengerAsk;

  String get stillOnRoad => AppLocalizations.of(this)!.stillOnRoad;

  String get notEnoughSeat => AppLocalizations.of(this)!.notEnoughSeat;

  String get tooMuchBag => AppLocalizations.of(this)!.tooMuchBag;

  String get safetyReason => AppLocalizations.of(this)!.safetyReason;

  String get vehicleColorPicker =>
      AppLocalizations.of(this)!.vehicleColorPicker;

  String get seeDetails => AppLocalizations.of(this)!.seeDetails;

  String get driverOffer => AppLocalizations.of(this)!.driverOffer;

  String get priceOfferReq => AppLocalizations.of(this)!.priceOfferReq;

  String get totalTrips => AppLocalizations.of(this)!.totalTrips;

  String get cancelOffer => AppLocalizations.of(this)!.cancelOffer;

  String get micPermissionError =>
      AppLocalizations.of(this)!.micPermissionError;

  String get storagePermissionError =>
      AppLocalizations.of(this)!.storagePermissionError;

  String get recordPermissionsError =>
      AppLocalizations.of(this)!.recordPermissionsError;

  String get rateUser => AppLocalizations.of(this)!.rateUser;

  String get rateTheUser => AppLocalizations.of(this)!.rateTheUser;

  String get didThereAnyChange => AppLocalizations.of(this)!.didThereAnyChange;

  String get areThereFeesLeft => AppLocalizations.of(this)!.areThereFeesLeft;

  String get ifFoundWritePriceHere =>
      AppLocalizations.of(this)!.ifFoundWritePriceHere;

  String get submit => AppLocalizations.of(this)!.submit;

  String get editProfile => AppLocalizations.of(this)!.editProfile;

  String get services => AppLocalizations.of(this)!.services;

  String get tryReachHigherLevel =>
      AppLocalizations.of(this)!.tryReachHigherLevel;

  String get acceptingOrder => AppLocalizations.of(this)!.acceptingOrder;

  String get rejectingOrder => AppLocalizations.of(this)!.rejectingOrder;

  String get swipeUpAccept => AppLocalizations.of(this)!.swipeUpAccept;

  String get swipeDownCancel => AppLocalizations.of(this)!.swipeDownCancel;

  String get rate => AppLocalizations.of(this)!.rate;

  String get enterEmail => AppLocalizations.of(this)!.enterEmail;

  String get enterBirth => AppLocalizations.of(this)!.enterBirth;

  String get youSubscribedSuccessfully =>
      AppLocalizations.of(this)!.youSubscribedSuccessfully;

  String get someErrorHappenedTryAgain =>
      AppLocalizations.of(this)!.someErrorHappenedTryAgain;

  String get renew => AppLocalizations.of(this)!.renew;

  String get upgrade => AppLocalizations.of(this)!.upgrade;

  String get hourDay => AppLocalizations.of(this)!.hourDay;

  String get cancellation => AppLocalizations.of(this)!.cancellation;

  String get levels => AppLocalizations.of(this)!.levels;

  String get transaction => AppLocalizations.of(this)!.transaction;

  String get transactions => AppLocalizations.of(this)!.transactions;

  String get stop => AppLocalizations.of(this)!.stop;

  String get upcomingPromotionalAds =>
      AppLocalizations.of(this)!.upcomingPromotionalAds;

  String get noHistoryHere => AppLocalizations.of(this)!.noHistoryHere;

  String get doYouWantCancelTrip =>
      AppLocalizations.of(this)!.doYouWantCancelTrip;

  String get record => AppLocalizations.of(this)!.record;

  String get enterValidAmount => AppLocalizations.of(this)!.enterValidAmount;

  String get privacyPolicyContent => AppLocalizations.of(this)!.privacyPolicyContent;
}
