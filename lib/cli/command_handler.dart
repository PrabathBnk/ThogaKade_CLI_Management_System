import 'dart:collection';
import 'dart:io';

import 'package:format/format.dart';
import 'package:thogakade_management/managers/inventory_manager.dart';
import 'package:thogakade_management/managers/thoga_kade_manager.dart';
import 'package:thogakade_management/model/order.dart';
import 'package:thogakade_management/model/vegetable.dart';
import 'package:thogakade_management/service/report_service.dart';
import 'package:thogakade_management/utils/formatter.dart';
import 'package:thogakade_management/utils/validators.dart';

import '../model/report.dart';

class CommandHandler{
  //Singleton
  static final CommandHandler _instance = CommandHandler._();
  CommandHandler._();
  factory CommandHandler() =>  _instance;

  InventoryManager inventoryManager = InventoryManager();
  ThogaKadeManager thogaKadeManager = ThogaKadeManager();
  ReportService reportService = ReportService();

  void home(){
    print('\n${'='*50}');
    print('${' '*5}Welcome to ThogaKade Management System');
    print('='*50);

    print('\n\t[1] Inventory');
    print('\t[2] Orders');
    print('\t[3] Daily Reports');
    print('\t[4] Alerts');
    print('\t[5] Exit');

    while(true){
      stdout.write('\nChoose Option Number: ');
      String? option = stdin.readLineSync();

      switch(option){
        case '1': inventory(); return;
        case '2': orders(); return;
        case '3': dailyReport(); return;
        case '4': alerts(); return;
        case '5': exit(0);
      }

      print('*** Invalid Input ***');
    }
  }

  //Inventory Handling ------------------
  void inventory(){
    print('='*30);
    print('${' '*10}Inventory');
    print('='*30);

    print('\n\t[1] View All Vegetables');
    print('\t[2] Add New Vegetable');
    print('\t[3] Update Vegetable');
    print('\t[4] Delete Vegetable');
    print('\t[5] Back');

    stdout.write('\nChoose Option Number: ');
    String? option = stdin.readLineSync();

    switch(option){
      case '1': viewAllVegetables(); break;
      case '2': addNewVegetable(); break;
      case '3': updateVegetable(); break;
      case '4': deleteVegetable(); break;
      default: home();
    }
  }

  void viewAllVegetables(){
    List<Vegetable> vegetableList = inventoryManager.getAllVegetables();

    print('-'*86);
    print('|  #  | ID      | Name            |     Price | Quantity | Category   | Expiry Date  |');
    print('-'*86);
    for(int i = 0; i < vegetableList.length; i++){
      print('| {num:3d} | {id:7s} | {name:15s} | {price:9.2f} | {qty:8d} | {category:10s} | {expDate:12s} |'.format({
        #num: i + 1,
        #id: vegetableList[i].id,
        #name: vegetableList[i].name,
        #price: vegetableList[i].price,
        #qty: vegetableList[i].quantity,
        #category: vegetableList[i].category,
        #expDate: vegetableList[i].expiryDate
      }));
    }
    print('-'*86);

    stdout.write('\nGo Back (Y/N):');
    String? option = stdin.readLineSync();

    if(option?.toUpperCase() == 'Y'){
      inventory();
    } else {
      home();
    }
  }

  void addNewVegetable(){
    print('\n${'='*30}');
    print('${' '*7}Add New Vegetable');
    print('='*30);

    Vegetable vegetable = Vegetable('', '', 0, 0, '', '');
    vegetable.id = inventoryManager.generateVegetableId();
    print('\nID: ${vegetable.id}\n');

    try{
      //Input Name
      vegetable.name = getName();

      //Input Price
      vegetable.price = getPrice();

      //Input Quantity
      vegetable.quantity = getQuantity();

      //Choose Category
      vegetable.category = chooseCategory();

      //Input Expiry Date
      vegetable.expiryDate = getExpiryDate();
    } on Exception{
      print('*** Invalid Input ***\n');

      stdout.write('\nDo you want to try again (Y/N): ');
      String? option = stdin.readLineSync();

      if(option?.toUpperCase() == 'Y'){
        addNewVegetable();
        return;
      } else {
        inventory();
      }
      return;
    }

    try{
      inventoryManager.addVegetable(vegetable);

      print('New Vegetable Successfully Added.');
      inventory();
    } on InventoryException catch (e){
      e.showError();

      stdout.write('Do you want to add item again (Y/N): ');
      String? option = stdin.readLineSync();

      if(option?.toUpperCase() == 'Y'){
        addNewVegetable();
        return;
      } else {
        inventory();
      }
    }
  }

