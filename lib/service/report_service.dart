import 'package:thogakade_management/managers/thoga_kade_manager.dart';
import 'package:thogakade_management/model/order.dart';
import 'package:thogakade_management/model/report.dart';
import 'package:thogakade_management/utils/formatter.dart';

class ReportService{

  static final ReportService _instance = ReportService._();
  ReportService._();
  factory ReportService() => _instance;

  ThogaKadeManager thogaKadeManager = ThogaKadeManager();

  Report generateReport(){
    Report report = Report(DateTime.now(), [], 0.0);
    report.orders = thogaKadeManager.getAllOrdersByDate(DateTime.now());

    for(Order order in report.orders){
      report.totalSalesAmount += order.totalAmount;
    }
    report.orders.sort((order1, order2) => order2.totalAmount.compareTo(order1.totalAmount));
    return report;
  }
}