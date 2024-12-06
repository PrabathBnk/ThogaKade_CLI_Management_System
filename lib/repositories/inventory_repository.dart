import 'dart:convert';
import 'dart:io';

import 'package:thogakade_management/managers/inventory_manager.dart';
import 'package:thogakade_management/model/vegetable.dart';

class InventoryRepository{
  //Singleton the class
  static final InventoryRepository _instance = InventoryRepository._();
  InventoryRepository._();
  factory InventoryRepository() => _instance;

  //Inventory JSON file
  File inventoryDb = File('db/inventory.json');

  void add(Vegetable vegetable){
    List<Vegetable> inventoryList = getAll();
    inventoryList.add(vegetable);

    try{
      inventoryDb.writeAsStringSync(jsonEncode(inventoryList), flush: true);
    } on IOException{
      print('Something want wrong! Item adding unsuccessful.');
    }
  }

  List<Vegetable> getAll(){
    List<dynamic> inventoryJsonList = jsonDecode(inventoryDb.readAsStringSync()) as List<dynamic>;
    List<Vegetable> inventoryList = [];

    for(dynamic item in inventoryJsonList){
      inventoryList.add(Vegetable.fromJson(item));
    }

    return inventoryList;
  }

  Vegetable get(String id){
    List<Vegetable> inventoryList = getAll();
    for (Vegetable item in inventoryList) {
      if(item.id == id) return item;
    }
    throw InventoryException('Vegetable not found');
  }

  void update(Vegetable vegetable){
    List<Vegetable> inventoryList = getAll();

    for(int i = 0; i < inventoryList.length; i++){
      if(inventoryList[i].id == vegetable.id) inventoryList[i] = vegetable;
    }

    try{
      inventoryDb.writeAsStringSync(jsonEncode(inventoryList), flush: true);
    } on IOException{
      throw InventoryException('Something want wrong! Item update unsuccessful.');
    }
  }

  void remove(String id){
    List<Vegetable> inventoryList = getAll();
    inventoryList.removeWhere((item) => item.id == id);

    try{
      inventoryDb.writeAsStringSync(jsonEncode(inventoryList), flush: true);
    } on IOException{
      throw InventoryException('Something want wrong! Item deletion unsuccessful.');
    }
  }
}