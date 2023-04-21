import 'package:hive/hive.dart';

part 'expense_item.g.dart';

@HiveType(typeId: 0)
class ExpenseItem extends HiveObject {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final String amount;
  @HiveField(2)
  final DateTime dateTime;

  ExpenseItem({
    required this.name,
    required this.amount,
    required this.dateTime,
  });
}
