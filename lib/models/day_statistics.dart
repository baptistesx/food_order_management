import 'package:fom/models/order.dart';
import 'package:fom/models/pizza.dart';

class DayStatistics {
  final DateTime date;
  final List<Order> ordersDelivered;
  List<Pizza> allOrdersDeliveredPizzas;
  double totalDayIncomes;

  DayStatistics({
    required this.date,
    required this.ordersDelivered,
    required this.allOrdersDeliveredPizzas,
    required this.totalDayIncomes,
  });
}
