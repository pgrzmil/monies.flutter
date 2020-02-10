import 'baseStorageProvider.dart';
import 'models/category.dart';

class CategoriesProvider extends BaseStorageProvider<ExpenseCategory> {
  CategoriesProvider() : super(storeKey: "Categories", fromJsonString: ExpenseCategory.fromJsonString);

@override
  List<ExpenseCategory> getAll() {
    _sortByOrder();
    return super.getAll();
  }

  void _sortByOrder() {
    items.sort((cat1, cat2) => cat1.order.compareTo(cat2.order));
  }

  String titleFor({String id}) => items.firstWhere((x) => x.id == id, orElse: () => null)?.title;
}
