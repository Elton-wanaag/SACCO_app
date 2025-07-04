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
    // Load member data when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final memberProvider = Provider.of<MemberProvider>(context, listen: false);
      memberProvider.loadMemberData('MEM001'); // Mock member number
      memberProvider.loadCurrentLoan('MEM001');
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        // Already on home
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
        // Handle back button - navigate to welcome screen instead of exiting
        Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text(
            'HOME',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          // Remove back button for non-web platforms
          automaticallyImplyLeading: kIsWeb,
          leading: kIsWeb
              ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.of(context, rootNavigator: true).pushNamed('/login'),
                )
              : null,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: IconButton(
                icon: const Icon(
                  Icons.menu,
                  color: Colors.black,
                  size: 24,
                ),
                onPressed: () {
                  _scaffoldKey.currentState?.openEndDrawer();
                },
              ),
            ),
          ],
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
                  padding: EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Balance Cards Row - All four in one row
                      Row(
                        children: [
                          Expanded(
                            child: _buildBalanceCard(
                              'Savings',
                              _formatCurrency(memberData.savingsBalance),
                              null,
                              const Color.fromARGB(255, 146, 241, 154),
                              isSmallScreen,
                            ),
                          ),
                          SizedBox(width: isSmallScreen ? 4 : 6),
                          Expanded(
                            child: _buildBalanceCard(
                              'Loans',
                              _formatCurrency(memberData.loansBalance),
                              null,
                              const Color.fromARGB(230, 234, 177, 148),
                              isSmallScreen,
                            ),
                          ),
                          SizedBox(width: isSmallScreen ? 4 : 6),
                          Expanded(
                            child: _buildCapitalShareCard(
                              memberData.capitalShares.toInt(),
                              memberData.sharePercent,
                              const Color.fromARGB(255, 141, 180, 208),
                              isSmallScreen,
                            ),
                          ),
                          SizedBox(width: isSmallScreen ? 4 : 6),
                          Expanded(
                            child: _buildBalanceCard(
                              'Guarantee-able',
                              _formatCurrency(memberData.guaranteeableAmount),
                              null,
                              const Color.fromARGB(255, 248, 250, 135),
                              isSmallScreen,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      
                      // Custom Separator Bar
                      _buildSeparatorBar(),
                      const SizedBox(height: 24),
                      
                      // Quick Actions Section
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Quick Actions',
                              style: TextStyle(
                                fontSize: isSmallScreen ? 16 : 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green[700],
                              ),
                            ),
                            SizedBox(height: isSmallScreen ? 12 : 16),
                            // First row - 3 buttons
                            Row(
                              children: [
                                QuickActionButton(
                                  title: 'SAVE',
                                  icon: Icons.savings,
                                  onPressed: () => Navigator.pushNamed(context, '/savings-payment'),
                                  backgroundColor: const Color.fromARGB(255, 200, 245, 210),
                                  isSmallScreen: isSmallScreen,
                                ),
                                SizedBox(width: isSmallScreen ? 6 : 8),
                                QuickActionButton(
                                  title: 'LOAN REQUEST',
                                  icon: Icons.request_quote,
                                  onPressed: () => Navigator.pushNamed(context, '/loan-request'),
                                  backgroundColor: const Color.fromARGB(255, 200, 245, 210),
                                  isSmallScreen: isSmallScreen,
                                ),
                                SizedBox(width: isSmallScreen ? 6 : 8),
                                QuickActionButton(
                                  title: 'PAY LOAN',
                                  icon: Icons.payment,
                                  onPressed: () => Navigator.pushNamed(context, '/loan-payment'),
                                  backgroundColor: const Color.fromARGB(255, 200, 245, 210),
                                  isSmallScreen: isSmallScreen,
                                ),
                              ],
                            ),
                            SizedBox(height: isSmallScreen ? 6 : 8),
                            // Second row - 2 buttons
                            Row(
                              children: [
                                QuickActionButton(
                                  title: 'TOP-UP CAPITAL SHARE',
                                  icon: Icons.trending_up,
                                  onPressed: () => Navigator.pushNamed(context, '/capital-topup'),
                                  backgroundColor: const Color.fromARGB(255, 200, 245, 210),
                                  isSmallScreen: isSmallScreen,
                                ),
                                SizedBox(width: isSmallScreen ? 6 : 8),
                                QuickActionButton(
                                  title: 'MEMBER HISTORY',
                                  icon: Icons.history,
                                  onPressed: () => Navigator.pushNamed(context, '/transactions'),
                                  backgroundColor: const Color.fromARGB(255, 200, 245, 210),
                                  isSmallScreen: isSmallScreen,
                                ),
                                SizedBox(width: isSmallScreen ? 6 : 8),
                                const Expanded(child: SizedBox()), // Empty space for alignment
                              ],
                            ),
                          ],
                        ),
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
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long),
              label: 'My Transactions',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.support_agent),
              label: 'Contact',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.green,
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  // Build drawer widget
  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          // Drawer header with person icon
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 50, 16, 20),
            decoration: BoxDecoration(
              color: Colors.green[700],
            ),
            child: const Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 50,
                    color: Colors.green,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Member Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // Menu items section (empty for now)
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: const Column(
                children: [
                  Text(
                    'Menu items will be added here',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to format currency with thousands separators
  String _formatCurrency(double amount) {
    String amountStr = amount.toStringAsFixed(2);
    List<String> parts = amountStr.split('.');
    String integerPart = parts[0];
    String decimalPart = parts[1];
    
    // Add commas for thousands separator
    String formattedInteger = '';
    for (int i = 0; i < integerPart.length; i++) {
      if (i > 0 && (integerPart.length - i) % 3 == 0) {
        formattedInteger += ',';
      }
      formattedInteger += integerPart[i];
    }
    
    return 'KSH $formattedInteger.$decimalPart';
  }

  // Custom separator bar widget with improved diamond styling
  Widget _buildSeparatorBar() {
    return LayoutBuilder(
      builder: (context, constraints) {
        double screenWidth = constraints.maxWidth;
        int diamondCount = (screenWidth / 80).floor().clamp(3, 4);
        
        return SizedBox(
          height: 30,
          width: double.infinity,
          child: Stack(
            children: [
              // Top horizontal line (black)
              Positioned(
                top: 8,
                left: 0,
                right: 0,
                child: Container(
                  height: 2,
                  color: Colors.black,
                ),
              ),
              // Bottom horizontal line (black)
              Positioned(
                top: 20,
                left: 0,
                right: 0,
                child: Container(
                  height: 2,
                  color: Colors.black,
                ),
              ),
              // Diamond shapes - proper diamonds that don't touch lines
              ...List.generate(diamondCount, (index) {
                double spacing = screenWidth / (diamondCount + 1);
                double leftPosition = spacing * (index + 1) - 12; // Adjusted for wider diamond
                
                return Positioned(
                  top: 11, // Centered between lines with margin
                  left: leftPosition,
                  child: CustomPaint(
                    size: const Size(24, 8), // Width 24, Height 8
                    painter: DiamondPainter(),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBalanceCard(String title, String value, String? subtitle, Color backgroundColor, bool isSmallScreen) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: backgroundColor,
      child: Container(
        height: isSmallScreen ? 90 : 100,
        padding: EdgeInsets.all(isSmallScreen ? 4.0 : 6.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                title,
                style: TextStyle(
                  fontSize: isSmallScreen ? 9 : 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: isSmallScreen ? 4 : 6),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                value,
                style: TextStyle(
                  fontSize: isSmallScreen ? 7 : 9,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
            ),
            if (subtitle != null) ...[
              SizedBox(height: isSmallScreen ? 2 : 4),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 6 : 8,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Special card for Capital Share with two columns
  Widget _buildCapitalShareCard(int shares, double percent, Color backgroundColor, bool isSmallScreen) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: backgroundColor,
      child: Container(
        height: isSmallScreen ? 90 : 100,
        padding: EdgeInsets.all(isSmallScreen ? 4.0 : 6.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                'Capital Share',
                style: TextStyle(
                  fontSize: isSmallScreen ? 8 : 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: isSmallScreen ? 4 : 6),
            // Two columns with underlined headers
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.black,
                                width: 0.8,
                              ),
                            ),
                          ),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              'Shares',
                              style: TextStyle(
                                fontSize: isSmallScreen ? 7 : 8,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        SizedBox(height: isSmallScreen ? 2 : 3),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            shares.toString(),
                            style: TextStyle(
                              fontSize: isSmallScreen ? 7 : 8,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: isSmallScreen ? 2 : 4),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.black,
                                width: 0.8,
                              ),
                            ),
                          ),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              'Percent',
                              style: TextStyle(
                                fontSize: isSmallScreen ? 7 : 8,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        SizedBox(height: isSmallScreen ? 2 : 3),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            '${percent.toStringAsFixed(1)}%',
                            style: TextStyle(
                              fontSize: isSmallScreen ? 7 : 8,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
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
}

// Custom painter for diamond shapes
class DiamondPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color.fromARGB(255, 218, 165, 32) // Darker yellow
      ..style = PaintingStyle.fill;

    // Create diamond path with vertices at top, bottom, left, right
    final path = Path();
    path.moveTo(size.width / 2, 0); // Top vertex
    path.lineTo(size.width, size.height / 2); // Right vertex
    path.lineTo(size.width / 2, size.height); // Bottom vertex
    path.lineTo(0, size.height / 2); // Left vertex
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
