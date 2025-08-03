enum TransactionType {
  credit,
  debit,
  withdrawal,
  refund;

  String get displayName {
    switch (this) {
      case TransactionType.credit:
        return 'Credit';
      case TransactionType.debit:
        return 'Debit';
      case TransactionType.withdrawal:
        return 'Withdrawal';
      case TransactionType.refund:
        return 'Refund';
    }
  }

  static TransactionType fromString(String type) {
    switch (type.toLowerCase()) {
      case 'credit':
        return TransactionType.credit;
      case 'debit':
        return TransactionType.debit;
      case 'withdrawal':
        return TransactionType.withdrawal;
      case 'refund':
        return TransactionType.refund;
      default:
        throw ArgumentError('Invalid transaction type: $type');
    }
  }
}

class Transaction {
  final String id;
  final String userId;
  final TransactionType type;
  final double amount;
  final String description;
  final String? taskId;
  final String? paymentId;
  final DateTime createdAt;
  final Map<String, dynamic>? metadata;

  const Transaction({
    required this.id,
    required this.userId,
    required this.type,
    required this.amount,
    required this.description,
    this.taskId,
    this.paymentId,
    required this.createdAt,
    this.metadata,
  });

  // JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'type': type.name,
      'amount': amount,
      'description': description,
      'taskId': taskId,
      'paymentId': paymentId,
      'createdAt': createdAt.toIso8601String(),
      'metadata': metadata,
    };
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] as String,
      userId: json['userId'] as String,
      type: TransactionType.fromString(json['type'] as String),
      amount: (json['amount'] as num).toDouble(),
      description: json['description'] as String,
      taskId: json['taskId'] as String?,
      paymentId: json['paymentId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  // Validation
  bool get isValid {
    return id.isNotEmpty &&
           userId.isNotEmpty &&
           amount > 0 &&
           description.isNotEmpty;
  }

  bool get isCredit {
    return type == TransactionType.credit || type == TransactionType.refund;
  }

  bool get isDebit {
    return type == TransactionType.debit || type == TransactionType.withdrawal;
  }

  String get amountDisplay {
    final prefix = isCredit ? '+' : '-';
    return '$prefix\$${amount.toStringAsFixed(2)}';
  }

  String get formattedAmount {
    return '\$${amount.toStringAsFixed(2)}';
  }

  Transaction copyWith({
    String? id,
    String? userId,
    TransactionType? type,
    double? amount,
    String? description,
    String? taskId,
    String? paymentId,
    DateTime? createdAt,
    Map<String, dynamic>? metadata,
  }) {
    return Transaction(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      taskId: taskId ?? this.taskId,
      paymentId: paymentId ?? this.paymentId,
      createdAt: createdAt ?? this.createdAt,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Transaction &&
        other.id == id &&
        other.userId == userId &&
        other.type == type &&
        other.amount == amount &&
        other.description == description &&
        other.taskId == taskId &&
        other.paymentId == paymentId &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      userId,
      type,
      amount,
      description,
      taskId,
      paymentId,
      createdAt,
    );
  }

  @override
  String toString() {
    return 'Transaction(id: $id, type: $type, amount: $amount, description: $description)';
  }
}