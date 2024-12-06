import 'dart:io';

import 'package:format/format.dart';
import 'package:thogakade_management/cli/command_handler.dart';
import 'package:thogakade_management/managers/thoga_kade_manager.dart';
import 'package:thogakade_management/model/vegetable.dart';
import 'package:thogakade_management/repositories/inventory_repository.dart';
import 'package:thogakade_management/utils/validators.dart';

class InventoryManager{
  static final InventoryManager _instance = InventoryManager._();
  InventoryManager._();
  factory InventoryManager() => _instance;

  InventoryRepository repository = InventoryRepository();

  void addVegetable(Vegetable vegetable){
    Validators.alreadyExistsWithName(vegetable.id, vegetable.name);
    repository.add(vegetable);
  }

  void removeVegetable(String id){
    repository.remove(id);
  }

  void updateStock(String id, int quantity){
    Vegetable vegetable = repository.get(id);
    vegetable.quantity -= quantity;
    repository.update(vegetable);
  }

  List<Vegetable> getAllVegetables(){
    return repository.getAll();
  }

  String generateVegetableId() {
    List<Vegetable> all = repository.getAll();
    String lastId = all.isNotEmpty ?  all.last.id: 'VEG000';

    return 'VEG${'${int.parse(lastId.substring(3,6)) + 1}'.padLeft(3, '0')}';
  }

  Vegetable searchVegetable(String searchInfo) {
    List<Vegetable> vegetableList = repository.getAll();

    for(Vegetable vegetable in vegetableList){
      if(vegetable.id.toLowerCase() == searchInfo.toLowerCase() || vegetable.name.toLowerCase() == searchInfo.toLowerCase()){
        return vegetable;
      }
    }
    throw InventoryException("Vegetable not found");
  }

  void updateVegetable(Vegetable vegetable) {
    Validators.alreadyExistsWithName(vegetable.id, vegetable.name);
    repository.update(vegetable);
  }

  List<Vegetable> getLowStockVegetables(){
    List<Vegetable> allVegetableList = repository.getAll();
    List<Vegetable> lowStockVegetables = [];

    for(Vegetable vegetable in allVegetableList){
      //Assume less than 10 quantities is low stock.
      if(vegetable.quantity < 10) lowStockVegetables.add(vegetable);
    }

    return lowStockVegetables;
  }

  List<Vegetable> getExpiredVegetables(){
    List<Vegetable> allVegetableList = repository.getAll();
    List<Vegetable> expiredVegetables = [];

    for(Vegetable vegetable in allVegetableList){
      if(DateTime.parse(vegetable.expiryDate).isBefore(DateTime.now())) expiredVegetables.add(vegetable);
    }

    return expiredVegetables;
  }
}

class InventoryException implements ThogaKadeException{
  final String _message;
  InventoryException(this._message);

  @override
  void showError(){
    print('Inventory Exception: $_message');
  }
}