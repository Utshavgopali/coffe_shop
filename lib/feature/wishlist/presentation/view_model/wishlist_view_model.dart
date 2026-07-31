import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../bean/domain/entities/bean_entity.dart';
import '../../domain/entities/wishlist_entity.dart';
import '../../domain/usecases/add_wishlist_usecase.dart';
import '../../domain/usecases/get_wishlist_usecase.dart';
import '../../domain/usecases/remove_wishlist_usecase.dart';
import '../state/wishlist_state.dart';

final wishlistViewModelProvider =
    NotifierProvider<WishlistViewModel, WishlistState>(WishlistViewModel.new);

class WishlistViewModel extends Notifier<WishlistState> {
  late GetWishlistUsecase _getWishlistUsecase;
  late AddWishlistUsecase _addWishlistUsecase;
  late RemoveWishlistUsecase _removeWishlistUsecase;

  @override
  WishlistState build() {
    _getWishlistUsecase = ref.read(getWishlistUsecaseProvider);
    _addWishlistUsecase = ref.read(addWishlistUsecaseProvider);
    _removeWishlistUsecase = ref.read(removeWishlistUsecaseProvider);
    return const WishlistState();
  }

  Future<void> loadWishlist() async {
    state = state.copyWith(status: WishlistStatus.loading, errorMessage: null);

    final result = await _getWishlistUsecase();

    result.fold(
      (failure) => state = state.copyWith(
        status: WishlistStatus.error,
        errorMessage: failure.message,
      ),
      (items) => state = state.copyWith(status: WishlistStatus.loaded, items: items),
    );
  }

  // Takes the full BeanEntity (not just the id) so a successful toggle can
  // update the list locally and instantly, without a second round trip.
  Future<bool> toggleWishlist(BeanEntity bean) async {
    final alreadyWishlisted = state.isWishlisted(bean.id);

    if (alreadyWishlisted) {
      final result = await _removeWishlistUsecase(bean.id);

      return result.fold(
        (failure) {
          state = state.copyWith(errorMessage: failure.message);
          return false;
        },
        (_) {
          final updated = state.items.where((i) => i.bean.id != bean.id).toList();
          state = state.copyWith(items: updated, errorMessage: null);
          return true;
        },
      );
    } else {
      final result = await _addWishlistUsecase(bean.id);

      return result.fold(
        (failure) {
          state = state.copyWith(errorMessage: failure.message);
          return false;
        },
        (_) {
          final updated = [
            ...state.items,
            WishlistEntity(id: bean.id, bean: bean, createdAt: DateTime.now()),
          ];
          state = state.copyWith(items: updated, errorMessage: null);
          return true;
        },
      );
    }
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  void clearCache() {
    state = const WishlistState();
  }
}
