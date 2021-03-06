import 'package:organizze/models/transaction_enum.dart';
import 'package:uuid/uuid.dart';

class TransactionModel {
  String uuid;
  DateTime date;
  TransactionType type;
  String title;
  String description;
  double value;
  bool isDone;

  TransactionModel(this.date, this.type, this.title, this.description, this.value, this.isDone) : this.uuid = Uuid().v4();

  TransactionModel.empty()
      : this.uuid = Uuid().v4(),
        this.date = DateTime.now(),
        this.type = TransactionType.EXPENSE,
        this.title = '',
        this.description = '',
        this.value = 0.0,
        this.isDone = false;
}
