import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';

const String kSubscriptionId = 'karter_supporter';

const Set<String> kProductIds = {
  'karter_bronze_one',
  'karter_silver_one',
  'karter_gold_one',
  kSubscriptionId,
};

class InAppPurchaseService {
  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  final StreamController<List<PurchaseDetails>> _purchaseController =
      StreamController<List<PurchaseDetails>>.broadcast();

  Stream<List<PurchaseDetails>> get purchaseStream =>
      _purchaseController.stream;

  Future<bool> isAvailable() async {
    try {
      return await _iap.isAvailable();
    } catch (_) {
      return false;
    }
  }

  void initialize() {
    _subscription = _iap.purchaseStream.listen(
      _onPurchaseUpdate,
      onDone: () => _subscription?.cancel(),
      onError: (error) {
        debugPrint('IAP stream error: $error');
      },
    );
  }

  void dispose() {
    _subscription?.cancel();
    _purchaseController.close();
  }

  Future<List<ProductDetails>> loadProducts() async {
    try {
      final response = await _iap.queryProductDetails(kProductIds);
      if (response.error != null) {
        debugPrint('IAP query error: ${response.error}');
      }
      return response.productDetails;
    } catch (e) {
      debugPrint('IAP loadProducts error: $e');
      return [];
    }
  }

  Future<bool> buy(ProductDetails product) async {
    try {
      PurchaseParam params;
      if (product.id == kSubscriptionId && product is GooglePlayProductDetails) {
        params = GooglePlayPurchaseParam(
          productDetails: product,
          offerToken: product.offerToken,
        );
      } else {
        params = PurchaseParam(productDetails: product);
      }
      if (product.id == kSubscriptionId) {
        return await _iap.buyNonConsumable(purchaseParam: params);
      } else {
        return await _iap.buyConsumable(purchaseParam: params);
      }
    } catch (e) {
      debugPrint('IAP buy error: $e');
      return false;
    }
  }

  Future<void> restorePurchases() async {
    try {
      await _iap.restorePurchases();
    } catch (e) {
      debugPrint('IAP restore error: $e');
    }
  }

  void _onPurchaseUpdate(List<PurchaseDetails> purchases) {
    for (final purchase in purchases) {
      _handlePurchase(purchase);
    }
    _purchaseController.add(purchases);
  }

  Future<void> _handlePurchase(PurchaseDetails purchase) async {
    if (purchase.status == PurchaseStatus.purchased ||
        purchase.status == PurchaseStatus.restored) {
      if (purchase.pendingCompletePurchase) {
        await _iap.completePurchase(purchase);
      }
    } else if (purchase.status == PurchaseStatus.error) {
      debugPrint('IAP purchase error: ${purchase.error}');
    } else if (purchase.status == PurchaseStatus.canceled) {
      debugPrint('IAP purchase canceled');
    }
  }
}