  void updateVegetable(){
    print('\n${'='*30}');
    print('${' '*7}Update Vegetable');
    print('='*30);

    stdout.write('Search Vegetable by ID or Name: ');
    String? searchInfo = stdin.readLineSync();

    Vegetable? vegetable;

    try{
      vegetable = inventoryManager.searchVegetable(searchInfo!.toLowerCase());
    } on InventoryException catch(e){
      e.showError();

      stdout.write('\nDo you want to try again (Y/N): ');
      String? option = stdin.readLineSync();

      if(option?.toUpperCase() == 'Y'){
        updateVegetable();
        return;
      } else {
        inventory();
      }
    }

    print('\nID: ${vegetable?.id}');
    print('[1] Name: \t\t${vegetable?.name}');
    print('[2] Price: \t\t${vegetable?.price}');
    print('[3] Quantity: \t${vegetable?.quantity}');
    print('[4] Category: \t${vegetable?.category}');
    print('[5] Expiry Date: ${vegetable?.expiryDate}');

    stdout.write('\nWhat do you want to update(Choose Number): ');
    String? optionNum = stdin.readLineSync();

    try{
      switch(optionNum){
        case '1': vegetable?.name = getName(); break;
        case '2': vegetable?.price = getPrice(); break;
        case '3': vegetable?.quantity = getQuantity(); break;
        case '4': vegetable?.category = chooseCategory(); break;
        case '5': vegetable?.expiryDate = getExpiryDate(); break;
        default: throw Exception();
      }
    } on Exception{
      print('*** Invalid Input ***');
      updateVegetable();
    }


    try{
      inventoryManager.updateVegetable(vegetable!);

      print('Vegetable Successfully Updated.');
      inventory();
    } on InventoryException catch (e){
      e.showError();

      stdout.write('\nDo you want to update another item (Y/N): ');
      String? option = stdin.readLineSync();

      if(option?.toUpperCase() == 'Y'){
        updateVegetable();
        return;
      } else {
        inventory();
      }
    }
  }

  void deleteVegetable(){
    print('\n${'='*30}');
    print('${' '*7}Delete Vegetable');
    print('='*30);

    stdout.write('Search Vegetable by ID or Name: ');
    String? searchInfo = stdin.readLineSync();

    Vegetable? vegetable;

    try{
      vegetable = inventoryManager.searchVegetable(searchInfo!.toLowerCase());
    } on InventoryException catch(e){
      e.showError();

      stdout.write('\nDo you want to try again (Y/N): ');
      String? option = stdin.readLineSync();

      if(option?.toUpperCase() == 'Y'){
        updateVegetable();
        return;
      } else {
        inventory();
      }
    }

    print('\nID:\t\t\t${vegetable?.id}');
    print('Name:\t\t${vegetable?.name}');
    print('Price:\t\t${vegetable?.price}');
    print('Quantity:\t${vegetable?.quantity}');
    print('Category:\t${vegetable?.category}');
    print('Expiry Date: ${vegetable?.expiryDate}');

    while(true){
      stdout.write('Are you sure to delete this item (Y/N): ');
      String? option = stdin.readLineSync();

      if(option?.toUpperCase() == 'N'){
        inventory();
      }else if(option?.toUpperCase() == 'Y'){
        break;
      }
      print('*** Invalid Input ***');
    }

    try{
      inventoryManager.removeVegetable(vegetable!.id);

      print('\nVegetable Successfully Deleted.');
      inventory();
    } on InventoryException catch (e){
      e.showError();

      stdout.write('\nDo you want to try again(Y/N): ');
      String? option = stdin.readLineSync();

      if(option?.toUpperCase() == 'Y'){
        deleteVegetable();
        return;
      } else {
        inventory();
      }
    }
  }

