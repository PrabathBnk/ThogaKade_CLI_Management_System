import 'package:thogakade_management/managers/inventory_manager.dart';
import 'package:thogakade_management/model/vegetable.dart';
import 'package:thogakade_management/utils/formatter.dart';

class Validators{

  static void validateNonZeroValue(double price){
    if(price <= 0.0) throw Exception();
  }

  static void validFutureDate(DateTime date){
    if (date.isBefore(DateTime.now())) throw Exception();
  }

  static void emptyString(String str){
    if(str.trim().isEmpty) throw Exception();
  }

  static void alreadyExistsWithName(String id, String name){
    List<Vegetable> vegetableList = InventoryManager().getAllVegetables();
    for (Vegetable item in vegetableList) {
      if(item.name == name && item.id != id) throw InventoryException('A vegetable already exists with name: ${name}');
    }
  }

  static bool isSameDate(DateTime date1, DateTime date2){
    return Formatter.clearTime(date1).isAtSameMomentAs(Formatter.clearTime(date2));
  }
}
