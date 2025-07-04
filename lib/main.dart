import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sacco_app/authentication/login_screen.dart';
import 'package:sacco_app/authentication/registration_screen.dart';
//import 'package:sacco_app/authentication/welcome_screen.dart';
import 'package:sacco_app/screens/home_screen.dart';
import 'package:sacco_app/screens/terms_and_conditions_screen.dart';
import 'package:sacco_app/screens/savings_payment_screen.dart';
import 'package:sacco_app/screens/payment_confirmation_screen.dart';
import 'package:sacco_app/screens/payment_success_screen.dart';
import 'package:sacco_app/screens/loan_request_screen.dart';
import 'package:sacco_app/screens/guarantor_selection_screen.dart';
import 'package:sacco_app/screens/loan_request_success_screen.dart';
import 'package:sacco_app/screens/loan_payment_screen.dart';
import 'package:sacco_app/screens/transactions_screen.dart';
import 'package:sacco_app/screens/contact_screen.dart';
import 'package:sacco_app/screens/capital_topup_screen.dart';
import 'package:sacco_app/services/auth_provider.dart';
import 'package:sacco_app/services/member_provider.dart';

void main() {
  runApp(const SaccoApp());
}

class SaccoApp extends StatelessWidget {
  const SaccoApp({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => MemberProvider()),
      ],
      child: MaterialApp(
        title: 'Anfal Sacco',
        navigatorKey: navigatorKey,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
        routes: {
          '/register': (context) => const RegistrationScreen(),
          '/login': (context) => const LoginScreen(),
          '/home': (context) => const HomeScreen(),
          '/terms': (context) => const TermsAndConditionsScreen(),
          '/savings-payment': (context) => const SavingsPaymentScreen(),
          '/payment-confirmation': (context) => const PaymentConfirmationScreen(),
          '/payment-success': (context) => const PaymentSuccessScreen(),
          '/loan-request': (context) => const LoanRequestScreen(),
          '/guarantor-selection': (context) => const GuarantorSelectionScreen(),
          '/loan-request-success': (context) => const LoanRequestSuccessScreen(),
          '/loan-payment': (context) => const LoanPaymentScreen(),
          '/transactions': (context) => const TransactionsScreen(),
          '/contact': (context) => const ContactScreen(),
          '/capital-topup': (context) => const CapitalTopupScreen(),
        },
      ),
    );
  }
}