  //Input Methods
  String getName(){
    stdout.write('Name: ');
    String name = stdin.readLineSync()!;
    Validators.emptyString(name);

    return name;
  }

  double getPrice(){
    stdout.write('Price: ');
    double price = double.parse(stdin.readLineSync()!);
    Validators.validateNonZeroValue(price);

    return price;
  }

  int getQuantity(){
    stdout.write('Quantity: ');
    int quantity = int.parse(stdin.readLineSync()!);
    Validators.validateNonZeroValue(quantity.toDouble());

    return quantity;
  }

  String getExpiryDate(){
    stdout.write('Expiry Date (YYYY-MM-DD): ');
    DateTime? expDate = DateTime.parse(stdin.readLineSync()!);
    Validators.validFutureDate(expDate);

    return Formatter.formatDate(expDate);
  }

  String chooseCategory(){
    print('Category:');
    print('\t[1] Leafy');
    print('\t[2] Root');
    print('\t[3] Fruit');
    print('\t[4] Other Vegetable');

    stdout.write('\nChoose category: ');
    String? categoryOption = stdin.readLineSync();
    switch(categoryOption){
      case '1': return 'Leafy';
      case '2': return 'Root';
      case '3': return 'Fruit';
      case '4': return 'Other';
      default: throw Exception();
    }
  }
  //-------------------------------

  //Order Handling ------------------
  void orders(){
    print('\n${'='*30}');
    print('${' '*12}Orders');
    print('='*30);

    print('\n\t[1] Place New Order');
    print('\t[2] View Order History');
    print('\t[3] Back');

    stdout.write('\nChoose Option Number: ');
    String? option = stdin.readLineSync();

    switch(option){
      case '1': placeOrder(); break;
      case '2': viewOrderHistory(); break;
      default: home();
    }
  }

  void placeOrder(){
    print('\n${'='*30}');
    print('${' '*10}Place Order');
    print('='*30);

    Order order = Order('', HashMap(), 0.0, '');
    order.id = thogaKadeManager.generateOrderId();
    print('Order ID: ${order.id}');

    print('\n----- Add Items -----');
    print('If you want to quit adding items, enter "Q".');

    //Add Items to the Order
    addItemsToOrder(order);

    order.totalAmount = calculateTotal(order.items);
    print('\nTotal Amount:\t${order.totalAmount}');

    while(true){
      stdout.write('\nConfirm order placement (Y/N): ');
      String? option = stdin.readLineSync();

      if(option?.toUpperCase() == 'Y'){
        try{
          thogaKadeManager.processOrder(order);
        } on ThogaKadeException catch (e){
          e.showError();
          continue;
        }
        print('Order Successfully Placed.');
        orders();
        break;
      } else if (option?.toUpperCase() == 'N') {
        orders();
        break;
      } else {
        print('Invalid Input Reenter.');
      }
    }
  }

  void viewOrderHistory(){
    List<Order> orderList = thogaKadeManager.getOrderHistory();

    print('\n${'='*56}');
    print('|  #  | Order ID | Total Amount  | TimeStamp           |');
    print('='*56);
    for(int i = 0; i < orderList.length; i++){
      print('| {num:3d} |  {id:7s} | {total:13.2f} | {timestamp:19s} |'.format({
        #num: i + 1,
        #id: orderList[i].id,
        #total: orderList[i].totalAmount,
        #timestamp: orderList[i].timestamp
      }));
      print('-'*56);
    }

    while(true){
      stdout.write('\nEnter number of the order to view details or if you want to go back enter "B": ');
      String? option = stdin.readLineSync();

      if(option?.toUpperCase() == 'B') {
        orders();
        return;
      } else {
        try{
          viewOrderDetail(option!);
          return;
        } catch(e){
          print('*** Invalid Input ***');
        }
      }
    }

  }

