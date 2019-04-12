import 'package:scoped_model/scoped_model.dart';
import 'dart:async';

import '../models/filter.dart';

mixin FilterService on Model {
  List<FilterModel> _filterList = [];
  List<FilterModel> get filterList => _filterList;

  // List<String> _selectedValueResult = [];
  // List<String> get selectedValueResult => _selectedValueResult;

  // void setValuesResult(String values) {
  //   return _selectedValueResult.add(values);
  // }

  int _selFilterIndex;

  // FilterModel get getSelectedFilter {
  //   if (_selFilterIndex == null) {
  //     return null;
  //   }
  //   return _filterList[_selFilterIndex];
  // }

  void selectedFilter(int index) {
    _selFilterIndex = index;
    notifyListeners();
  }

  // void toggleIsCurrentlySelected() {
  //   final bool newSelected = !getSelectedFilter.isSelected;
  //   final FilterModel updateSelected =
  //       FilterModel(getSelectedFilter.name, newSelected);

  //   _filterList[_selFilterIndex] = updateSelected;
  //   notifyListeners();
  // }

  void updateStatus() {
    _filterList.forEach((filter) => filter.isSelected = false);
    _filterList[_selFilterIndex].isSelected = true;
    notifyListeners();
  }

  Future<void> fetchFilter() async {
    _filterList.add(FilterModel("Redeem", false));
    _filterList.add(FilterModel("Claim", false));
  }
}
