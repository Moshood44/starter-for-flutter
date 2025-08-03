enum BidStatus {
  pending,
  accepted,
  rejected;

  String get displayName {
    switch (this) {
      case BidStatus.pending:
        return 'Pending';
      case BidStatus.accepted:
        return 'Accepted';
      case BidStatus.rejected:
        return 'Rejected';
    }
  }

  static BidStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return BidStatus.pending;
      case 'accepted':
        return BidStatus.accepted;
      case 'rejected':
        return BidStatus.rejected;
      default:
        throw ArgumentError('Invalid bid status: $status');
    }
  }
}