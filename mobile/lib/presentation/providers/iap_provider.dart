import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:mobile/core/services/in_app_purchase_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IapState {
  final bool available;
  final List<ProductDetails> products;
  final Set<String> purchased;
  final bool loading;
  final String? error;
  final bool buying;

  const IapState({
    this.available = false,
    this.products = const [],
    this.purchased = const {},
    this.loading = true,
    this.error,
    this.buying = false,
  });

  IapState copyWith({
    bool? available,
    List<ProductDetails>? products,
    Set<String>? purchased,
    bool? loading,
    String? error,
    bool? buying,
  }) {
    return IapState(
      available: available ?? this.available,
      products: products ?? this.products,
      purchased: purchased ?? this.purchased,
      loading: loading ?? this.loading,
      error: error,
      buying: buying ?? this.buying,
    );
  }
}

class IapNotifier extends Notifier<IapState> {
  late final InAppPurchaseService _service;
  StreamSubscription<List<PurchaseDetails>>? _subscription;
  static const _prefsKey = 'karter_purchased_skus';

  @override
  IapState build() {
    _service = ref.read(iapServiceProvider);
    ref.onDispose(() {
      _subscription?.cancel();
      _service.dispose();
    });
    _init();
    return const IapState();
  }

  Future<void> _init() async {
    final available = await _service.isAvailable();
    if (!available) {
      state = state.copyWith(available: false, loading: false);
      return;
    }

    _service.initialize();

    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList(_prefsKey) ?? [];

    final products = await _service.loadProducts();

    _subscription = _service.purchaseStream.listen((purchases) {
      _onPurchaseUpdate(purchases);
    });

    state = state.copyWith(
      available: true,
      products: products,
      purchased: Set.from(saved),
      loading: false,
    );
  }

  Future<bool> buy(ProductDetails product) async {
    state = state.copyWith(buying: true, error: null);
    final success = await _service.buy(product);
    if (!success) {
      state = state.copyWith(buying: false, error: 'No se pudo iniciar la compra');
    }
    return success;
  }

  Future<void> restore() async {
    state = state.copyWith(loading: true);
    await _service.restorePurchases();
  }

  Future<void> _onPurchaseUpdate(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      if (purchase.status == PurchaseStatus.purchased ||
          purchase.status == PurchaseStatus.restored) {
        final newPurchased = Set<String>.from(state.purchased);
        newPurchased.add(purchase.productID);
        state = state.copyWith(purchased: newPurchased, buying: false);
        await _savePurchased(newPurchased);
      } else if (purchase.status == PurchaseStatus.canceled) {
        state = state.copyWith(buying: false);
      } else if (purchase.status == PurchaseStatus.error) {
        state = state.copyWith(buying: false, error: purchase.error?.message);
      }
    }
  }

  Future<void> _savePurchased(Set<String> skus) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_prefsKey, skus.toList());
  }

  bool hasAnyBadge() => state.purchased.isNotEmpty;

  String? highestBadge() {
    if (state.purchased.contains('karter_gold_one') ||
        state.purchased.contains('karter_supporter')) {
      return 'gold';
    }
    if (state.purchased.contains('karter_silver_one')) {
      return 'silver';
    }
    if (state.purchased.contains('karter_bronze_one')) {
      return 'bronze';
    }
    return null;
  }
}

final iapServiceProvider = Provider<InAppPurchaseService>((ref) {
  final service = InAppPurchaseService();
  ref.onDispose(service.dispose);
  return service;
});

final iapProvider = NotifierProvider<IapNotifier, IapState>(IapNotifier.new);
