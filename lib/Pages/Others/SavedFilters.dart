import 'package:flutter/material.dart';

import '../../Local_DB/db_service.dart';

class SavedFilters extends StatefulWidget {
  @override
  _SavedFiltersState createState() => _SavedFiltersState();
}

class _SavedFiltersState extends State<SavedFilters> {
  List<Map<String, dynamic>> savedFilters = [];
  var _FilterService = FilterService();
  String selectedValue = 'ProjectAllocation'; // Default selected value
  List<String> dropdownValues = ['ProjectAllocation', 'EmployeeProductivity'];

  Future<void> fetchData() async {
    var get = await _FilterService.readEmployeeFilter();
    print('GetAll $get');
    savedFilters = get;
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    print(savedFilters);
  }

  Future<void> fetchDataForSelectedValue(String selectedValue) async {
    List<Map<String, dynamic>> data = [];
    if (selectedValue == 'ProjectAllocation') {
      data = await _FilterService.readProjectFilter();
    } else if (selectedValue == 'EmployeeProductivity') {
      data = await _FilterService.readEmployeeFilter();
    }
    setState(() {
      savedFilters = data;
      print('savedFilters $savedFilters');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFEFF5FE),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.keyboard_arrow_left, color: Color(0xFF5C658B)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Saved Filter',
          style: TextStyle(color: Color(0xFF0E142E)),
        ),
        actions: <Widget>[
          IconButton(
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(),
            icon: Icon(
              Icons.account_circle_rounded,
              color: Color(0xFF647DF5),
            ),
            onPressed: () {},
          ),
          IconButton(
            padding: EdgeInsets.only(left: 0.0, right: 20.0),
            constraints: BoxConstraints(),
            icon: Icon(
              Icons.expand_more,
              color: Color(0xFF9BA3C2),
            ),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('ProfileSettings');
            },
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Page',
              style: TextStyle(color: Color(0xFF9AA2C1)),
            ),
            SizedBox(height: 10),
            Container(
              width: double.infinity, // Make the container full width
              padding: EdgeInsets.all(8.0), // Add padding if needed
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey), // Add border if desired
                borderRadius:
                    BorderRadius.circular(8.0), // Add border radius if desired
              ),
              child: DropdownButton<String>(
                value: selectedValue,
                items: dropdownValues.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedValue = newValue!;
                  });
                  // Call the fetchDataForSelectedValue function with the selected value
                  fetchDataForSelectedValue(selectedValue);
                },
                isExpanded: true, // Make the dropdown button take full width
              ),
            )
          ],
        ),
      ),
    );
  }
}