  void viewOrderDetail(String indexStr){
    int index = int.parse(indexStr) - 1;
    Order order = thogaKadeManager.getOrderHistory()[index];

    print('\nOrder ID: ${order.id}');

    print('-'*71);
    print('| Vegetable ID | Vegetable Name | Price      | Quantity | Sub Total   |');
    print('-'*71);
    order.items.forEach((id, qty) {
      Vegetable vegetable = inventoryManager.searchVegetable(id);
      print('| {id:12s} | {name:14s} | {price:10.2f} | {qty:8d} | {subTotal:11.2f} |'.format({
        #id: id,
        #name: vegetable.name,
        #price: vegetable.price,
        #qty: qty,
        #subTotal: (vegetable.price * qty)
      }));
    });
    print('-'*71);
    
    print('${' '*44}Total Amount: ${format('{0:11.2f}', order.totalAmount)}');

    stdout.write('\n\nGo Back (Y/N): ');
    String? option = stdin.readLineSync();

    if(option?.toUpperCase() == 'Y'){
      viewOrderHistory();
    } else {
      orders();
    }
  }

  //Add Items to the Order
  void addItemsToOrder(Order order){
    while(true){
      stdout.write('\nItem Id or Name: ');
      String? searchInfo = stdin.readLineSync();
      Vegetable vegetable;
      if(searchInfo?.toUpperCase() == 'Q') break;

      try{
        vegetable = inventoryManager.searchVegetable(searchInfo!);
      } on InventoryException catch(e){
        e.showError();
        continue;
      }

      print('ID: ${vegetable.id} | Name: ${vegetable.name} | ${vegetable.price}');

      stdout.write('Quantity: ');
      int quantity;
      try{
        quantity = int.parse(stdin.readLineSync()!);
      } on FormatException{
        print('*** Invalid Input ***');
        continue;
      }

      order.items.addAll({vegetable.id: quantity});
    }

    if(order.items.isEmpty){
      print('A minimum of one item is required.');

      stdout.write('\nDo you want to add items (Y/N): ');
      String? option = stdin.readLineSync();
      if(option?.toUpperCase() == 'Y'){
        addItemsToOrder(order);
      } else{
        orders();
      }
    }
  }

  //Calculate Total Amount of the Order
  double calculateTotal(Map<String, int> items){
    double totalAmount = 0.0;
    items.forEach((id, qty) {
      totalAmount += inventoryManager.searchVegetable(id.toLowerCase()).price * qty;
    });

    return totalAmount;
  }
  //-------------------------------

  //Daily Report
  void dailyReport(){
    Report report = reportService.generateReport();

    print('\n${'='*30}');
    print('${'   '}Sales Report: ${Formatter.formatDate(DateTime.now())}');
    print('='*30);

    print('\nHighest Sales\n${'-'*48}');
    print('|  #  | Order ID | No. of Items | Total Amount |');
    print('-'*48);
    for(int i = 0; i < report.orders.length; i++){
      print('| {num:3d} | {id:8s} | {items:12d} | {total:12.2f} |'.format({
        #num: i + 1,
        #id: report.orders[i].id,
        #items: report.orders[i].items.length,
        #total: report.orders[i].totalAmount
      }));
    }
    print('-'*48);

    print('\nTotal Sales: ${format('{0:10.2f}', report.totalSalesAmount)}');
    print('='*23);

    stdout.write('\nGo Back: ');
    String? option = stdin.readLineSync();

    home();
  }

  //Alerts
  void alerts(){
    print('\n${'='*30}');
    print('${' '*10}Alerts');
    print('='*30);

    List<Vegetable> lowStockList = inventoryManager.getLowStockVegetables();
    List<Vegetable> expiredItems = inventoryManager.getExpiredVegetables();

    if(lowStockList.isNotEmpty || expiredItems.isNotEmpty){
      for(Vegetable vegetable in lowStockList){
        print('Low Stock: ${vegetable.id}, ${vegetable.name}, ${vegetable.quantity}');
      }

      for(Vegetable vegetable in expiredItems){
        print('Expired Item: ${vegetable.id}, ${vegetable.name}, ${Formatter.formatDate(DateTime.parse(vegetable.expiryDate))}');
      }
    } else {
      print('There is no alert.');
    }

    stdout.write('\nGo Back: ');
    stdin.readLineSync();

    home();
  }
}