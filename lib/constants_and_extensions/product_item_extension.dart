import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';

extension ProductItemToJSON on PurchasedItem {
  Map<String, dynamic> toJSON() {
    return {
      'productId': productId,
      'transactionId': transactionId,
      'transactionDate': transactionDate?.toIso8601String(),
      'transactionReceipt': transactionReceipt,
      'purchaseToken': purchaseToken,

      // Android only
      'dataAndroid': dataAndroid,
      'signatureAndroid': signatureAndroid,
      'isAcknowledgedAndroid': isAcknowledgedAndroid,
      'autoRenewingAndroid': autoRenewingAndroid,
      'purchaseStateAndroid':
          purchaseStateAndroid?.index, // Assuming PurchaseState is an enum

      // iOS only
      'originalTransactionDateIOS':
          originalTransactionDateIOS?.toIso8601String(),
      'originalTransactionIdentifierIOS': originalTransactionIdentifierIOS,
      'transactionStateIOS':
          transactionStateIOS?.index, // Assuming TransactionState is an enum
    };
  }
}
