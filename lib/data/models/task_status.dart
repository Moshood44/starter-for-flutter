enum TaskStatus {
  pending,
  assigned,
  inProgress,
  completed,
  paid,
  disputed;

  String get displayName {
    switch (this) {
      case TaskStatus.pending:
        return 'Pending';
      case TaskStatus.assigned:
        return 'Assigned';
      case TaskStatus.inProgress:
        return 'In Progress';
      case TaskStatus.completed:
        return 'Completed';
      case TaskStatus.paid:
        return 'Paid';
      case TaskStatus.disputed:
        return 'Disputed';
    }
  }

  static TaskStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return TaskStatus.pending;
      case 'assigned':
        return TaskStatus.assigned;
      case 'inprogress':
      case 'in_progress':
        return TaskStatus.inProgress;
      case 'completed':
        return TaskStatus.completed;
      case 'paid':
        return TaskStatus.paid;
      case 'disputed':
        return TaskStatus.disputed;
      default:
        throw ArgumentError('Invalid task status: $status');
    }
  }
}