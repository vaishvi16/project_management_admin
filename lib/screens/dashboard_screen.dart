// lib/screens/dashboard_screen.dart
import 'package:flutter/material.dart';
import '../models/project.dart';
import 'add_user_screen.dart';
import 'add_project_screen.dart';
import 'history_screen.dart';
import 'project_details_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _expanded = false;

  // Demo data
  static final List<Map<String, dynamic>> _logs = [
    {
      'id': '1',
      'project': 'Alpha',
      'progress': 0.7,
      'status': 'continue',
      'details': 'Updated UI components and implemented new features',
      'time': '2 hours ago',
      'user': 'Alex Johnson'
    },
    {
      'id': '2',
      'project': 'Beta',
      'progress': 0.4,
      'status': 'pending',
      'details': 'Waiting for client approval on design mockups',
      'time': '5 hours ago',
      'user': 'Sarah Chen'
    },
    {
      'id': '3',
      'project': 'Gamma',
      'progress': 0.9,
      'status': 'approved',
      'details': 'Final testing completed successfully',
      'time': '1 day ago',
      'user': 'Mike Rodriguez'
    },
    {
      'id': '4',
      'project': 'Delta',
      'progress': 0.6,
      'status': 'continue',
      'details': 'Backend API integration in progress',
      'time': '2 days ago',
      'user': 'Emily Watson'
    },
  ];

  static final Map<String, int> _statusCounts = {
    'onhold': 2,
    'continue': 5,
    'pending': 3,
    'complete': 4,
    'approved': 2,
  };

  static final Map<String, dynamic> _stats = {
    'totalProjects': 16,
    'completed': 4,
    'inProgress': 7,
    'teamMembers': 12,
    'efficiency': 78,
  };

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0, 0.6, curve: Curves.easeInOut),
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

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > 768;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: const Text(
                    'Dashboard',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF1976D2), // Blue 700
                      Color(0xFF7B1FA2), // Purple 600
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.history, color: Colors.white, size: 20),
                ),
                onPressed: _navigateToHistory,
              ),
              const SizedBox(width: 8),
            ],
          ),

          // Dashboard Content
          SliverPadding(
            padding: const EdgeInsets.all(16), // Reduced padding to prevent overflow
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Welcome Section
                _buildWelcomeSection(),
                const SizedBox(height: 24),

                // Stats Grid
                _buildStatsGrid(),
                const SizedBox(height: 24),

                // Charts Section - Removed charts, keeping the space
                const SizedBox(height: 24),

                // Quick Actions
                _buildQuickActions(),
                const SizedBox(height: 24),

                // Activity Logs
                _buildActivityLogs(),
                const SizedBox(height: 24), // Extra bottom padding
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFE3F2FD), // Blue 50
                Color(0xFFF3E5F5), // Purple 50
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF90CAF9)), // Blue 200
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome back!',
                      style: TextStyle(
                        fontSize: 20, // Slightly smaller
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF1565C0), // Blue 800
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'You have ${_stats['inProgress']} projects in progress. '
                          '${_stats['completed']} completed this month.',
                      style: TextStyle(
                        fontSize: 14, // Smaller font
                        color: Colors.grey.shade700,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox( // Constrained button size
                      height: 44,
                      child: ElevatedButton(
                        onPressed: _navigateToProjects,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1976D2), // Blue 600
                          foregroundColor: Colors.white,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'View All Projects',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Container(
                width: 60, // Smaller icon container
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF1976D2).withOpacity(0.3),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.rocket_launch,
                  size: 30,
                  color: const Color(0xFF1976D2), // Blue 600
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsGrid() {
    final stats = [
      {
        'title': 'Total Projects',
        'value': _stats['totalProjects'].toString(),
        'icon': Icons.assignment,
        'color': const Color(0xFF1976D2), // Blue
        'change': '+12%',
      },
      {
        'title': 'In Progress',
        'value': _stats['inProgress'].toString(),
        'icon': Icons.trending_up,
        'color': const Color(0xFFF57C00), // Orange
        'change': '+5%',
      },
      {
        'title': 'Completed',
        'value': _stats['completed'].toString(),
        'icon': Icons.check_circle,
        'color': const Color(0xFF388E3C), // Green
        'change': '+8%',
      },
      {
        'title': 'Team Efficiency',
        'value': '${_stats['efficiency']}%',
        'icon': Icons.bolt,
        'color': const Color(0xFF7B1FA2), // Purple
        'change': '+3%',
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.1, // Adjusted aspect ratio
      ),
      itemCount: stats.length,
      itemBuilder: (context, index) {
        final stat = stats[index];
        final Color color = stat['color'] as Color;

        return AnimatedContainer(
          duration: Duration(milliseconds: 600 + (index * 200)),
          curve: Curves.easeOut,
          margin: EdgeInsets.only(
              top: index.isEven ? 0 : 10,
              bottom: index.isEven ? 10 : 0
          ),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.5),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: _animationController,
                curve: Interval(0.1 * index, 1, curve: Curves.easeOut),
              )),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(
                    color: Colors.grey.shade100,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            stat['icon'] as IconData,
                            color: color,
                            size: 18,
                          ),
                        ),
                        Text(
                          stat['change'] as String,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF388E3C), // Green
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          stat['value'] as String,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          stat['title'] as String,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuickActions() {
    final actions = [
      {
        'title': 'Add Project',
        'icon': Icons.add_circle,
        'color': const Color(0xFF1976D2), // Blue
        'onTap': _navigateToAddProject,
      },
      {
        'title': 'Add Team',
        'icon': Icons.group_add,
        'color': const Color(0xFF388E3C), // Green
        'onTap': _navigateToAddUser,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 3.0, // Adjusted for better fit
          ),
          itemCount: actions.length,
          itemBuilder: (context, index) {
            final action = actions[index];
            final Color color = action['color'] as Color;

            return Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: action['onTap'] as void Function()?,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: color.withOpacity(0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        action['icon'] as IconData,
                        color: color,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          action['title'] as String,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: color,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildActivityLogs() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => setState(() => _expanded = !_expanded),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: _expanded
                        ? BorderSide(color: Colors.grey.shade200)
                        : BorderSide.none,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Recent Activity',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Latest project updates',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    AnimatedRotation(
                      turns: _expanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 300),
                      child: Icon(
                        Icons.expand_more,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Logs List
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            child: _expanded
                ? Column(
              children: _logs.map((log) => _buildLogItem(log)).toList(),
            )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildLogItem(Map<String, dynamic> log) {
    final statusColor = _getStatusColor(log['status']);
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade100,
            width: 1,
          ),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: log['progress'],
                strokeWidth: 2,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(statusColor),
              ),
              Text(
                '${(log['progress'] * 100).toInt()}',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: statusColor,
                ),
              ),
            ],
          ),
        ),
        title: Text(
          '${log['project']} • ${log['user']}',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 2),
            Text(
              log['details'],
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade700,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              log['time'],
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          icon: Icon(Icons.more_vert, color: Colors.grey.shade500, size: 20),
          onSelected: (value) => _handleLogAction(value, log),
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'view', child: Text('View Details')),
            const PopupMenuItem(value: 'edit', child: Text('Edit Log')),
            const PopupMenuDivider(),
            PopupMenuItem(
              value: 'delete',
              child: Text(
                'Delete',
                style: TextStyle(color: Colors.red.shade600),
              ),
            ),
          ],
        ),
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

  void _handleLogAction(String action, Map<String, dynamic> log) {
    switch (action) {
      case 'view':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Viewing ${log['project']} details'),
            backgroundColor: const Color(0xFF1976D2),
          ),
        );
        break;
      case 'edit':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Editing ${log['project']} log'),
            backgroundColor: const Color(0xFFF57C00),
          ),
        );
        break;
      case 'delete':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Deleted ${log['project']} log'),
            backgroundColor: Colors.red.shade600,
          ),
        );
        break;
    }
  }

  void _navigateToHistory() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HistoryScreen()),
    );
  }

  void _navigateToAddProject() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddProjectScreen()),
    );
  }

  void _navigateToAddUser() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddUserScreen()),
    );
  }

  void _navigateToProjects() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProjectDetailsScreen()),
    );
  }
}