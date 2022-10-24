import 'package:fom/models/meal.dart';
import 'package:fom/models/order.dart';

class DayStatistics {
  final DateTime date;
  final List<Order> ordersDelivered;
  List<Meal> allOrdersDeliveredMeals;
  double totalDayIncomes;

  DayStatistics({
    required this.date,
    required this.ordersDelivered,
    required this.allOrdersDeliveredMeals,
    required this.totalDayIncomes,
  });
}
