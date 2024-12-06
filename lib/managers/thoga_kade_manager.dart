import 'package:thogakade_management/managers/inventory_manager.dart';
import 'package:thogakade_management/model/order.dart';
import 'package:thogakade_management/repositories/order_repository.dart';
import 'package:thogakade_management/utils/formatter.dart';
import 'package:thogakade_management/utils/validators.dart';

abstract class ThogaKadeState {
  String stateName = "";
}

class LoadingState extends ThogaKadeState{
  @override
  String stateName = "loading";
}
class LoadedState extends ThogaKadeState{
  @override
  String stateName = "loaded";
}
class ErrorState extends ThogaKadeState{
  @override
  String stateName = "error";
}

class ThogaKadeManager{
  static final ThogaKadeManager _instance = ThogaKadeManager._();

  ThogaKadeState currentStatus = LoadedState();
  ThogaKadeManager._();

  factory ThogaKadeManager() => _instance;

  OrderRepository orderRepository = OrderRepository();
  InventoryManager inventoryManager = InventoryManager();

  changeState(ThogaKadeState state){
    currentStatus = state;
    print('State changed to: ${state.stateName}');
  }

  processOrder(Order order){
    order.timestamp = "${Formatter.formatDate(DateTime.now())} ${Formatter.formatTime(DateTime.now())}";
    order.items.forEach((id, qty) => inventoryManager.updateStock(id, qty));
    orderRepository.add(order);
  }

  String generateOrderId() {
    List<Order> orderList = orderRepository.getAll();
    int idNumber = orderList.isNotEmpty ? int.parse(orderList.last.id.substring(2)) + 1: 1;
    return  'OR${idNumber.toString().padLeft(4, '0')}';
  }

  List<Order> getOrderHistory() {
    return orderRepository.getAll();
  }

  List<Order> getAllOrdersByDate(DateTime date){
    List<Order> allOrderList = orderRepository.getAll();

    List<Order> todayOrderList = [];
    for(Order order in allOrderList){
      if(Validators.isSameDate(date, DateTime.parse(order.timestamp))) todayOrderList.add(order);
    }

    return todayOrderList;
  }
}

abstract class ThogaKadeException implements Exception{
  void showError();
}

class OrderProcessingException implements ThogaKadeException{
  final String _message;
  OrderProcessingException(this._message);

  @override
  void showError(){
    print('Order Processing Exception: $_message');
  }
}