import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:provider/provider.dart'; // Removed provider import if only used for language
// import 'app_localizations.dart'; // Removed localization import
import 'wallet_model.dart';
import 'transaction_history_screen.dart';
import 'bundle_service.dart';
import 'referral_service.dart';
// import 'main.dart'; // Removed main import if only used for LanguageProvider

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    // Removed localizations variable

    List<Widget> _widgetOptions = <Widget>[
      _buildHomeTab(context),
      _buildWalletTab(context),
      _buildTransactionsTab(context),
      _buildReferralsTab(context),
      _buildSettingsTab(context),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('CheaperData'), // Hardcoded string
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () async {
              await _auth.signOut();
              Navigator.of(context).pushReplacementNamed('/login');
            },
          ),
        ],
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home', // Hardcoded string
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Wallet', // Hardcoded string
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Transactions', // Hardcoded string
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Referrals', // Hardcoded string
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings', // Hardcoded string
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildHomeTab(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Buy Data', // Hardcoded string
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          _buildDataProviderSection(
            context,
            'MTN Data', // Hardcoded string
            Colors.yellow.shade700,
            [
              {'amount': '500 MB', 'price': '500 XAF'},
              {'amount': '1 GB', 'price': '1000 XAF'},
              {'amount': '2 GB', 'price': '1800 XAF'},
              {'amount': '5 GB', 'price': '4000 XAF'},
            ],
          ),
          SizedBox(height: 24),
          _buildDataProviderSection(
            context,
            'Orange Data', // Hardcoded string
            Colors.orange,
            [
              {'amount': '500 MB', 'price': '500 XAF'},
              {'amount': '1 GB', 'price': '1000 XAF'},
              {'amount': '2 GB', 'price': '1800 XAF'},
              {'amount': '5 GB', 'price': '4000 XAF'},
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDataProviderSection(
    BuildContext context,
    String title,
    Color color,
    List<Map<String, String>> bundles,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.5,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: bundles.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 2,
              child: InkWell(
                onTap: () {
                  _showBuyDataDialog(context, title, bundles[index]);
                },
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        bundles[index]['amount']!,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        bundles[index]['price']!,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
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

  void _showBuyDataDialog(
    BuildContext context,
    String provider,
    Map<String, String> bundle,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Purchase'), // Hardcoded string
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Provider: $provider'), // Hardcoded string
            SizedBox(height: 8),
            Text('Data Amount: ${bundle['amount']}'), // Hardcoded string
            SizedBox(height: 8),
            Text('Price: ${bundle['price']}'), // Hardcoded string
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'), // Hardcoded string
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement actual bundle purchase logic using BundleService
              print('Buying ${bundle['amount']} of $provider data for ${bundle['price']}');
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${bundle['amount']} purchased successfully!')), // Hardcoded string
              );
            },
            child: Text('Buy Now'), // Hardcoded string
          ),
        ],
      ),
    );
  }

  Widget _buildWalletTab(BuildContext context) {
    // TODO: Replace with actual WalletModel data fetching
    final walletBalance = 5000.0;

    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 4,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Balance', // Hardcoded string
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '$walletBalance XAF',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  icon: Icon(Icons.add),
                  label: Text('Add Funds'), // Hardcoded string
                  onPressed: () {
                    // TODO: Implement add funds functionality
                    print('Add funds pressed');
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: OutlinedButton.icon(
                  icon: Icon(Icons.money_off),
                  label: Text('Withdraw'), // Hardcoded string
                  onPressed: () {
                    // TODO: Implement withdraw functionality
                    print('Withdraw pressed');
                  },
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 24),
          Text(
            'Recent Transactions', // Hardcoded string
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          // TODO: Replace with actual transaction list from TransactionHistoryScreen or WalletModel
          Expanded(
            child: ListView.builder(
              itemCount: 5, // Placeholder count
              itemBuilder: (context, index) {
                bool isDeposit = index % 2 == 0;
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: isDeposit ? Colors.green.shade100 : Colors.red.shade100,
                    child: Icon(
                      isDeposit ? Icons.add : Icons.remove,
                      color: isDeposit ? Colors.green : Colors.red,
                    ),
                  ),
                  title: Text(isDeposit ? 'Deposit' : 'Data Purchase'),
                  subtitle: Text('May ${20 + index}, 2025'),
                  trailing: Text(
                    isDeposit ? '+1000 XAF' : '-500 XAF',
                    style: TextStyle(
                      color: isDeposit ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionsTab(BuildContext context) {
    // This correctly uses the dedicated screen
    return TransactionHistoryScreen();
  }

  Widget _buildReferralsTab(BuildContext context) {
    // TODO: Replace with actual ReferralService data fetching
    final referralCode = 'ABC123';
    final referralCount = 5;
    final referralEarnings = 2500.0;

    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 4,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Referral Code', // Hardcoded string
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        referralCode,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      ElevatedButton.icon(
                        icon: Icon(Icons.share),
                        label: Text('Share Code'), // Hardcoded string
                        onPressed: () {
                          // TODO: Implement share functionality
                          print('Share code pressed');
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: Card(
                  elevation: 2,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Referrals', // Hardcoded string
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '$referralCount',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Card(
                  elevation: 2,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Referral Rewards', // Hardcoded string
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '$referralEarnings XAF',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 24),
          Text(
            'Referral History', // Hardcoded string
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          // TODO: Replace with actual referral history list
          Expanded(
            child: ListView.builder(
              itemCount: referralCount, // Placeholder count
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    child: Text('U${index + 1}'), // Placeholder
                  ),
                  title: Text('User ${index + 1} joined'),
                  subtitle: Text('May ${15 + index}, 2025'),
                  trailing: Text(
                    '+500 XAF',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTab(BuildContext context) {
    // Removed LanguagePr
(Content truncated due to size limit. Use line ranges to read in chunks)