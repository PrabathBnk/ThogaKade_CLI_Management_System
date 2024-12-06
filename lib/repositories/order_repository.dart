import 'dart:convert';
import 'dart:io';

import 'package:thogakade_management/managers/thoga_kade_manager.dart';
import 'package:thogakade_management/model/order.dart';

class OrderRepository{
  static final OrderRepository _instance = OrderRepository._();
  OrderRepository._();
  factory OrderRepository() => _instance;

  File orderDb = File('db/order.json');

  List<Order> getAll(){
    List<dynamic> ordersJson = jsonDecode(orderDb.readAsStringSync()) as List<dynamic>;
    List<Order> orderList = <Order>[];

    for (dynamic order in ordersJson) {
      orderList.add(Order.fromJson(order));
    }

    return orderList;
  }

  void add(Order order){
    List<Order> orderList = getAll();
    orderList.add(order);

    try{
      orderDb.writeAsStringSync(jsonEncode(orderList), flush: true);
    } catch (e){
      throw OrderProcessingException('Something went wrong, Order placement unsuccessful.');
    }
  }
}