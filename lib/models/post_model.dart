enum PostCategory { all, myDept, events, opportunities, marketplace }

extension PostCategoryExtension on PostCategory {
  String get label {
    switch (this) {
      case PostCategory.all:
        return 'All';
      case PostCategory.myDept:
        return 'My Dept (CS)';
      case PostCategory.events:
        return 'Events';
      case PostCategory.opportunities:
        return 'Opportunities';
      case PostCategory.marketplace:
        return 'Marketplace';
    }
  }
}

class PostModel {
  PostModel({
    required this.id,
    required this.authorName,
    required this.authorAvatar,
    required this.departmentTag,
    this.isVerified = true,
    required this.content,
    required this.category,
    this.imagePath,
    this.likesCount = 0,
    this.commentsCount = 0,
    this.isLiked = false,
    this.isBookmarked = false,
    required this.timeAgo,
  });

  final String id;
  final String authorName;
  final String authorAvatar;
  final String departmentTag;
  final bool isVerified;
  final String content;
  final PostCategory category;
  final String? imagePath;
  int likesCount;
  int commentsCount;
  bool isLiked;
  bool isBookmarked;
  final String timeAgo;
}

final List<PostModel> samplePosts = [
  PostModel(
    id: '1',
    authorName: 'BUK Developers Club',
    authorAvatar: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=250',
    departmentTag: 'Tech & Devs',
    isVerified: true,
    content:
        '🚀 BUK Hackathon 2026 Registration is NOW OPEN! Join 200+ student developers at New Campus Computer Lab. Cash prizes & internship opportunities for top 3 teams!',
    category: PostCategory.events,
    timeAgo: '25m ago',
    likesCount: 142,
    commentsCount: 38,
    isLiked: true,
  ),
  PostModel(
    id: '2',
    authorName: 'Farouk Usman',
    authorAvatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&q=80&w=250',
    departmentTag: 'Computer Sci 300L',
    isVerified: true,
    content:
        'Does anyone have past questions for CSC 3301 (Operating Systems 1)? We are forming a weekend study group at the Faculty Library. Drop a comment to join!',
    category: PostCategory.myDept,
    timeAgo: '1h ago',
    likesCount: 45,
    commentsCount: 19,
  ),
  PostModel(
    id: '3',
    authorName: 'Aisha Lawal',
    authorAvatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&q=80&w=250',
    departmentTag: 'Economics 400L',
    isVerified: true,
    content:
        'Selling my clean HP Laptop (Core i5, 8GB RAM, 256GB SSD) in great condition! Perfect for research & coursework. DM or comment if interested. Pickup at Old Campus.',
    category: PostCategory.marketplace,
    timeAgo: '3h ago',
    likesCount: 29,
    commentsCount: 12,
  ),
  PostModel(
    id: '4',
    authorName: 'NITDA Graduate Scheme',
    authorAvatar: 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?auto=format&fit=crop&q=80&w=250',
    departmentTag: 'Opportunity Alert',
    isVerified: true,
    content:
        '💡 2026 Tech Fellowship applications are live for final year Nigerian university students. Fully funded 6-month training + laptop grant.',
    category: PostCategory.opportunities,
    timeAgo: '5h ago',
    likesCount: 210,
    commentsCount: 64,
  ),
];
