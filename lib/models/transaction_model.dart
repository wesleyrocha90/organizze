import 'package:organizze/models/transaction_enum.dart';
import 'package:uuid/uuid.dart';

class TransactionModel {
  String uuid;
  TransactionType type;
  String title;
  String description;
  double value;
  bool isDone;

  TransactionModel(this.type, this.title, this.description, this.value, this.isDone)
    : this.uuid = Uuid().v4();
}