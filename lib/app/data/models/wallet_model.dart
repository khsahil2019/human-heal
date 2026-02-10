// models/wallet_balance_model.dart
class WalletBalanceModel {
  final double balance;

  WalletBalanceModel({required this.balance});

  factory WalletBalanceModel.fromJson(dynamic json) {
    // The API returns balance as a string number inside "data"
    return WalletBalanceModel(balance: double.tryParse(json.toString()) ?? 0);
  }
}

// models/transaction_model.dart
class TransactionModel {
  final String type;
  final double amount;
  final double totalAmount;
  final String transactionId;
  final String transactionHistory;
  final String? paymentMethod;
  final String paymentStatus;
  final DateTime createdAt;

  TransactionModel({
    required this.type,
    required this.amount,
    required this.totalAmount,
    required this.transactionId,
    required this.transactionHistory,
    this.paymentMethod,
    required this.paymentStatus,
    required this.createdAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      type: json['type'],
      amount: double.tryParse(json['amount'].toString()) ?? 0,
      totalAmount: double.tryParse(json['total_amount'].toString()) ?? 0,
      transactionId: json['transaction_id'],
      transactionHistory: json['transaction_history'],
      paymentMethod: json['payment_method'],
      paymentStatus: json['payment_status'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
