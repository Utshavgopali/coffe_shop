import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/locale/app_strings.dart';
import '../../../../app/locale/locale_state.dart';
import '../../../../app/locale/locale_view_model.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../bean/presentation/pages/bean_detail_page.dart';
import '../../../bean/presentation/state/bean_list_state.dart';
import '../../../bean/presentation/view_model/bean_list_view_model.dart';
import '../../../bean/presentation/widgets/bean_card.dart';

class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  final _searchCtrl = TextEditingController();

  List<(String, String)> _categories(AppLanguage lang) => [
        ('', AppStrings.get('categoryAll', lang)),
        ('single-origin', AppStrings.get('categorySingleOrigin', lang)),
        ('blend', AppStrings.get('categoryBlend', lang)),
        ('decaf', AppStrings.get('categoryDecaf', lang)),
        ('espresso', AppStrings.get('categoryEspresso', lang)),
      ];

  List<(String, String)> _roastLevels(AppLanguage lang) => [
        ('', AppStrings.get('categoryAll', lang)),
        ('light', AppStrings.get('roastLight', lang)),
        ('medium', AppStrings.get('roastMedium', lang)),
        ('medium-dark', AppStrings.get('roastMediumDark', lang)),
        ('dark', AppStrings.get('roastDark', lang)),
      ];

  @override
  void initState() {
    super.initState();
    final state = ref.read(beanListViewModelProvider);
    _searchCtrl.text = state.searchQuery;
    if (state.status == BeanListStatus.initial) {
      Future.microtask(() => ref.read(beanListViewModelProvider.notifier).loadBeans());
    }
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(beanListViewModelProvider);
    final lang = ref.watch(localeViewModelProvider).language;

    return Scaffold(
      backgroundColor: context.appBackground,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Container(
                decoration: BoxDecoration(
                  color: context.appSurface,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchCtrl,
                  style: TextStyle(fontFamily: 'Montserrat', fontSize: 13, color: context.appTextPrimary),
                  onSubmitted: (value) =>
                      ref.read(beanListViewModelProvider.notifier).search(value.trim()),
                  decoration: InputDecoration(
                    hintText: AppStrings.get('searchCoffeeBeansOrigins', lang),
                    hintStyle: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 13,
                      color: context.appTextSecondary,
                    ),
                    prefixIcon: Icon(Icons.search, color: context.appTextSecondary, size: 20),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.arrow_forward, size: 18, color: AppColors.primary),
                      onPressed: () => ref
                          .read(beanListViewModelProvider.notifier)
                          .search(_searchCtrl.text.trim()),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              height: 34,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: _categories(lang)
                    .map((c) => _FilterChip(
                          label: c.$2,
                          selected: state.selectedCategory == c.$1,
                          onTap: () =>
                              ref.read(beanListViewModelProvider.notifier).selectCategory(c.$1),
                        ))
                    .toList(),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 34,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: _roastLevels(lang)
                    .map((r) => _FilterChip(
                          label: r.$2,
                          selected: state.selectedRoastLevel == r.$1,
                          onTap: () => ref
                              .read(beanListViewModelProvider.notifier)
                              .selectRoastLevel(r.$1),
                        ))
                    .toList(),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(child: _buildResults(context, state)),
          ],
        ),
      ),
    );
  }

  Widget _buildResults(BuildContext context, BeanListState state) {
    final lang = ref.read(localeViewModelProvider).language;

    if (state.status == BeanListStatus.loading && state.beans.isEmpty) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primary));
    }

    if (state.status == BeanListStatus.error && state.beans.isEmpty) {
      return ListView(
        children: [
          const SizedBox(height: 60),
          Center(
            child: Text(
              state.errorMessage ?? AppStrings.get('somethingWentWrong', lang),
              textAlign: TextAlign.center,
              style: const TextStyle(fontFamily: 'Montserrat'),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: ElevatedButton(
              onPressed: () => ref.read(beanListViewModelProvider.notifier).loadBeans(reset: true),
              child: Text(AppStrings.get('retry', lang)),
            ),
          ),
        ],
      );
    }

    if (state.beans.isEmpty) {
      return Center(
        child: Text(
          AppStrings.get('noBeansMatchFilters', lang),
          style: TextStyle(fontFamily: 'Montserrat', color: context.appTextSecondary),
        ),
      );
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification.metrics.pixels >= notification.metrics.maxScrollExtent - 200) {
          ref.read(beanListViewModelProvider.notifier).nextPage();
        }
        return false;
      },
      child: RefreshIndicator(
        onRefresh: () => ref.read(beanListViewModelProvider.notifier).loadBeans(reset: true),
        child: ListView.builder(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          itemCount: state.beans.length,
          itemBuilder: (context, index) {
            final bean = state.beans[index];
            return BeanCard(
              bean: bean,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => BeanDetailPage(beanId: bean.id)),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : context.appSurface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : context.appTextSecondary,
          ),
        ),
      ),
    );
  }
}
