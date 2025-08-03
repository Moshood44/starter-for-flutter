import 'bid_status.dart';

class Bid {
  final String id;
  final String taskId;
  final String taskerId;
  final double proposedAmount;
  final String message;
  final BidStatus status;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const Bid({
    required this.id,
    required this.taskId,
    required this.taskerId,
    required this.proposedAmount,
    required this.message,
    this.status = BidStatus.pending,
    required this.createdAt,
    this.updatedAt,
  });

  // JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'taskId': taskId,
      'taskerId': taskerId,
      'proposedAmount': proposedAmount,
      'message': message,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory Bid.fromJson(Map<String, dynamic> json) {
    return Bid(
      id: json['id'] as String,
      taskId: json['taskId'] as String,
      taskerId: json['taskerId'] as String,
      proposedAmount: (json['proposedAmount'] as num).toDouble(),
      message: json['message'] as String,
      status: BidStatus.fromString(json['status'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  // Validation
  bool get isValid {
    return id.isNotEmpty &&
           taskId.isNotEmpty &&
           taskerId.isNotEmpty &&
           proposedAmount > 0 &&
           message.isNotEmpty;
  }

  bool get isPending {
    return status == BidStatus.pending;
  }

  bool get isAccepted {
    return status == BidStatus.accepted;
  }

  bool get isRejected {
    return status == BidStatus.rejected;
  }

  String get proposedAmountDisplay {
    return '\$${proposedAmount.toStringAsFixed(2)}';
  }

  Bid copyWith({
    String? id,
    String? taskId,
    String? taskerId,
    double? proposedAmount,
    String? message,
    BidStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Bid(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      taskerId: taskerId ?? this.taskerId,
      proposedAmount: proposedAmount ?? this.proposedAmount,
      message: message ?? this.message,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Bid &&
        other.id == id &&
        other.taskId == taskId &&
        other.taskerId == taskerId &&
        other.proposedAmount == proposedAmount &&
        other.message == message &&
        other.status == status &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      taskId,
      taskerId,
      proposedAmount,
      message,
      status,
      createdAt,
    );
  }

  @override
  String toString() {
    return 'Bid(id: $id, taskId: $taskId, proposedAmount: $proposedAmount, status: $status)';
  }
}