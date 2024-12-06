import 'package:thogakade_management/model/order.dart';

class Report{
  DateTime date;
  List<Order> orders;
  double totalSalesAmount;

  Report(this.date, this.orders, this.totalSalesAmount);
}