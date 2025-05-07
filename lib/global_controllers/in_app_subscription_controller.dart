import 'dart:async';
import 'dart:collection';

import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../api_services/models/itnues_receipt_response.dart';
import '../constants_and_extensions/constants.dart';
import '../constants_and_extensions/flutter_toast_manager.dart';
import '../constants_and_extensions/internet_connectivity.dart';
import '../constants_and_extensions/nonui_extensions.dart';
import '../constants_and_extensions/shared_prefs.dart';
import '../ui/screens/in_app_subscription_screen/subscription_product_details.dart';
import '../constants_and_extensions/product_item_extension.dart';

/// Initialised in [MyApp]
class InAppSubscriptionController extends GetxController {
  StreamSubscription<PurchasedItem?>? _purchaseUpdatedSubscription;
  StreamSubscription<PurchaseResult?>? _purchaseErrorSubscription;
  StreamSubscription<ConnectionResult>? _connectionSubscription;
  final _isLoading = false.obs;
  final showLoaderForPurchaseInitiated = false.obs;
  final _isSubscriptionBought = false.obs;
  final _selectedProductID = "".obs;

  final List<SubscriptionProductDetails> _productDetails = [];

  String get selectedProductID => _selectedProductID.value;
  UnmodifiableListView get subscriptionProductList =>
      UnmodifiableListView(_productDetails);
  bool get isLoading => _isLoading.value;
  bool get isSubscriptionBought =>
      _isSubscriptionBought.value ||
      SharedPrefs().getJSON(fromKey: SharedPrefsKeys.purchaseDetails) != null;

  Future<List<String>> get getProductIdentifiers async {
    final packageInfo = await PackageInfo.fromPlatform();
    final appBundleIdentifier = packageInfo.packageName;
    return List<String>.from(InAppSubscriptionsEnum.values
        .map((x) => "$appBundleIdentifier.${x.identifier}"));
  }

  @override
  void onReady() {
    setListners();
    super.onReady();
  }

  @override
  void onClose() {
    _purchaseUpdatedSubscription?.cancel();
    _purchaseErrorSubscription?.cancel();
    _connectionSubscription?.cancel();
    super.onClose();
  }

  void setListners() async {
    var result = await FlutterInappPurchase.instance.initialize();
    ('result: $result').log();

    // refresh items for android
    try {
      String msg = await FlutterInappPurchase.instance.consumeAll();
      ('consumeAllItems: $msg').log();
    } catch (err) {
      ('consumeAllItems error: $err').log();
    }

    _connectionSubscription =
        FlutterInappPurchase.connectionUpdated.listen((connected) {
      ('connected: $connected').log();
      // FlutterInappPurchase.instance.validateReceiptIos(receiptBody: , isTest: kDebugMode);
    });

    _purchaseUpdatedSubscription =
        FlutterInappPurchase.purchaseUpdated.listen((purchasedItem) {
      ('purchase-updated: ${purchasedItem?.transactionReceipt}').log();
      if (purchasedItem != null) {
        verifyReceipt(purchasedItem: purchasedItem);
      } else {
        showLoaderForPurchaseInitiated.value = false;
      }
    });

    _purchaseErrorSubscription =
        FlutterInappPurchase.purchaseError.listen((purchaseError) {
      ('purchase-error: $purchaseError').log();
      showLoaderForPurchaseInitiated.value = false;
    });
  }

  Future<void> checkPastPurchases({PurchasedItem? pruchasedItem}) async {
    await verifyReceipt(purchasedItem: getPurchasedItem());
  }

