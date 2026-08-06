import 'package:flutter/material.dart';

import '../models/post_model.dart';
import '../theme/app_theme.dart';
import '../widgets/post_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PostCategory _selectedCategory = PostCategory.all;

  List<PostModel> get _filteredPosts {
    if (_selectedCategory == PostCategory.all) return samplePosts;
    return samplePosts.where((post) => post.category == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar Header
            const _CampusHeader(),

            // Scrollable Campus Feed Content
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  const SizedBox(height: 12),

                  // Campus Spotlights / Story Ring Bar
                  const _CampusSpotlightsBar(),
                  const SizedBox(height: 16),

                  // Category Filter Chips
                  _CategoryFilterChips(
                    selectedCategory: _selectedCategory,
                    onCategorySelected: (category) {
                      setState(() => _selectedCategory = category);
                    },
                  ),
                  const SizedBox(height: 16),

                  // Create Post Prompt Box
                  const _CreatePostPrompt(),
                  const SizedBox(height: 16),

                  // Feed Section Title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedCategory == PostCategory.all
                            ? 'Campus Feed'
                            : _selectedCategory.label,
                        style: const TextStyle(
                          fontFamily: kHeadlineFontFamily,
                          fontSize: 22,
                          color: AppColors.primaryDark,
                        ),
                      ),
                      const Text(
                        'Recent',
                        style: TextStyle(
                          fontFamily: kBodyFontFamily,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.slate,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Dynamic Post Feed
                  if (_filteredPosts.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(32),
                      alignment: Alignment.center,
                      child: const Column(
                        children: [
                          Icon(
                            Icons.forum_outlined,
                            size: 40,
                            color: AppColors.slate,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'No posts in this category yet',
                            style: TextStyle(
                              fontFamily: kBodyFontFamily,
                              fontSize: 14,
                              color: AppColors.slate,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    ..._filteredPosts.map((post) => PostCard(post: post)),

                  const SizedBox(height: 80), // Padding above bottom nav
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CampusHeader extends StatelessWidget {
  const _CampusHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Logo & Campus Badge
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'UniVerse',
                    style: TextStyle(
                      fontFamily: kLogoFontFamily,
                      fontSize: 24,
                      color: AppColors.primary,
                    ),
                  ),
                  Row(
                    children: const [
                      Icon(
                        Icons.location_on_rounded,
                        size: 11,
                        color: AppColors.primary,
                      ),
                      SizedBox(width: 3),
                      Text(
                        'Bayero University Kano',
                        style: TextStyle(
                          fontFamily: kBodyFontFamily,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.slate,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),

              // Notification Bell & Search
              Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.search_rounded, size: 22),
                    color: const Color(0xFF334155),
                  ),
                  Stack(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.notifications_none_rounded, size: 23),
                        color: const Color(0xFF334155),
                      ),
                      Positioned(
                        right: 12,
                        top: 12,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFFEF4444),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CampusSpotlightsBar extends StatelessWidget {
  const _CampusSpotlightsBar();

  static const _spotlights = [
    {'title': 'BUK News', 'icon': Icons.campaign_rounded, 'color': Color(0xFF295EAD)},
    {'title': 'Tech Fest', 'icon': Icons.code_rounded, 'color': Color(0xFF6366F1)},
    {'title': 'SU Elections', 'icon': Icons.how_to_vote_rounded, 'color': Color(0xFFEC4899)},
    {'title': 'Timetables', 'icon': Icons.calendar_month_rounded, 'color': Color(0xFF10B981)},
    {'title': 'Lost&Found', 'icon': Icons.search_rounded, 'color': Color(0xFFF59E0B)},
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 86,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _spotlights.length,
        separatorBuilder: (context, index) => const SizedBox(width: 14),
        itemBuilder: (context, index) {
          final spotlight = _spotlights[index];
          final color = spotlight['color'] as Color;
          final icon = spotlight['icon'] as IconData;
          final title = spotlight['title'] as String;

          return Column(
            children: [
              Container(
                width: 58,
                height: 58,
                padding: const EdgeInsets.all(2.5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [color, color.withValues(alpha: 0.4)],
                  ),
                ),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(icon, color: color, size: 24),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                title,
                style: const TextStyle(
                  fontFamily: kBodyFontFamily,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF475569),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _CategoryFilterChips extends StatelessWidget {
  const _CategoryFilterChips({
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  final PostCategory selectedCategory;
  final ValueChanged<PostCategory> onCategorySelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: PostCategory.values.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = PostCategory.values[index];
          final isSelected = category == selectedCategory;

          return ChoiceChip(
            label: Text(category.label),
            selected: isSelected,
            onSelected: (_) => onCategorySelected(category),
            selectedColor: AppColors.primary,
            backgroundColor: Colors.white,
            side: BorderSide(
              color: isSelected ? AppColors.primary : const Color(0xFFE2E8F0),
            ),
            labelStyle: TextStyle(
              fontFamily: kBodyFontFamily,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? Colors.white : const Color(0xFF475569),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          );
        },
      ),
    );
  }
}

class _CreatePostPrompt extends StatelessWidget {
  const _CreatePostPrompt();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFEDF2F7)),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.primary,
            child: Icon(Icons.person, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'What\'s happening on campus?',
              style: TextStyle(
                fontFamily: kBodyFontFamily,
                fontSize: 13,
                color: AppColors.slate,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Row(
              children: [
                Icon(Icons.add_rounded, size: 16, color: AppColors.primary),
                SizedBox(width: 4),
                Text(
                  'Post',
                  style: TextStyle(
                    fontFamily: kBodyFontFamily,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
