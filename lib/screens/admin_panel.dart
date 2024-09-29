import 'package:flutter/material.dart';
import 'package:myapp/screens/supplier_dashboard.dart';

class AdminPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Panel'),
      ),
      body: ListView(
        children: [
          UserManagement(),
          ProductManagement(),
          OrderManagement(),
          PaymentManagement(),
        ],
      ),
    );
  }
}

// Placeholder widgets for admin panel sections
class UserManagement extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('User Management'),
      onTap: () {
        // Navigate to user management screen
      },
    );
  }
}

class PaymentManagement extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('Payment Management'),
      onTap: () {
        // Navigate to payment management screen
      },
    );
  }
}