  Future<void> verifyReceipt({required PurchasedItem? purchasedItem}) async {
    if (purchasedItem != null) {
      final receiptBody = {
        "password": "4e97482697934549a2c5921e6c9cd714",
        "exclude-old-transactions": "true",
        "receipt-data": purchasedItem.transactionReceipt ?? ""
      };

      final json = await FlutterInappPurchase.instance
          .validateReceiptIos(receiptBody: receiptBody);

      final receiptResponse = ItunesReceiptResponse.fromString(json.body);

      final inApp = receiptResponse.receipt?.inApp ?? [];
      if (inApp.isNotEmpty) {
        // Convert string to int
        final millisecondsSinceEpoch =
            int.parse(inApp.first.expiresDateMs ?? "");

        // Convert to DateTime
        final expiryDate =
            DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch)
                .toLocal();

        // Get current local time
        final now = DateTime.now();

        // Compare dates
        if (now.isAfter(expiryDate)) {
          "Purchase expired".log();
          SharedPrefs().delete(fromKey: SharedPrefsKeys.purchaseDetails);
        } else {
          "Purchase verified".log();
          SharedPrefs().setJSON(
              inKey: SharedPrefsKeys.purchaseDetails,
              value: purchasedItem.toJSON());
          _isSubscriptionBought.value = true;
          showLoaderForPurchaseInitiated.value = false;
          return;
        }
      }
      _isSubscriptionBought.value = false;
      showLoaderForPurchaseInitiated.value = false;
    }
    // final response = await InAppPurchase.instance
    //     .queryPastPurchases(await getProductIdentifiers);
    // for (final PurchaseDetails purchase in response.) {
    //   if (purchase.status == PurchaseStatus.purchased) {
    //     // Handle the purchased item
    //     verifyReceipt(purchase.verificationData);
    //   }
    // }
  }

  void setSelectedProduct({required SubscriptionProductDetails to}) {
    _selectedProductID.value = to.productDetails.productId ?? "";
  }

  Future<void> getSubscriptions() async {
    // final bool available = await InAppPurchase.instance.isAvailable();
    // ("Store Available", available).log();
    if (await FlutterInappPurchase.instance.isReady()) {
      final kIds = await getProductIdentifiers;
      final products =
          await FlutterInappPurchase.instance.getSubscriptions(kIds);
      if (products.isNotEmpty) {
        _productDetails.clear();
        for (final productDetail in products) {
          final idLast = (productDetail.productId ?? "").split(".").last;
          final InAppSubscriptionsEnum inAppSubscriptionsEnum;
          if (idLast == InAppSubscriptionsEnum.monthly.identifier) {
            inAppSubscriptionsEnum = InAppSubscriptionsEnum.monthly;
          } else if (idLast == InAppSubscriptionsEnum.threeMonths.identifier) {
            inAppSubscriptionsEnum = InAppSubscriptionsEnum.threeMonths;
          } else if (idLast == InAppSubscriptionsEnum.yearly.identifier) {
            inAppSubscriptionsEnum = InAppSubscriptionsEnum.yearly;
          } else {
            inAppSubscriptionsEnum = InAppSubscriptionsEnum.monthly;
          }

          _productDetails.add(SubscriptionProductDetails(
            inAppSubscriptionsEnum: inAppSubscriptionsEnum,
            productDetails: productDetail,
          ));
        }
        _productDetails.sort((a, b) =>
            double.parse(a.productDetails.price ?? "")
                .compareTo(double.parse(b.productDetails.price ?? "")));
      }
      _isLoading.value = false;
      showLoaderForPurchaseInitiated.value = false;
    } else {
      _isLoading.value = false;
    }
  }

  Future<void> buySelectedProduct() async {
    if (!InternetConnectivity().isInternetConnected) {
      FlutterToastManager().showInternetNotConnectedToast();
      return;
    }
    if (selectedProductID.isNotEmpty) {
      showLoaderForPurchaseInitiated.value = true;
      ("Start here").log();
      final data = await FlutterInappPurchase.instance
          .requestSubscription(selectedProductID);
      ("End here").log();
      (data).log();
    }
  }

  // Future<void> cancelSubscription() async {
  //   await InAppPurchase.instance.restorePurchases();
  // }

  Future<void> restorePurchase() async {
    showLoaderForPurchaseInitiated.value = true;
    "starteed log".log();
    // will get callback in _purchaseUpdatedSubscription
    await FlutterInappPurchase.instance.getPurchaseHistory();
    "starteed log".log();
  }

  SubscriptionProductDetails? getSubscribedProductDetails() {
    final purchasedItem = getPurchasedItem();
    if (purchasedItem != null) {
      return _productDetails.firstWhere((element) =>
          element.productDetails.productId == purchasedItem.productId);
    }
    return null;
  }

  PurchasedItem? getPurchasedItem() {
    final purchaseDetailsJSON =
        SharedPrefs().getJSON(fromKey: SharedPrefsKeys.purchaseDetails);
    if (purchaseDetailsJSON != null) {
      ("Here", purchaseDetailsJSON).log();
      final purchaseDetails = PurchasedItem.fromJSON(purchaseDetailsJSON);
      purchaseDetails.log();
      return purchaseDetails;
    }
    return null;
  }
}
