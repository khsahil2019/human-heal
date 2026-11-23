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
      type: json['type']?.toString() ?? '',
      amount: double.tryParse(json['amount']?.toString() ?? '0') ?? 0,
      totalAmount: double.tryParse(json['total_amount']?.toString() ?? '0') ?? 0,
      transactionId: json['transaction_id']?.toString() ?? '',
      transactionHistory: json['transaction_history']?.toString() ?? '',
      paymentMethod: json['payment_method']?.toString(),
      paymentStatus: json['payment_status']?.toString() ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
