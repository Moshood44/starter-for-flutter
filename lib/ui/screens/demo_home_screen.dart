import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskpay/ui/theme/theme_provider.dart';
import 'package:taskpay/ui/components/buttons/app_button.dart';
import 'package:taskpay/ui/components/cards/app_card.dart';
import 'package:taskpay/ui/components/inputs/app_text_field.dart';
import 'package:taskpay/ui/navigation/app_router.dart';

class DemoHomeScreen extends StatefulWidget {
  const DemoHomeScreen({super.key});

  @override
  State<DemoHomeScreen> createState() => _DemoHomeScreenState();
}

class _DemoHomeScreenState extends State<DemoHomeScreen> {
  final _searchController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _selectedCategory;

  @override
  void dispose() {
    _searchController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TaskPay Demo'),
        actions: [
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return IconButton(
                icon: Icon(themeProvider.themeModeIcon),
                onPressed: themeProvider.toggleTheme,
                tooltip: 'Switch to ${_getNextThemeMode(themeProvider.themeMode)}',
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => AppRouter.pushNamed(context, AppRouter.themeSettings),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Search'),
            AppSearchField(
              hint: 'Search for tasks...',
              controller: _searchController,
              onChanged: (value) {
                // Handle search
              },
            ),
            const SizedBox(height: 24),
            
            _buildSectionTitle('Sample Task Cards'),
            TaskCard(
              title: 'Help with Data Structures Assignment',
              description: 'I need help understanding binary trees and implementing them in Python. The assignment is due next week and I\'m struggling with the concepts.',
              category: 'Academic',
              budget: '₦5,000',
              deadline: '2 days left',
              location: 'University of Lagos',
              tags: ['Python', 'Data Structures', 'Programming'],
              onTap: () => AppRouter.pushNamed(
                context, 
                AppRouter.taskDetails,
                arguments: 'task-123',
              ),
            ),
            const SizedBox(height: 12),
            TaskCard(
              title: 'Food Delivery from Campus Cafeteria',
              description: 'Need someone to pick up lunch from the cafeteria and deliver to my dorm room. I\'m sick and can\'t leave my room.',
              category: 'Delivery',
              budget: '₦2,000',
              deadline: '1 hour left',
              location: 'UNILAG Campus',
              tags: ['Food', 'Delivery', 'Urgent'],
              onTap: () => AppRouter.pushNamed(
                context, 
                AppRouter.taskDetails,
                arguments: 'task-456',
              ),
            ),
            const SizedBox(height: 24),
            
            _buildSectionTitle('Form Components'),
            AppTextField(
              label: 'Email Address',
              hint: 'Enter your email',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              prefixIcon: const Icon(Icons.email),
            ),
            const SizedBox(height: 16),
            AppTextField(
              label: 'Password',
              hint: 'Enter your password',
              controller: _passwordController,
              obscureText: true,
              prefixIcon: const Icon(Icons.lock),
            ),
            const SizedBox(height: 16),
            AppDropdownField<String>(
              label: 'Task Category',
              hint: 'Select a category',
              value: _selectedCategory,
              items: const [
                DropdownMenuItem(value: 'academic', child: Text('Academic')),
                DropdownMenuItem(value: 'delivery', child: Text('Delivery')),
                DropdownMenuItem(value: 'errands', child: Text('Errands')),
                DropdownMenuItem(value: 'food', child: Text('Food & Drink')),
                DropdownMenuItem(value: 'other', child: Text('Other')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value;
                });
              },
              prefixIcon: const Icon(Icons.category),
            ),
            const SizedBox(height: 24),
            
            _buildSectionTitle('Button Components'),
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: AppButton.primary(
                        text: 'Primary Button',
                        onPressed: () => _showSnackBar('Primary button pressed'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppButton.secondary(
                        text: 'Secondary',
                        onPressed: () => _showSnackBar('Secondary button pressed'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: AppButton.outline(
                        text: 'Outline Button',
                        onPressed: () => _showSnackBar('Outline button pressed'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppButton.text(
                        text: 'Text Button',
                        onPressed: () => _showSnackBar('Text button pressed'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                AppButton.primary(
                  text: 'Button with Icon',
                  icon: Icons.add,
                  isFullWidth: true,
                  onPressed: () => _showSnackBar('Icon button pressed'),
                ),
                const SizedBox(height: 12),
                AppButton.primary(
                  text: 'Loading Button',
                  isLoading: true,
                  isFullWidth: true,
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            _buildSectionTitle('Navigation Demo'),
            AppCard(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text('Profile'),
                    subtitle: const Text('View and edit your profile'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () => AppRouter.pushNamed(context, AppRouter.profile),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.task),
                    title: const Text('My Tasks'),
                    subtitle: const Text('View your posted and assigned tasks'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () => AppRouter.pushNamed(context, AppRouter.myTasks),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.search),
                    title: const Text('Discover Tasks'),
                    subtitle: const Text('Find tasks to work on'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () => AppRouter.pushNamed(context, AppRouter.taskDiscovery),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.wallet),
                    title: const Text('Wallet'),
                    subtitle: const Text('Manage your earnings and payments'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () => AppRouter.pushNamed(context, AppRouter.wallet),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => AppRouter.pushNamed(context, AppRouter.createTask),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  String _getNextThemeMode(AppThemeMode currentMode) {
    switch (currentMode) {
      case AppThemeMode.light:
        return 'Dark';
      case AppThemeMode.dark:
        return 'System';
      case AppThemeMode.system:
        return 'Light';
    }
  }
}