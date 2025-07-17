import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/member_provider.dart';
import '../widgets/quick_action_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final memberProvider = Provider.of<MemberProvider>(
        context,
        listen: false,
      );
      memberProvider.loadMemberData('MEM001');
      memberProvider.loadCurrentLoan('MEM001');
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        break;
      case 1:
        Navigator.pushNamed(context, '/transactions');
        break;
      case 2:
        Navigator.pushNamed(context, '/contact');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text(
            'Dashboard',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
          ),
          centerTitle: true,
          automaticallyImplyLeading: kIsWeb,
          leading: kIsWeb
              ? IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black87),
                  onPressed: () => Navigator.of(
                    context,
                    rootNavigator: true,
                  ).pushNamed('/login'),
                )
              : null,
          actions: [
            IconButton(
              icon: const Icon(Icons.menu, color: Colors.black87, size: 28),
              onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
            ),
          ],
          elevation: 0,
          backgroundColor: Colors.white,
        ),
        endDrawer: _buildDrawer(),
        body: SafeArea(
          child: Consumer<MemberProvider>(
            builder: (context, memberProvider, child) {
              if (memberProvider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              final memberData = memberProvider.memberData;
              if (memberData == null) {
                return const Center(child: Text('Failed to load member data'));
              }

              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(isSmallScreen ? 16.0 : 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Welcome Section
                      Text(
                        'Hello, Member!',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 24 : 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Manage your finances with ease.',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 14 : 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Balance Cards - Grid Layout
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: isSmallScreen ? 2 : 4,
                        crossAxisSpacing: isSmallScreen ? 12 : 16,
                        mainAxisSpacing: isSmallScreen ? 12 : 16,
                        children: [
                          _buildBalanceCard(
                            'Savings',
                            _formatCurrency(memberData.savingsBalance),
                            Colors.green[100]!,
                            isSmallScreen,
                          ),
                          _buildBalanceCard(
                            'Loans',
                            _formatCurrency(memberData.loansBalance),
                            Colors.orange[100]!,
                            isSmallScreen,
                          ),
                          _buildCapitalShareCard(
                            memberData.capitalShares.toInt(),
                            memberData.sharePercent,
                            Colors.blue[100]!,
                            isSmallScreen,
                          ),
                          _buildBalanceCard(
                            'Guarantee-able',
                            _formatCurrency(memberData.guaranteeableAmount),
                            Colors.yellow[100]!,
                            isSmallScreen,
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // Quick Actions Section
                      Text(
                        'Quick Actions',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 18 : 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 16),
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: isSmallScreen ? 2 : 3,
                        crossAxisSpacing: isSmallScreen ? 12 : 16,
                        mainAxisSpacing: isSmallScreen ? 12 : 16,
                        children: [
                          QuickActionButton(
                            title: 'Save',
                            icon: Icons.savings,
                            onPressed: () => Navigator.pushNamed(
                              context,
                              '/savings-payment',
                            ),
                            backgroundColor: Colors.green[50]!,
                            isSmallScreen: isSmallScreen,
                          ),
                          QuickActionButton(
                            title: 'Loan Request',
                            icon: Icons.request_quote,
                            onPressed: () =>
                                Navigator.pushNamed(context, '/loan-request'),
                            backgroundColor: Colors.green[50]!,
                            isSmallScreen: isSmallScreen,
                          ),
                          QuickActionButton(
                            title: 'Pay Loan',
                            icon: Icons.payment,
                            onPressed: () =>
                                Navigator.pushNamed(context, '/loan-payment'),
                            backgroundColor: Colors.green[50]!,
                            isSmallScreen: isSmallScreen,
                          ),
                          QuickActionButton(
                            title: 'Top-Up Capital',
                            icon: Icons.trending_up,
                            onPressed: () =>
                                Navigator.pushNamed(context, '/capital-topup'),
                            backgroundColor: Colors.green[50]!,
                            isSmallScreen: isSmallScreen,
                          ),
                          QuickActionButton(
                            title: 'History',
                            icon: Icons.history,
                            onPressed: () =>
                                Navigator.pushNamed(context, '/transactions'),
                            backgroundColor: Colors.green[50]!,
                            isSmallScreen: isSmallScreen,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long),
              label: 'Transactions',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.support_agent),
              label: 'Contact',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.green[700],
          unselectedItemColor: Colors.grey[500],
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 50, 16, 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green[700]!, Colors.green[500]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 50, color: Colors.green),
                ),
                SizedBox(height: 12),
                Text(
                  'Member Dashboard',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.person_outline,
                    color: Colors.black87,
                  ),
                  title: const Text(
                    'Profile',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  onTap: () => Navigator.pushNamed(context, '/profile'),
                ),
                ListTile(
                  leading: const Icon(Icons.settings, color: Colors.black87),
                  title: const Text(
                    'Settings',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  onTap: () => Navigator.pushNamed(context, '/settings'),
                ),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.black87),
                  title: const Text(
                    'Logout',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  onTap: () => Navigator.pushNamed(context, '/login'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatCurrency(double amount) {
    String amountStr = amount.toStringAsFixed(2);
    List<String> parts = amountStr.split('.');
    String integerPart = parts[0];
    String decimalPart = parts[1];

    String formattedInteger = '';
    for (int i = 0; i < integerPart.length; i++) {
      if (i > 0 && (integerPart.length - i) % 3 == 0) {
        formattedInteger += ',';
      }
      formattedInteger += integerPart[i];
    }

    return 'KSH $formattedInteger.$decimalPart';
  }

  Widget _buildBalanceCard(
    String title,
    String value,
    Color backgroundColor,
    bool isSmallScreen,
  ) {
    // Anfal Sacco brand colors
    final Color primaryRed = Color(0xFFD44A5B);
    final Color lightGreen = Color(0xFF8BC34A);
    final Color grayText = Color(0xFF6B6B6B);
    final Color lightBackground = Color(0xFFF5F5F5);

    return Card(
      elevation: 6,
      shadowColor: grayText.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, lightBackground],
          ),
          border: Border.all(color: lightGreen.withOpacity(0.3), width: 1),
          boxShadow: [
            BoxShadow(
              color: grayText.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Container(
          padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon container
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: primaryRed,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getIconForTitle(title),
                  size: isSmallScreen ? 24 : 28,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: isSmallScreen ? 13 : 15,
                  fontWeight: FontWeight.w600,
                  color: grayText,
                  letterSpacing: 0.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: TextStyle(
                  fontSize: isSmallScreen ? 20 : 24,
                  fontWeight: FontWeight.bold,
                  color: primaryRed,
                  letterSpacing: 0.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              // Subtle bottom accent
              Container(
                width: 40,
                height: 3,
                decoration: BoxDecoration(
                  color: lightGreen,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCapitalShareCard(
    int shares,
    double percent,
    Color backgroundColor,
    bool isSmallScreen,
  ) {
    // Anfal Sacco brand colors
    final Color primaryRed = Color(0xFFD44A5B);
    final Color lightGreen = Color(0xFF8BC34A);
    final Color grayText = Color(0xFF6B6B6B);
    final Color lightBackground = Color(0xFFF5F5F5);

    return Card(
      elevation: 6,
      shadowColor: grayText.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, lightBackground],
          ),
          border: Border.all(color: lightGreen.withOpacity(0.3), width: 1),
          boxShadow: [
            BoxShadow(
              color: grayText.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Container(
          padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon container
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: primaryRed,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.pie_chart,
                  size: isSmallScreen ? 24 : 28,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Capital Share',
                style: TextStyle(
                  fontSize: isSmallScreen ? 13 : 15,
                  fontWeight: FontWeight.w600,
                  color: grayText,
                  letterSpacing: 0.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildMetricColumn(
                    'Shares',
                    shares.toString(),
                    isSmallScreen,
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    color: lightGreen.withOpacity(0.4),
                  ),
                  _buildMetricColumn(
                    'Percent',
                    '${percent.toStringAsFixed(1)}%',
                    isSmallScreen,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Progress indicator
              Container(
                width: double.infinity,
                height: 4,
                decoration: BoxDecoration(
                  color: lightBackground,
                  borderRadius: BorderRadius.circular(2),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: (percent / 100).clamp(0.0, 1.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: lightGreen,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricColumn(String label, String value, bool isSmallScreen) {
    // Anfal Sacco brand colors
    final Color primaryRed = Color(0xFFD44A5B);
    final Color grayText = Color(0xFF6B6B6B);

    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isSmallScreen ? 11 : 13,
            fontWeight: FontWeight.w500,
            color: grayText.withOpacity(0.8),
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: isSmallScreen ? 18 : 20,
            fontWeight: FontWeight.bold,
            color: primaryRed,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  // Helper function to get appropriate icons for different card types
  IconData _getIconForTitle(String title) {
    switch (title.toLowerCase()) {
      case 'savings':
      case 'savings account':
        return Icons.savings;
      case 'loan':
      case 'loan balance':
        return Icons.account_balance;
      case 'deposits':
        return Icons.account_balance_wallet;
      case 'withdrawals':
        return Icons.money_off;
      case 'interest':
        return Icons.trending_up;
      case 'dividends':
        return Icons.monetization_on;
      default:
        return Icons.account_balance_wallet;
    }
  }
}
