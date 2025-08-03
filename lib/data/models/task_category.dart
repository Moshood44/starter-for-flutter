enum TaskCategory {
  academics,
  foodAndDrink,
  errands,
  delivery,
  other;

  String get displayName {
    switch (this) {
      case TaskCategory.academics:
        return 'Academics';
      case TaskCategory.foodAndDrink:
        return 'Food & Drink';
      case TaskCategory.errands:
        return 'Errands';
      case TaskCategory.delivery:
        return 'Delivery';
      case TaskCategory.other:
        return 'Other';
    }
  }

  static TaskCategory fromString(String category) {
    switch (category.toLowerCase()) {
      case 'academics':
        return TaskCategory.academics;
      case 'foodanddrink':
      case 'food_and_drink':
        return TaskCategory.foodAndDrink;
      case 'errands':
        return TaskCategory.errands;
      case 'delivery':
        return TaskCategory.delivery;
      case 'other':
        return TaskCategory.other;
      default:
        throw ArgumentError('Invalid task category: $category');
    }
  }
}