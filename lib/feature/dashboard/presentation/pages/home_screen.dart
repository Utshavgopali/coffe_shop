import 'package:coffeshop_mobile/app/theme/app_colors.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const _montserrat = 'Montserrat';

  static const _beans = [
    _CoffeeBean(
      'Espresso',
      'Ethiopia',
      'Rs. 130',
      '4.8',
      'assets/images/coffee_1.jpg',
      'Dark Roast',
    ),
    _CoffeeBean(
      'Latte Blend',
      'Colombia',
      'Rs. 150',
      '4.7',
      'assets/images/coffee_4.jpg',
      'Medium Roast',
    ),
    _CoffeeBean(
      'Ristretto',
      'Brazil',
      'Rs. 300',
      '4.9',
      'assets/images/coffee_6.jpg',
      'Dark Roast',
    ),
    _CoffeeBean(
      'Cappuccino',
      'Kenya',
      'Rs. 220',
      '4.6',
      'assets/images/coffee_7.jpg',
      'Medium Roast',
    ),
    _CoffeeBean(
      'Americano',
      'Guatemala',
      'Rs. 120',
      '4.8',
      'assets/images/coffee_1.jpg',
      'Light Roast',
    ),
    _CoffeeBean(
      'Cold Brew',
      'Peru',
      'Rs. 180',
      '4.5',
      'assets/images/coffee_4.jpg',
      'Dark Roast',
    ),
    _CoffeeBean(
      'Flat White',
      'Indonesia',
      'Rs. 200',
      '4.7',
      'assets/images/coffee_6.jpg',
      'Medium Roast',
    ),
    _CoffeeBean(
      'Macchiato',
      'Yemen',
      'Rs. 160',
      '4.6',
      'assets/images/coffee_7.jpg',
      'Light Roast',
    ),
  ];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF6F1),
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
                      children: const [
                        Text(
                          'Good morning ☕',
                          style: TextStyle(
                            fontFamily: _montserrat,
                            fontSize: 13,
                            color: Colors.black45,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Find your perfect bean',
                          style: TextStyle(
                            fontFamily: _montserrat,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primaryDark,
                          ),
                        ),
                      ],
                    ),
                    CircleAvatar(
                      radius: 21,
                      backgroundColor: AppColors.primary,
                      child: const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Search bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
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
                    style: const TextStyle(
                      fontFamily: _montserrat,
                      fontSize: 13,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search coffee beans, origins…',
                      hintStyle: const TextStyle(
                        fontFamily: _montserrat,
                        fontSize: 13,
                        color: Colors.black38,
                      ),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Colors.black38,
                        size: 20,
                      ),
                      suffixIcon: Container(
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.primaryDark,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.tune,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                      border: InputBorder.none,
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 14),
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
                    children: const [
                      _CategoryChip(label: 'All', selected: true),
                      _CategoryChip(label: 'Dark Roast'),
                      _CategoryChip(label: 'Medium Roast'),
                      _CategoryChip(label: 'Light Roast'),
                      _CategoryChip(label: 'Blends'),
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
                        const Text(
                          'Trending Beans',
                          style: TextStyle(
                            fontFamily: _montserrat,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primaryDark,
                          ),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        'See all',
                        style: TextStyle(
                          fontFamily: _montserrat,
                          fontSize: 12,
                          color: Colors.black45,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Trending horizontal list
            SliverToBoxAdapter(
              child: SizedBox(
                height: 220,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: _beans.length,
                  itemBuilder: (_, i) => _TrendingCard(
                    bean: _beans[i],
                    color: _cardColors[i % _cardColors.length],
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
                    Container(
                      width: 4,
                      height: 18,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'All Beans',
                      style: TextStyle(
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

            // All listings grid
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (_, i) => _GridBeanCard(
                    bean: _beans[i % _beans.length],
                    color: _cardColors[i % _cardColors.length],
                  ),
                  childCount: _beans.length,
                ),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 0.70,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Data model
class _CoffeeBean {
  final String name;
  final String origin;
  final String price;
  final String rating;
  final String image;
  final String roast;

  const _CoffeeBean(
    this.name,
    this.origin,
    this.price,
    this.rating,
    this.image,
    this.roast,
  );
}

// Category chip
class _CategoryChip extends StatelessWidget {
  final String label;
  final bool selected;

  const _CategoryChip({required this.label, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? AppColors.primary : Colors.white,
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
          color: selected ? Colors.white : Colors.black54,
        ),
      ),
    );
  }
}

// Trending card
class _TrendingCard extends StatelessWidget {
  final _CoffeeBean bean;
  final Color color;

  const _TrendingCard({required this.bean, required this.color});

  static const _montserrat = 'Montserrat';

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 14),
      decoration: BoxDecoration(
        color: Colors.white,
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
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(16)),
            child: Container(
              height: 120,
              color: color,
              child: Image.asset(
                bean.image,
                width: double.infinity,
                height: 120,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Center(
                  child: Icon(
                    Icons.coffee,
                    size: 48,
                    color: AppColors.primary.withValues(alpha: 0.4),
                  ),
                ),
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
                  style: const TextStyle(
                    fontFamily: _montserrat,
                    fontSize: 10,
                    color: Colors.black45,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    bean.roast,
                    style: const TextStyle(
                      fontFamily: _montserrat,
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      bean.price,
                      style: const TextStyle(
                        fontFamily: _montserrat,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryDark,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          size: 12,
                          color: Color(0xFFFFA726),
                        ),
                        const SizedBox(width: 2),
                        Text(
                          bean.rating,
                          style: const TextStyle(
                            fontFamily: _montserrat,
                            fontSize: 10,
                            color: Colors.black45,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Grid card
class _GridBeanCard extends StatelessWidget {
  final _CoffeeBean bean;
  final Color color;

  const _GridBeanCard({required this.bean, required this.color});

  static const _montserrat = 'Montserrat';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
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
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: Container(
                color: color,
                child: Image.asset(
                  bean.image,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Center(
                    child: Icon(
                      Icons.coffee,
                      size: 48,
                      color: AppColors.primary.withValues(alpha: 0.4),
                    ),
                  ),
                ),
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
                  style: const TextStyle(
                    fontFamily: _montserrat,
                    fontSize: 10,
                    color: Colors.black45,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      bean.price,
                      style: const TextStyle(
                        fontFamily: _montserrat,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryDark,
                      ),
                    ),
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}