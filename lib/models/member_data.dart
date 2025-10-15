// lib/models/member_data.dart
class MemberData {
  final String memberName;
  final String memberNumber;
  final double savingsBalance;
  final double loansBalance;
  final double capitalShares;
  final double sharePercent;
  final double guaranteeableAmount;
  final String stage; // New field for registration stage
  final bool isApproved; // New field for approval status

  MemberData({
    required this.memberName,
    required this.memberNumber,
    required this.savingsBalance,
    required this.loansBalance,
    required this.capitalShares,
    required this.sharePercent,
    required this.guaranteeableAmount,
    this.stage = 'draft', // Default stage
    this.isApproved = false, // Default approval status
  });

  factory MemberData.fromJson(Map<String, dynamic> json) {
    return MemberData(
      memberName: json['member_name'] ?? json['memberName'] ?? '',
      memberNumber: json['member_number'] ?? json['memberNumber'] ?? '',
      savingsBalance: (json['savings_balance'] ?? json['savingsBalance'] ?? 0)
          .toDouble(),
      loansBalance: (json['loans_balance'] ?? json['loansBalance'] ?? 0)
          .toDouble(),
      capitalShares: (json['capital_shares'] ?? json['capitalShares'] ?? 0)
          .toDouble(),
      sharePercent: (json['share_percent'] ?? json['sharePercent'] ?? 0)
          .toDouble(),
      guaranteeableAmount:
          (json['guaranteeable_amount'] ?? json['guaranteeableAmount'] ?? 0)
              .toDouble(),
      stage: json['stage'] ?? json['stage'] ?? 'draft',
      isApproved: json['is_approved'] ?? json['isApproved'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'member_name': memberName,
      'member_number': memberNumber,
      'savings_balance': savingsBalance,
      'loans_balance': loansBalance,
      'capital_shares': capitalShares,
      'share_percent': sharePercent,
      'guaranteeable_amount': guaranteeableAmount,
      'stage': stage,
      'is_approved': isApproved,
    };
  }
}

class TransactionData {
  final String id;
  final String type;
  final double amount;
  final DateTime date;
  final String status;
  final String description;
  TransactionData({
    required this.id,
    required this.type,
    required this.amount,
    required this.date,
    required this.status,
    required this.description,
  });
  factory TransactionData.fromJson(Map<String, dynamic> json) {
    return TransactionData(
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      status: json['status'] ?? '',
      description: json['description'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'amount': amount,
      'date': date.toIso8601String(),
      'status': status,
      'description': description,
    };
  }
}

class LoanData {
  final String loanId;
  final double requestedAmount;
  final double approvedAmount;
  final double outstandingBalance;
  final double installmentAmount;
  final DateTime nextPaymentDate;
  final int monthsLeft;
  final String status;
  final List<GuarantorData> guarantors;
  LoanData({
    required this.loanId,
    required this.requestedAmount,
    required this.approvedAmount,
    required this.outstandingBalance,
    required this.installmentAmount,
    required this.nextPaymentDate,
    required this.monthsLeft,
    required this.status,
    required this.guarantors,
  });
  factory LoanData.fromJson(Map<String, dynamic> json) {
    return LoanData(
      loanId: json['loan_id'] ?? json['loanId'] ?? '',
      requestedAmount:
          (json['requested_amount'] ?? json['requestedAmount'] ?? 0).toDouble(),
      approvedAmount: (json['approved_amount'] ?? json['approvedAmount'] ?? 0)
          .toDouble(),
      outstandingBalance:
          (json['outstanding_balance'] ?? json['outstandingBalance'] ?? 0)
              .toDouble(),
      installmentAmount:
          (json['installment_amount'] ?? json['installmentAmount'] ?? 0)
              .toDouble(),
      nextPaymentDate: DateTime.parse(
        json['next_payment_date'] ??
            json['nextPaymentDate'] ??
            DateTime.now().toIso8601String(),
      ),
      monthsLeft: json['months_left'] ?? json['monthsLeft'] ?? 0,
      status: json['status'] ?? '',
      guarantors:
          (json['guarantors'] as List<dynamic>?)
              ?.map((g) => GuarantorData.fromJson(g))
              .toList() ??
          [],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'loan_id': loanId,
      'requested_amount': requestedAmount,
      'approved_amount': approvedAmount,
      'outstanding_balance': outstandingBalance,
      'installment_amount': installmentAmount,
      'next_payment_date': nextPaymentDate.toIso8601String(),
      'months_left': monthsLeft,
      'status': status,
      'guarantors': guarantors.map((g) => g.toJson()).toList(),
    };
  }
}

class GuarantorData {
  final String memberName;
  final String memberNumber;
  final double guaranteedAmount;
  final double availableAmount;
  GuarantorData({
    required this.memberName,
    required this.memberNumber,
    required this.guaranteedAmount,
    required this.availableAmount,
  });
  factory GuarantorData.fromJson(Map<String, dynamic> json) {
    return GuarantorData(
      memberName: json['member_name'] ?? json['memberName'] ?? '',
      memberNumber: json['member_number'] ?? json['memberNumber'] ?? '',
      guaranteedAmount:
          (json['guaranteed_amount'] ?? json['guaranteedAmount'] ?? 0)
              .toDouble(),
      availableAmount:
          (json['available_amount'] ?? json['availableAmount'] ?? 0).toDouble(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'member_name': memberName,
      'member_number': memberNumber,
      'guaranteed_amount': guaranteedAmount,
      'available_amount': availableAmount,
    };
  }
}
