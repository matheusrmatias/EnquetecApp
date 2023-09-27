import 'package:flutter/cupertino.dart';
import '../models/coordinator_model.dart';

class CoordinatorRepository extends ChangeNotifier{
  Coordinator coordinator;
  CoordinatorRepository({required this.coordinator});
}