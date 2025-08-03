import 'task_category.dart';
import 'task_status.dart';
import 'location.dart';

class Task {
  final String id;
  final String posterId;
  final String title;
  final String description;
  final TaskCategory category;
  final Location location;
  final double budget;
  final DateTime deadline;
  final TaskStatus status;
  final List<String> attachmentUrls;
  final DateTime createdAt;
  final String? assignedTaskerId;
  final DateTime? updatedAt;

  const Task({
    required this.id,
    required this.posterId,
    required this.title,
    required this.description,
    required this.category,
    required this.location,
    required this.budget,
    required this.deadline,
    this.status = TaskStatus.pending,
    this.attachmentUrls = const [],
    required this.createdAt,
    this.assignedTaskerId,
    this.updatedAt,
  });

  // JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'posterId': posterId,
      'title': title,
      'description': description,
      'category': category.name,
      'location': location.toJson(),
      'budget': budget,
      'deadline': deadline.toIso8601String(),
      'status': status.name,
      'attachmentUrls': attachmentUrls,
      'createdAt': createdAt.toIso8601String(),
      'assignedTaskerId': assignedTaskerId,
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as String,
      posterId: json['posterId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      category: TaskCategory.fromString(json['category'] as String),
      location: Location.fromJson(json['location'] as Map<String, dynamic>),
      budget: (json['budget'] as num).toDouble(),
      deadline: DateTime.parse(json['deadline'] as String),
      status: TaskStatus.fromString(json['status'] as String),
      attachmentUrls: (json['attachmentUrls'] as List<dynamic>?)
          ?.map((url) => url as String)
          .toList() ?? [],
      createdAt: DateTime.parse(json['createdAt'] as String),
      assignedTaskerId: json['assignedTaskerId'] as String?,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  // Validation
  bool get isValid {
    return id.isNotEmpty &&
           posterId.isNotEmpty &&
           title.isNotEmpty &&
           description.isNotEmpty &&
           budget > 0 &&
           deadline.isAfter(DateTime.now()) &&
           location.isValid;
  }

  bool get isAssigned {
    return assignedTaskerId != null && status == TaskStatus.assigned;
  }

  bool get isCompleted {
    return status == TaskStatus.completed || status == TaskStatus.paid;
  }

  bool get canBeEdited {
    return status == TaskStatus.pending;
  }

  bool get isOverdue {
    return deadline.isBefore(DateTime.now()) && !isCompleted;
  }

  Duration get timeUntilDeadline {
    return deadline.difference(DateTime.now());
  }

  String get budgetDisplay {
    return '\$${budget.toStringAsFixed(2)}';
  }

  Task copyWith({
    String? id,
    String? posterId,
    String? title,
    String? description,
    TaskCategory? category,
    Location? location,
    double? budget,
    DateTime? deadline,
    TaskStatus? status,
    List<String>? attachmentUrls,
    DateTime? createdAt,
    String? assignedTaskerId,
    DateTime? updatedAt,
  }) {
    return Task(
      id: id ?? this.id,
      posterId: posterId ?? this.posterId,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      location: location ?? this.location,
      budget: budget ?? this.budget,
      deadline: deadline ?? this.deadline,
      status: status ?? this.status,
      attachmentUrls: attachmentUrls ?? this.attachmentUrls,
      createdAt: createdAt ?? this.createdAt,
      assignedTaskerId: assignedTaskerId ?? this.assignedTaskerId,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Task &&
        other.id == id &&
        other.posterId == posterId &&
        other.title == title &&
        other.description == description &&
        other.category == category &&
        other.location == location &&
        other.budget == budget &&
        other.deadline == deadline &&
        other.status == status &&
        other.attachmentUrls.length == attachmentUrls.length &&
        other.attachmentUrls.every((url) => attachmentUrls.contains(url)) &&
        other.createdAt == createdAt &&
        other.assignedTaskerId == assignedTaskerId;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      posterId,
      title,
      description,
      category,
      location,
      budget,
      deadline,
      status,
      attachmentUrls,
      createdAt,
      assignedTaskerId,
    );
  }

  @override
  String toString() {
    return 'Task(id: $id, title: $title, status: $status, budget: $budget)';
  }
}