import 'payment_status.dart';

class Payment {
  final String id;
  final String taskId;
  final String posterId;
  final String taskerId;
  final double amount;
  final PaymentStatus status;
  final String? transactionReference;
  final DateTime createdAt;
  final DateTime? completedAt;
  final String? failureReason;

  const Payment({
    required this.id,
    required this.taskId,
    required this.posterId,
    required this.taskerId,
    required this.amount,
    this.status = PaymentStatus.pending,
    this.transactionReference,
    required this.createdAt,
    this.completedAt,
    this.failureReason,
  });

  // JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'taskId': taskId,
      'posterId': posterId,
      'taskerId': taskerId,
      'amount': amount,
      'status': status.name,
      'transactionReference': transactionReference,
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'failureReason': failureReason,
    };
  }

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'] as String,
      taskId: json['taskId'] as String,
      posterId: json['posterId'] as String,
      taskerId: json['taskerId'] as String,
      amount: (json['amount'] as num).toDouble(),
      status: PaymentStatus.fromString(json['status'] as String),
      transactionReference: json['transactionReference'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
      failureReason: json['failureReason'] as String?,
    );
  }

  // Validation
  bool get isValid {
    return id.isNotEmpty &&
           taskId.isNotEmpty &&
           posterId.isNotEmpty &&
           taskerId.isNotEmpty &&
           amount > 0;
  }

  bool get isPending {
    return status == PaymentStatus.pending;
  }

  bool get isProcessing {
    return status == PaymentStatus.processing;
  }

  bool get isCompleted {
    return status == PaymentStatus.completed;
  }

  bool get isFailed {
    return status == PaymentStatus.failed;
  }

  bool get isRefunded {
    return status == PaymentStatus.refunded;
  }

  String get amountDisplay {
    return '\$${amount.toStringAsFixed(2)}';
  }

  Duration? get processingTime {
    if (completedAt != null) {
      return completedAt!.difference(createdAt);
    }
    return null;
  }

  Payment copyWith({
    String? id,
    String? taskId,
    String? posterId,
    String? taskerId,
    double? amount,
    PaymentStatus? status,
    String? transactionReference,
    DateTime? createdAt,
    DateTime? completedAt,
    String? failureReason,
  }) {
    return Payment(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      posterId: posterId ?? this.posterId,
      taskerId: taskerId ?? this.taskerId,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      transactionReference: transactionReference ?? this.transactionReference,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      failureReason: failureReason ?? this.failureReason,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Payment &&
        other.id == id &&
        other.taskId == taskId &&
        other.posterId == posterId &&
        other.taskerId == taskerId &&
        other.amount == amount &&
        other.status == status &&
        other.transactionReference == transactionReference &&
        other.createdAt == createdAt &&
        other.completedAt == completedAt &&
        other.failureReason == failureReason;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      taskId,
      posterId,
      taskerId,
      amount,
      status,
      transactionReference,
      createdAt,
      completedAt,
      failureReason,
    );
  }

  @override
  String toString() {
    return 'Payment(id: $id, taskId: $taskId, amount: $amount, status: $status)';
  }
}