// lib/screens/project_details_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/project.dart';
import 'dashboard_screen.dart';
import 'add_project_screen.dart';

class ProjectDetailsScreen extends StatefulWidget {
  const ProjectDetailsScreen({super.key});

  static final List<Project> _projects = [
    Project(
        id: '1',
        name: 'Project Alpha',
        description: 'AI Integration for enhanced user experience with advanced machine learning capabilities',
        type: 'Web',
        members: ['User1', 'User2'],
        startDate: DateTime.now().subtract(const Duration(days: 30)),
        endDate: DateTime.now().add(const Duration(days: 60)),
        progress: 0.7,
        status: 'continue'
    ),
    Project(
        id: '2',
        name: 'Project Beta',
        description: 'Mobile App Development with Flutter and Firebase integration',
        type: 'Mobile',
        members: ['User3', 'User4', 'User5'],
        startDate: DateTime.now().subtract(const Duration(days: 15)),
        endDate: DateTime.now().add(const Duration(days: 45)),
        progress: 0.4,
        status: 'pending'
    ),
    Project(
        id: '3',
        name: 'Project Gamma',
        description: 'Backend API Optimization and microservices architecture',
        type: 'Backend',
        members: ['User6', 'User7'],
        startDate: DateTime.now().subtract(const Duration(days: 45)),
        endDate: DateTime.now().add(const Duration(days: 90)),
        progress: 0.9,
        status: 'approved'
    ),
    Project(
        id: '4',
        name: 'Project Delta',
        description: 'Cloud Infrastructure Migration and DevOps implementation',
        type: 'Infrastructure',
        members: ['User8', 'User9', 'User10'],
        startDate: DateTime.now().subtract(const Duration(days: 60)),
        endDate: DateTime.now().add(const Duration(days: 30)),
        progress: 0.6,
        status: 'onhold'
    ),
  ];

  @override
  State<ProjectDetailsScreen> createState() => _ProjectDetailsScreenState();
}

