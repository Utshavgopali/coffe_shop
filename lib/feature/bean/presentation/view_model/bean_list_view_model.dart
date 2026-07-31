import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecases/get_bean_facets_usecase.dart';
import '../../domain/usecases/get_beans_usecase.dart';
import '../state/bean_list_state.dart';

final beanListViewModelProvider =
    NotifierProvider<BeanListViewModel, BeanListState>(BeanListViewModel.new);

class BeanListViewModel extends Notifier<BeanListState> {
  late GetBeansUsecase _getBeansUsecase;
  late GetBeanFacetsUsecase _getBeanFacetsUsecase;

  @override
  BeanListState build() {
    _getBeansUsecase = ref.read(getBeansUsecaseProvider);
    _getBeanFacetsUsecase = ref.read(getBeanFacetsUsecaseProvider);
    return const BeanListState();
  }

  Future<void> loadBeans({bool reset = false}) async {
    state = state.copyWith(status: BeanListStatus.loading, errorMessage: null);

    final params = GetBeansParams(
      page: reset ? 1 : state.page,
      limit: 12,
      search: state.searchQuery,
      category: state.selectedCategory,
      roastLevel: state.selectedRoastLevel.isEmpty ? const [] : [state.selectedRoastLevel],
    );

    final result = await _getBeansUsecase(params);

    result.fold(
      (failure) => state = state.copyWith(
        status: BeanListStatus.error,
        errorMessage: failure.message,
      ),
      (data) => state = state.copyWith(
        status: BeanListStatus.loaded,
        beans: reset || state.page == 1 ? data.beans : [...state.beans, ...data.beans],
        page: data.page,
        totalPages: data.totalPages,
      ),
    );
  }

  Future<void> loadFacets() async {
    final result = await _getBeanFacetsUsecase(null);
    result.fold(
      (failure) => state = state.copyWith(errorMessage: failure.message),
      (facets) => state = state.copyWith(facets: facets),
    );
  }

  void search(String query) {
    state = state.copyWith(searchQuery: query, page: 1);
    loadBeans(reset: true);
  }

  void selectCategory(String category) {
    final newCategory = state.selectedCategory == category ? '' : category;
    state = state.copyWith(selectedCategory: newCategory, page: 1);
    loadBeans(reset: true);
  }

  void selectRoastLevel(String roastLevel) {
    final newRoastLevel = state.selectedRoastLevel == roastLevel ? '' : roastLevel;
    state = state.copyWith(selectedRoastLevel: newRoastLevel, page: 1);
    loadBeans(reset: true);
  }

  void nextPage() {
    if (state.page < state.totalPages && state.status != BeanListStatus.loading) {
      state = state.copyWith(page: state.page + 1);
      loadBeans();
    }
  }
}
