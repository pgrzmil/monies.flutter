import 'baseStorageProvider.dart';
import 'models/category.dart';

class CategoriesProvider extends BaseStorageProvider<ExpenseCategory> {
  CategoriesProvider() : super(storeKey: "Categories", fromJsonString: ExpenseCategory.fromJsonString);

@override
  List<ExpenseCategory> getAll() {
    return super.getAll().sortByOrder();
  }

  String titleFor({String id}) => items.firstWhere((x) => x.id == id, orElse: () => null)?.title;
}

extension CategoriesExtension on Iterable<ExpenseCategory> {
  Iterable<ExpenseCategory> sortByOrder() {
    var sorted = this.toList();
    sorted.sort((cat1, cat2) => cat1.order.compareTo(cat2.order));
    return sorted;
  }
}