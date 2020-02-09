import 'baseStorageProvider.dart';
import 'models/category.dart';

class CategoriesProvider extends BaseStorageProvider<ExpenseCategory> {
  CategoriesProvider() : super(storeKey: "Categories", fromJsonString: ExpenseCategory.fromJsonString);

  String titleFor({String id}) => items.firstWhere((x) => x.id == id, orElse: () => null)?.title;
}
