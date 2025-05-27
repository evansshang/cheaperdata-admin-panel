import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart'; // Added this import
import 'app_localizations.dart';
import 'wallet_model.dart';
import 'transaction_history_screen.dart';
import 'bundle_service.dart';
import 'referral_service.dart';
import 'main.dart'; // Added this import for LanguageProvider

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    
    List<Widget> _widgetOptions = <Widget>[
      _buildHomeTab(context, localizations),
      _buildWalletTab(context, localizations),
      _buildTransactionsTab(context, localizations),
      _buildReferralsTab(context, localizations),
      _buildSettingsTab(context, localizations),
    ];
    
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.translate('app_name')),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () async {
              await _auth.signOut();
              // Assuming LoginScreen is the route name for the login page
              Navigator.of(context).pushReplacementNamed('/login'); 
            },
          ),
        ],
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Ensure type is fixed for more than 3 items
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: localizations.translate('home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: localizations.translate('wallet'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: localizations.translate('transactions'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: localizations.translate('referrals'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: localizations.translate('settings'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey, // Added for better visual distinction
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
  
  Widget _buildHomeTab(BuildContext context, AppLocalizations localizations) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localizations.translate('buy_data'),
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          _buildDataProviderSection(
            context, 
            localizations.translate('mtn_data'), 
            Colors.yellow.shade700,
            [
              {'amount': '500 MB', 'price': '500 XAF'},
              {'amount': '1 GB', 'price': '1000 XAF'},
              {'amount': '2 GB', 'price': '1800 XAF'},
              {'amount': '5 GB', 'price': '4000 XAF'},
            ],
            localizations,
          ),
          SizedBox(height: 24),
          _buildDataProviderSection(
            context, 
            localizations.translate('orange_data'), 
            Colors.orange,
            [
              {'amount': '500 MB', 'price': '500 XAF'},
              {'amount': '1 GB', 'price': '1000 XAF'},
              {'amount': '2 GB', 'price': '1800 XAF'},
              {'amount': '5 GB', 'price': '4000 XAF'},
            ],
            localizations,
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
    AppLocalizations localizations,
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
                  _showBuyDataDialog(context, title, bundles[index], localizations);
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
    AppLocalizations localizations,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizations.translate('confirm')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${localizations.translate('provider')}: $provider'),
            SizedBox(height: 8),
            Text('${localizations.translate('data_amount')}: ${bundle['amount']}'),
            SizedBox(height: 8),
            Text('${localizations.translate('price')}: ${bundle['price']}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(localizations.translate('cancel')),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement actual bundle purchase logic using BundleService
              print('Buying ${bundle['amount']} of $provider data for ${bundle['price']}');
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${bundle['amount']} ${localizations.translate('purchased')}')),
              );
            },
            child: Text(localizations.translate('buy_now')),
          ),
        ],
      ),
    );
  }
  
  Widget _buildWalletTab(BuildContext context, AppLocalizations localizations) {
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
                    localizations.translate('balance'),
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
                  label: Text(localizations.translate('add_funds')),
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
                  label: Text(localizations.translate('withdraw')),
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
            localizations.translate('recent_transactions'),
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
  
  Widget _buildTransactionsTab(BuildContext context, AppLocalizations localizations) {
    // This correctly uses the dedicated screen
    return TransactionHistoryScreen();
  }
  
  Widget _buildReferralsTab(BuildContext context, AppLocalizations localizations) {
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
                    localizations.translate('referral_code'),
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
                        label: Text(localizations.translate('share_code')),
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
                          localizations.translate('total_referrals'),
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
                          localizations.translate('referral_rewards'),
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
            localizations.translate('referral_history'),
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
                    child: Text
(Content truncated due to size limit. Use line ranges to read in chunks)