import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool _isExpanded = false;

  final List<Map<String, dynamic>> _filters = [
    {'label': 'No Kids Zone', 'isChecked': false},
    {'label': 'Pet-Friendly', 'isChecked': false},
    {'label': 'Free breakfast', 'isChecked': false},
  ];
  final List<dynamic> _selectedFilter = [];

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Please Check your choice'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.filter_alt_rounded),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      children: [
                        _selectedFilter.isEmpty
                            ? const Text('No Filters')
                            : Column(
                                children: _selectedFilter.map<Widget>((filter) {
                                  return Text(filter['label']);
                                }).toList(),
                              )
                      ],
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Icon(Icons.calendar_month_sharp),
                    Text(_checkin != null
                        ? '${_checkin!.year}/${_checkin!.month}/${_checkin!.day}'
                        : 'No Date Selected')
                  ],
                )
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
                onPressed: () => Navigator.pushReplacementNamed(context, '/'),
                child: const Text('Search')),
            TextButton(
              child: const Text('Cancle'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  DateTime? _checkin;

  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );

    setState(() {
      _checkin = pickedDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Search'),
        ),
        body: Stack(
          children: [
            ListView(
              children: [
                ExpansionPanelList(
                  expansionCallback: (int index, bool isExpanded) {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                  children: [
                    ExpansionPanel(
                      isExpanded: _isExpanded,
                      headerBuilder: (context, isOpen) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.1,
                              ),
                              const Text(
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  'Filters'),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.3,
                              ),
                              Expanded(
                                child: Text(
                                  _selectedFilter.isEmpty
                                      ? 'No Filters'
                                      : _selectedFilter
                                          .map((filter) => filter['label'])
                                          .join(', '),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                            ],
                          ),
                        );
                      },
                      body: Column(
                        children: List.generate(_filters.length, (index) {
                          return CheckboxMenuButton(
                            child: Text(_filters[index]['label']),
                            value: _filters[index]['isChecked'],
                            onChanged: (bool? value) {
                              setState(() {
                                _filters[index]['isChecked'] = value ?? false;
                                _selectedFilter.contains(_filters[index])
                                    ? _selectedFilter.remove(_filters[index])
                                    : _selectedFilter.add(_filters[index]);
                              });
                            },
                          );
                        }),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // sub title - date
                        const Row(
                          children: [
                            SizedBox(
                              width: 47,
                            ),
                            Text(
                                style: TextStyle(fontWeight: FontWeight.bold),
                                'Date'),
                          ],
                        ),
                        const SizedBox(height: 20),
                        //select sector
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                const Row(
                                  children: [
                                    Icon(Icons.calendar_month_rounded),
                                  ],
                                ),
                                Text(
                                  _checkin != null
                                      ? '${_checkin!.year}/${_checkin!.month}/${_checkin!.day}'
                                      : 'No date selected',
                                )
                              ],
                            ),
                            const SizedBox(width: 20),
                            TextButton(
                                style: TextButton.styleFrom(
                                    backgroundColor: Colors.green[50]),
                                onPressed: _selectDate,
                                child: const Text('select date'))
                          ],
                        )
                      ]),
                )
              ],
            ),
            Align(
              alignment: const Alignment(0, 0.8),
              child: SizedBox(
                width: 150,
                height: 60,
                child: TextButton(
                  style:
                      TextButton.styleFrom(backgroundColor: Colors.blue[100]),
                  onPressed: _showMyDialog,
                  child: const Text(style: TextStyle(fontSize: 20), 'Search'),
                ),
              ),
            )
          ],
        ));
  }
}
