import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Terms & Conditions',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: kIsWeb
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context, rootNavigator: true).pushNamed('/register'),
              )
            : null,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Text(
              'Anfal Sacco Loan Terms and Conditions',
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.green[700],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Last Updated: July 1, 2025',
              style: textTheme.bodySmall?.copyWith(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            _buildSection(
              context,
              number: '1',
              title: 'Introduction',
              content:
                  'Welcome to Anfal Sacco. These Terms and Conditions govern your access to and use of our loan services. By applying for or using any loan product, you agree to be bound by these terms. Please read them carefully.',
            ),
            _buildSection(
              context,
              number: '2',
              title: 'Eligibility',
              content:
                  'To be eligible for a loan, you must:\n'
                  '- Be at least 18 years old.\n'
                  '- Be a registered member of Anfal Sacco.\n'
                  '- Provide accurate and complete information during registration.\n'
                  '- Meet the minimum savings and share capital requirements as set by Anfal Sacco.\n'
                  '- Have a valid identification document (e.g., National ID or Passport).',
            ),
            _buildSection(
              context,
              number: '3',
              title: 'Loan Application and Approval',
              content:
                  'Loan applications are submitted through the Anfal Sacco mobile app. Approval is subject to:\n'
                  '- Assessment of your creditworthiness based on savings, shares, and repayment history.\n'
                  '- Verification of provided information.\n'
                  '- Availability of funds and guarantee-able amounts by other members.\n'
                  'Anfal Sacco reserves the right to approve or reject applications at its discretion.',
            ),
            _buildSection(
              context,
              number: '4',
              title: 'Loan Terms and Repayment',
              content:
                  'Loans are subject to:\n'
                  '- Interest rates as disclosed at the time of application (e.g., 1% per month on reducing balance).\n'
                  '- Repayment periods ranging from 1 to 36 months, depending on the loan type.\n'
                  '- Monthly instalments via direct deductions from your Anfal Sacco savings account or approved payment methods.\n'
                  '- Late payments incur a penalty fee of 5% of the overdue amount, subject to a minimum of KSH 500.',
            ),
            _buildSection(
              context,
              number: '5',
              title: 'Guarantorship',
              content:
                  'Certain loans require guarantors who are active Anfal Sacco members. Guarantors agree to:\n'
                  '- Repay the loan in case of default by the borrower.\n'
                  '- Maintain sufficient savings to cover the guaranteed amount.\n'
                  'Guarantors will be notified of their obligations before confirming their commitment.',
            ),
            _buildSection(
              context,
              number: '6',
              title: 'Default and Recovery',
              content:
                  'Failure to repay a loan as agreed may result in:\n'
                  '- Deduction of outstanding amounts from your savings or share capital.\n'
                  '- Recovery from guarantors’ accounts.\n'
                  '- Legal action to recover the outstanding balance, including associated costs.\n'
                  '- Reporting to credit reference bureaus, affecting your credit score.',
            ),
            _buildSection(
              context,
              number: '7',
              title: 'Data Privacy',
              content:
                  'Anfal Sacco collects and processes your personal data in accordance with applicable data protection laws. Your information is used for:\n'
                  '- Loan processing and administration.\n'
                  '- Credit assessment and fraud prevention.\n'
                  '- Communication regarding your account.\n'
                  'We do not share your data with third parties except as required by law or with your consent.',
            ),
            _buildSection(
              context,
              number: '8',
              title: 'Termination and Amendments',
              content:
                  'Anfal Sacco may amend these terms at any time, with notice provided via the app or email. You may terminate your membership by settling all outstanding loans and withdrawing your savings, subject to sacco policies.',
            ),
            _buildSection(
              context,
              number: '9',
              title: 'Contact Us',
              content:
                  'For inquiries or complaints, contact us at:\n'
                  '- Email: support@anfalsacco.com\n'
                  '- Phone: +254 123 456 789\n'
                  '- Address: Anfal Sacco, P.O. Box 12345-00100, Nairobi, Kenya',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String number,
    required String title,
    required String content,
  }) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$number. $title',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.green[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: textTheme.bodyMedium?.copyWith(color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}