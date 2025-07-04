class MemberData {
  final String memberName;
  final String memberNumber;
  final double savingsBalance;
  final double loansBalance;
  final double capitalShares;
  final double sharePercent;
  final double guaranteeableAmount;

  MemberData({
    required this.memberName,
    required this.memberNumber,
    required this.savingsBalance,
    required this.loansBalance,
    required this.capitalShares,
    required this.sharePercent,
    required this.guaranteeableAmount,
  });

  factory MemberData.fromJson(Map<String, dynamic> json) {
    return MemberData(
      memberName: json['memberName'] ?? '',
      memberNumber: json['memberNumber'] ?? '',
      savingsBalance: (json['savingsBalance'] ?? 0).toDouble(),
      loansBalance: (json['loansBalance'] ?? 0).toDouble(),
      capitalShares: (json['capitalShares'] ?? 0).toDouble(),
      sharePercent: (json['sharePercent'] ?? 0).toDouble(),
      guaranteeableAmount: (json['guaranteeableAmount'] ?? 0).toDouble(),
    );
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
      loanId: json['loanId'] ?? '',
      requestedAmount: (json['requestedAmount'] ?? 0).toDouble(),
      approvedAmount: (json['approvedAmount'] ?? 0).toDouble(),
      outstandingBalance: (json['outstandingBalance'] ?? 0).toDouble(),
      installmentAmount: (json['installmentAmount'] ?? 0).toDouble(),
      nextPaymentDate: DateTime.parse(json['nextPaymentDate'] ?? DateTime.now().toIso8601String()),
      monthsLeft: json['monthsLeft'] ?? 0,
      status: json['status'] ?? '',
      guarantors: (json['guarantors'] as List<dynamic>?)
          ?.map((g) => GuarantorData.fromJson(g))
          .toList() ?? [],
    );
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
      memberName: json['memberName'] ?? '',
      memberNumber: json['memberNumber'] ?? '',
      guaranteedAmount: (json['guaranteedAmount'] ?? 0).toDouble(),
      availableAmount: (json['availableAmount'] ?? 0).toDouble(),
    );
  }
}
