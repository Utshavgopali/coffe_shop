import 'package:cached_network_image/cached_network_image.dart';
import 'package:coffeshop_mobile/app/locale/app_strings.dart';
import 'package:coffeshop_mobile/app/locale/locale_view_model.dart';
import 'package:coffeshop_mobile/app/theme/app_colors.dart';
import 'package:coffeshop_mobile/core/api/api_endpoints.dart';
import 'package:coffeshop_mobile/feature/auth/presentation/view_model/auth_view_model.dart';
import 'package:coffeshop_mobile/feature/bean/domain/entities/bean_entity.dart';
import 'package:coffeshop_mobile/feature/bean/presentation/pages/bean_detail_page.dart';
import 'package:coffeshop_mobile/feature/bean/presentation/providers/featured_beans_provider.dart';
import 'package:coffeshop_mobile/feature/bean/presentation/view_model/bean_list_view_model.dart';
import 'package:coffeshop_mobile/feature/chatbot/presentation/pages/chatbot_page.dart';
import 'package:coffeshop_mobile/feature/dashboard/presentation/providers/bottom_nav_provider.dart';
import 'package:coffeshop_mobile/feature/notification/presentation/pages/notifications_page.dart';
import 'package:coffeshop_mobile/feature/notification/presentation/view_model/notification_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  static const _montserrat = 'Montserrat';

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(notificationViewModelProvider.notifier).loadNotifications());
  }

  static const _cardColors = [
    Color(0xFFF5EBE0),
    Color(0xFFFFF3E8),
    Color(0xFFEDE0D4),
    Color(0xFFF0E6D3),
    Color(0xFFFAF0E6),
    Color(0xFFEFE0CE),
    Color(0xFFF7EDE2),
    Color(0xFFF3E4D7),
  ];

  void _goToExplore(WidgetRef ref, {String? category}) {
    if (category != null) {
      ref.read(beanListViewModelProvider.notifier).selectCategory(category);
    }
    ref.read(bottomNavProvider.notifier).state = 1;
  }

  void _openBean(BuildContext context, BeanEntity bean) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => BeanDetailPage(beanId: bean.id)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(localeViewModelProvider).language;
    final user = ref.watch(authViewModelProvider).user;
    final firstName = user != null ? user.name.split(' ').first : AppStrings.get('coffeeLover', lang);
    final avatarUrl = ApiEndpoints.resolveImageUrl(user?.avatar);
    final beansAsync = ref.watch(featuredBeansProvider(8));
    final unreadCount = ref.watch(notificationViewModelProvider).unread;

    return Scaffold(
      backgroundColor: context.appBackground,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${AppStrings.get('goodMorning', lang)} $firstName ☕',
                          style: TextStyle(
                            fontFamily: _montserrat,
                            fontSize: 13,
                            color: context.appTextSecondary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          AppStrings.get('findYourPerfectBean', lang),
                          style: const TextStyle(
                            fontFamily: _montserrat,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primaryDark,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const ChatbotPage()),
                          ),
                          child: Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: context.appSurface,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.chat_bubble_outline,
                              color: AppColors.primaryDark,
                              size: 19,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const NotificationsPage()),
                          ),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  color: context.appSurface,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.05),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.notifications_outlined,
                                  color: AppColors.primaryDark,
                                  size: 20,
                                ),
                              ),
                              if (unreadCount > 0)
                                Positioned(
                                  right: -2,
                                  top: -2,
                                  child: Container(
                                    padding: const EdgeInsets.all(3),
                                    constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                                    decoration:
                                        const BoxDecoration(color: AppColors.error, shape: BoxShape.circle),
                                    child: Text(
                                      '$unreadCount',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        CircleAvatar(
                          radius: 21,
                          backgroundColor: AppColors.primary,
                          backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl) : null,
                          child: avatarUrl == null
                              ? const Icon(Icons.person, color: Colors.white, size: 22)
                              : null,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Search bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: GestureDetector(
                  onTap: () => _goToExplore(ref),
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
                    child: IgnorePointer(
                      child: TextField(
                        enabled: false,
                        style: TextStyle(
                          fontFamily: _montserrat,
                          fontSize: 13,
                          color: context.appTextPrimary,
                        ),
                        decoration: InputDecoration(
                          hintText: AppStrings.get('searchCoffeeBeansOrigins', lang),
                          hintStyle: TextStyle(
                            fontFamily: _montserrat,
                            fontSize: 13,
                            color: context.appTextSecondary,
                          ),
                          prefixIcon: Icon(Icons.search, color: context.appTextSecondary, size: 20),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Category chips
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 0, 0),
                child: SizedBox(
                  height: 36,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _CategoryChip(
                        label: AppStrings.get('categoryAll', lang),
                        selected: true,
                        onTap: () => _goToExplore(ref),
                      ),
                      _CategoryChip(
                        label: AppStrings.get('categoryDarkRoast', lang),
                        onTap: () => _goToExplore(ref, category: 'espresso'),
                      ),
                      _CategoryChip(
                        label: AppStrings.get('categorySingleOrigin', lang),
                        onTap: () => _goToExplore(ref, category: 'single-origin'),
                      ),
                      _CategoryChip(
                        label: AppStrings.get('categoryBlends', lang),
                        onTap: () => _goToExplore(ref, category: 'blend'),
                      ),
                      _CategoryChip(
                        label: AppStrings.get('categoryDecaf', lang),
                        onTap: () => _goToExplore(ref, category: 'decaf'),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Trending section header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 26, 20, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 4,
                          height: 18,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          AppStrings.get('trendingBeans', lang),
                          style: const TextStyle(
                            fontFamily: _montserrat,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primaryDark,
                          ),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () => _goToExplore(ref),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        AppStrings.get('seeAll', lang),
                        style: TextStyle(fontFamily: _montserrat, fontSize: 12, color: context.appTextSecondary),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            beansAsync.when(
              loading: () => const SliverToBoxAdapter(
                child: SizedBox(
                  height: 220,
                  child: Center(child: CircularProgressIndicator(color: AppColors.primary)),
                ),
              ),
              error: (error, _) => SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                  child: Center(
                    child: Text(
                      AppStrings.get('couldNotLoadBeansRetry', lang),
                      style: TextStyle(fontFamily: _montserrat, color: context.appTextSecondary),
                    ),
                  ),
                ),
              ),
              data: (beans) => beans.isEmpty
                  ? SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: Center(
                          child: Text(
                            AppStrings.get('noBeansAvailableYet', lang),
                            style: TextStyle(fontFamily: _montserrat, color: context.appTextSecondary),
                          ),
                        ),
                      ),
                    )
                  : SliverToBoxAdapter(
                      child: SizedBox(
                        height: 220,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: beans.length,
                          itemBuilder: (_, i) => _TrendingCard(
                            bean: beans[i],
                            color: _cardColors[i % _cardColors.length],
                            onTap: () => _openBean(context, beans[i]),
                          ),
                        ),
                      ),
                    ),
            ),

            // All listings header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 26, 20, 12),
                child: Row(
                  children: [
                    const _SectionMarker(),
                    const SizedBox(width: 8),
                    Text(
                      AppStrings.get('allBeans', lang),
                      style: const TextStyle(
                        fontFamily: _montserrat,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryDark,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            beansAsync.when(
              loading: () => const SliverToBoxAdapter(child: SizedBox.shrink()),
              error: (_, __) => const SliverToBoxAdapter(child: SizedBox.shrink()),
              data: (beans) => SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (_, i) => _GridBeanCard(
                      bean: beans[i],
                      color: _cardColors[i % _cardColors.length],
                      onTap: () => _openBean(context, beans[i]),
                    ),
                    childCount: beans.length,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: 0.70,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionMarker extends StatelessWidget {
  const _SectionMarker();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 4,
      height: 18,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

// Category chip
class _CategoryChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  const _CategoryChip({required this.label, this.selected = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : context.appTextSecondary,
          ),
        ),
      ),
    );
  }
}

// Trending card
class _TrendingCard extends StatelessWidget {
  final BeanEntity bean;
  final Color color;
  final VoidCallback onTap;

  const _TrendingCard({required this.bean, required this.color, required this.onTap});

  static const _montserrat = 'Montserrat';

  String? get _imageUrl =>
      bean.images.isNotEmpty ? ApiEndpoints.resolveImageUrl(bean.images.first) : null;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140,
        margin: const EdgeInsets.only(right: 14),
        decoration: BoxDecoration(
          color: context.appSurface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Container(
                height: 120,
                color: color,
                child: _imageUrl != null
                    ? CachedNetworkImage(
                        imageUrl: _imageUrl!,
                        width: double.infinity,
                        height: 120,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => _placeholder(),
                        errorWidget: (_, __, ___) => _placeholder(),
                      )
                    : _placeholder(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bean.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: _montserrat,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    bean.origin,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontFamily: _montserrat, fontSize: 10, color: context.appTextSecondary),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Rs. ${bean.price.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontFamily: _montserrat,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryDark,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder() {
    return Center(
      child: Icon(Icons.coffee, size: 48, color: AppColors.primary.withValues(alpha: 0.4)),
    );
  }
}

// Grid card
class _GridBeanCard extends StatelessWidget {
  final BeanEntity bean;
  final Color color;
  final VoidCallback onTap;

  const _GridBeanCard({required this.bean, required this.color, required this.onTap});

  static const _montserrat = 'Montserrat';

  String? get _imageUrl =>
      bean.images.isNotEmpty ? ApiEndpoints.resolveImageUrl(bean.images.first) : null;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: context.appSurface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Container(
                  color: color,
                  width: double.infinity,
                  child: _imageUrl != null
                      ? CachedNetworkImage(
                          imageUrl: _imageUrl!,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          placeholder: (_, __) => _placeholder(),
                          errorWidget: (_, __, ___) => _placeholder(),
                        )
                      : _placeholder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bean.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: _montserrat,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    bean.origin,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontFamily: _montserrat, fontSize: 10, color: context.appTextSecondary),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Rs. ${bean.price.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontFamily: _montserrat,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder() {
    return Center(
      child: Icon(Icons.coffee, size: 48, color: AppColors.primary.withValues(alpha: 0.4)),
    );
  }
}