class _ProjectDetailsScreenState extends State<ProjectDetailsScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late List<Animation<double>> _staggerAnimations;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0;

  @override
  void initState() {
    super.initState();

    // Initialize controllers first
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Create animations with clamped values
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0, 0.5, curve: Curves.easeInOut),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 1, curve: Curves.easeOutCubic),
      ),
    );

    _staggerAnimations = List.generate(
      ProjectDetailsScreen._projects.length,
          (index) => Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(0.2 + (0.15 * index), 1.0, curve: Curves.elasticOut),
        ),
      ),
    );

    _scrollController.addListener(_onScroll);

    // Start animations after frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
      _pulseController.repeat(reverse: true);
    });
  }

  void _onScroll() {
    setState(() {
      _scrollOffset = _scrollController.offset;
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pulseController.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  List<Project> get _filteredProjects {
    if (_searchQuery.isEmpty) return ProjectDetailsScreen._projects;
    return ProjectDetailsScreen._projects.where((project) =>
    project.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        project.description.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
  }

  // Safe opacity getter that clamps values between 0 and 1
  double _getSafeOpacity(Animation<double> animation) {
    return animation.value.clamp(0.0, 1.0);
  }

  // Safe scale getter that prevents invalid values
  double _getSafeScale(Animation<double> animation) {
    return animation.value.clamp(0.01, 1.0); // Minimum scale of 0.01 to avoid invisible elements
  }

  @override
  Widget build(BuildContext context) {
    final filteredProjects = _filteredProjects;
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > 768;
    final appBarHeight = MediaQuery.of(context).padding.top + kToolbarHeight;

    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: AnimatedOpacity(
          opacity: _scrollOffset > 100 ? 1 : 0,
          duration: const Duration(milliseconds: 300),
          child: const Text(
            'Projects',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
        ),
        backgroundColor: _scrollOffset > 100 ? Colors.white.withOpacity(0.95) : Colors.transparent,
        elevation: _scrollOffset > 100 ? 4 : 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: _scrollOffset > 100 ? null : const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF1976D2),
                Color(0xFF7B1FA2),
              ],
            ),
          ),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
        actions: [
          IconButton(
            icon: const Icon(Icons.dashboard, color: Colors.white),
            onPressed: _navigateToDashboard,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Hero Section
          SliverToBoxAdapter(
            child: Container(
              height: 320,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF1976D2),
                    Color(0xFF7B1FA2),
                  ],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: Stack(
                children: [
                  // Background Pattern
                  _buildBackgroundPattern(),

                  // Content
                  Padding(
                    padding: EdgeInsets.only(
                      top: appBarHeight + 20,
                      left: 24,
                      right: 24,
                      bottom: 24,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SlideTransition(
                          position: _slideAnimation,
                          child: FadeTransition(
                            opacity: _fadeAnimation,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Project Portfolio',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    height: 1.2,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Manage and track all your projects in one place',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white.withOpacity(0.9),
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Search Bar
                        SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 0.5),
                            end: Offset.zero,
                          ).animate(CurvedAnimation(
                            parent: _animationController,
                            curve: const Interval(0.5, 1, curve: Curves.easeOut),
                          )),
                          child: FadeTransition(
                            opacity: _fadeAnimation,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                ),
                              ),
                              child: TextField(
                                controller: _searchController,
                                onChanged: (value) => setState(() => _searchQuery = value),
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: 'Search projects...',
                                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                                  prefixIcon: Icon(Icons.search, color: Colors.white.withOpacity(0.7)),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Projects Count
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${filteredProjects.length} Projects',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    'Sorted by: Recent',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Projects Grid/List
          isWideScreen ? _buildWideScreenGrid(filteredProjects) : _buildMobileList(filteredProjects),

          SliverToBoxAdapter(
            child: const SizedBox(height: 100),
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildBackgroundPattern() {
    return Positioned(
      right: -50,
      top: -50,
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              Colors.white.withOpacity(0.1),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWideScreenGrid(List<Project> projects) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          childAspectRatio: 1.6,
        ),
        delegate: SliverChildBuilderDelegate(
              (context, index) => _buildProjectCard(projects[index], index),
          childCount: projects.length,
        ),
      ),
    );
  }

  Widget _buildMobileList(List<Project> projects) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (context, index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: _buildProjectCard(projects[index], index),
        ),
        childCount: projects.length,
      ),
    );
  }

  Widget _buildProjectCard(Project project, int index) {
    final statusColor = _getStatusColor(project.status);
    final daysRemaining = project.endDate.difference(DateTime.now()).inDays;

    // Use safe animation values
    final animationIndex = index % _staggerAnimations.length;

    return AnimatedBuilder(
      animation: _staggerAnimations[animationIndex],
      builder: (context, child) {
        final safeOpacity = _getSafeOpacity(_staggerAnimations[animationIndex]);
        final safeScale = _getSafeScale(_staggerAnimations[animationIndex]);

        return Opacity(
          opacity: safeOpacity,
          child: Transform(
            transform: Matrix4.identity()
              ..scale(safeScale)
              ..translate(0.0, 100 * (1 - safeOpacity)),
            alignment: Alignment.center,
            child: child,
          ),
        );
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => _onCardTap(project.id),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Status Indicator Bar
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    width: 4,
                    decoration: BoxDecoration(
                      color: statusColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  project.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black87,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  project.type,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          _buildStatusBadge(project.status, statusColor),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Description
                      Text(
                        project.description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 20),

                      // Progress Section
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Progress',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              Text(
                                '${(project.progress * 100).toInt()}%',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: statusColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Stack(
                            children: [
                              Container(
                                height: 6,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  return AnimatedContainer(
                                    duration: const Duration(milliseconds: 800),
                                    curve: Curves.easeOut,
                                    height: 6,
                                    width: constraints.maxWidth * project.progress,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          statusColor,
                                          statusColor.withOpacity(0.7),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Footer
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Members
                          Row(
                            children: [
                              Icon(Icons.people_outline, size: 16, color: Colors.grey.shade600),
                              const SizedBox(width: 6),
                              Text(
                                '${project.members.length} members',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),

                          // Timeline
                          Row(
                            children: [
                              Icon(Icons.schedule, size: 16, color: Colors.grey.shade600),
                              const SizedBox(width: 6),
                              Text(
                                '$daysRemaining days left',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: daysRemaining < 7 ? const Color(0xFFF57C00) : Colors.grey.shade600,
                                  fontWeight: daysRemaining < 7 ? FontWeight.w600 : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Hover overlay
                Positioned.fill(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () => _onCardTap(project.id),
                      child: Container(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            status.toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return Transform.translate(
      offset: const Offset(0, -20),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF7B1FA2).withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          onPressed: _navigateToAddProject,
          icon: const Icon(Icons.add, color: Colors.white, size: 20),
          label: const Text(
            'New Project',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          backgroundColor: const Color(0xFF7B1FA2),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
    );
  }

  void _onCardTap(String projectId) {
    HapticFeedback.lightImpact();
    _navigateToProjectDetail(projectId);
  }

  void _navigateToDashboard() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const DashboardScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOutCubic,
            )),
            child: child,
          );
        },
      ),
    );
  }

  void _navigateToAddProject() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddProjectScreen(),
        fullscreenDialog: true,
      ),
    );
  }

  void _navigateToProjectDetail(String projectId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Project Detail'),
        content: Text('Details for project $projectId'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'onhold':
        return const Color(0xFFF57C00);
      case 'continue':
        return const Color(0xFF1976D2);
      case 'pending':
        return const Color(0xFFFFA000);
      case 'complete':
        return const Color(0xFF388E3C);
      case 'approved':
        return const Color(0xFF7B1FA2);
      default:
        return Colors.grey;
    }
  }
}
