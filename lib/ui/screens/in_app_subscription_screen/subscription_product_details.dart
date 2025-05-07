import 'package:flutter_inapp_purchase/modules.dart';

enum InAppSubscriptionsEnum {
  monthly,
  threeMonths,
  yearly;

  String get identifier {
    switch (this) {
      case InAppSubscriptionsEnum.monthly:
        return "monthly";
      case InAppSubscriptionsEnum.threeMonths:
        return "3months";
      case InAppSubscriptionsEnum.yearly:
        return "yearly";
    }
  }
}

class SubscriptionProductDetails {
  final IAPItem productDetails;
  final InAppSubscriptionsEnum inAppSubscriptionsEnum;

  SubscriptionProductDetails(
      {required this.productDetails, required this.inAppSubscriptionsEnum});
}
