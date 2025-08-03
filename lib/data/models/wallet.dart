import 'transaction.dart';

class Wallet {
  final String userId;
  final double balance;
  final List<Transaction> transactions;
  final DateTime lastUpdated;

  const Wallet({
    required this.userId,
    this.balance = 0.0,
    this.transactions = const [],
    required this.lastUpdated,
  });

  // JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'balance': balance,
      'transactions': transactions.map((t) => t.toJson()).toList(),
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      userId: json['userId'] as String,
      balance: (json['balance'] as num?)?.toDouble() ?? 0.0,
      transactions: (json['transactions'] as List<dynamic>?)
          ?.map((t) => Transaction.fromJson(t as Map<String, dynamic>))
          .toList() ?? [],
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'] as String)
          : DateTime.now(),
    );
  }

  // Validation
  bool get isValid {
    return userId.isNotEmpty && balance >= 0;
  }

  String get balanceDisplay {
    return '\$${balance.toStringAsFixed(2)}';
  }

  double get totalEarnings {
    return transactions
        .where((t) => t.isCredit)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double get totalWithdrawals {
    return transactions
        .where((t) => t.type == TransactionType.withdrawal)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  List<Transaction> get recentTransactions {
    final sortedTransactions = List<Transaction>.from(transactions)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sortedTransactions.take(10).toList();
  }

  List<Transaction> getTransactionsByType(TransactionType type) {
    return transactions.where((t) => t.type == type).toList();
  }

  List<Transaction> getTransactionsForDateRange(DateTime start, DateTime end) {
    return transactions
        .where((t) => t.createdAt.isAfter(start) && t.createdAt.isBefore(end))
        .toList();
  }

  bool canWithdraw(double amount) {
    return balance >= amount && amount > 0;
  }

  Wallet addTransaction(Transaction transaction) {
    final newTransactions = List<Transaction>.from(transactions)
      ..add(transaction);
    
    double newBalance = balance;
    if (transaction.isCredit) {
      newBalance += transaction.amount;
    } else if (transaction.isDebit) {
      newBalance -= transaction.amount;
    }

    return copyWith(
      balance: newBalance,
      transactions: newTransactions,
      lastUpdated: DateTime.now(),
    );
  }

  Wallet copyWith({
    String? userId,
    double? balance,
    List<Transaction>? transactions,
    DateTime? lastUpdated,
  }) {
    return Wallet(
      userId: userId ?? this.userId,
      balance: balance ?? this.balance,
      transactions: transactions ?? this.transactions,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Wallet &&
        other.userId == userId &&
        other.balance == balance &&
        other.transactions.length == transactions.length &&
        other.transactions.every((t) => transactions.contains(t)) &&
        other.lastUpdated == lastUpdated;
  }

  @override
  int get hashCode {
    return Object.hash(userId, balance, transactions, lastUpdated);
  }

  @override
  String toString() {
    return 'Wallet(userId: $userId, balance: $balance, transactions: ${transactions.length})';
  }
}