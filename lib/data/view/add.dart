import 'package:flutter/material.dart';

class Add extends StatefulWidget {
  const Add({super.key});

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {
  final _formKeyStep1 = GlobalKey<FormState>();
  final _formKeyStep2 = GlobalKey<FormState>();
  final _formKeyStep3 = GlobalKey<FormState>();
  final _formKeyStep4 = GlobalKey<FormState>();
  GlobalKey<FormState> _formKeyForCurrentStep() {
    switch (_steps) {
      case 1:
        return _formKeyStep1;
      case 2:
        return _formKeyStep2;
      case 3:
        return _formKeyStep3;
      case 4:
        return _formKeyStep4;
      default:
        return _formKeyStep1;
    }
  }

  int _steps = 2;
  List<String> labelStep = ["Basic", "Personal", "Educ", "Civic", "Finish"];

  // First form

  final _fnameController = TextEditingController();
  final _mnameController = TextEditingController();
  final _lnameController = TextEditingController();
  final _ageController = TextEditingController();
  final _dobController = TextEditingController();
  String? sexVal;
  String? genVal;
  String? addrVal;


  final _cnController = TextEditingController();
  final _pobController = TextEditingController();
  final _nocController = TextEditingController();
  final _hController = TextEditingController();
  final _wController = TextEditingController();
  final _occController = TextEditingController();
  String? civilStatsVal;
  String? religionVal;
  String? youthTypeVal;

  // Map<String, String> firstForm() => {
  //   'fname': _fnameController.text,
  //   'mname': _mnameController.text,
  //   'lname': _lnameController.text,
  //   'dateOfBirth': _dobController.text,
  //   'age': _ageController.text,
  //   'sex': sexVal ?? '',
  //   'gender': genVal ?? '',
  //   'address': addrVal ?? '',
  // };

  final List<String> youthType = ['OSY', 'ISY'];
  final List<String> religion = ['Islam', 'Christianity', 'Agnostic', 'Others'];
  final List<String> civilStats = [
    'Single',
    'Married',
    'Divorce',
    'Outside marriage',
  ];

  // 1
  final List<String> sex = ['Male', 'Female'];
  final List<String> gender = ['Male', 'Female', 'Gay', 'Others'];
  final List<String> address = [
    'Zone 1',
    'Zone 2',
    'Zone 3',
    'Zone 4',
    'Sittio Lugakit',
    'Sittio Balunu',
    'Sittio Hapa',
    'Sittio Carreon',
    'Sittio San Antonioay',
  ];

  void nextStep({bool isNext = true}) {
    if ((isNext && _steps > 5) || (!isNext && _steps == 1)) {
      return;
    }
    isNext ? setState(() => _steps++) : setState(() => _steps--);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(size: 20, Icons.arrow_back, color: Colors.black),
            SizedBox(width: 12),
            Text('Back', style: TextStyle(color: Colors.black, fontSize: 15)),
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(size: 25, Icons.add_rounded),
              Text(
                'Inserting Youth',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          Container(
            margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: stepTab(),
            ),
          ),

          Expanded(
            flex: 1,
            child: Scrollbar(
              thumbVisibility: true, // Optional
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: contentStep[_steps.clamp(1, contentStep.length) - 1],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 2, 25, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _steps > 1
                            ? const Color.fromARGB(82, 0, 0, 0)
                            : const Color.fromARGB(34, 0, 0, 0),
                  ),
                  onPressed: () => nextStep(isNext: false),
                  child: Text(
                    'Back',
                    style: TextStyle(
                      color:
                          _steps > 1
                              ? Colors.white
                              : const Color.fromARGB(81, 0, 0, 0),
                    ),
                  ),
                ),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(20, 126, 169, 1),
                  ),
                  onPressed: () {
                    if (_formKeyForCurrentStep().currentState!.validate()) {
                      nextStep();
                    }
                  },
                  child: Text(
                    _steps == contentStep.length ? 'Finish' : 'Next',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // content steps

  List<Widget> get contentStep => [
    Form(
      key: _formKeyForCurrentStep(),
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(
              labelText: 'First Name',
              labelStyle: TextStyle(fontSize: 12),
              hintText: 'Enter your first name',
              border: OutlineInputBorder(),
              isDense: true,
              contentPadding: EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 10,
              ),
            ),
            style: TextStyle(fontSize: 12, color: Colors.black),
            controller: _fnameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your first name';
              }
              if (value.length > 20) {
                return 'Use only 20 characters';
              }
              return null;
            },
          ),

          SizedBox(height: 10),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Middle Name',
              labelStyle: TextStyle(fontSize: 12),
              hintText: 'Enter your Middle name',
              border: OutlineInputBorder(),
              isDense: true,
              contentPadding: EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 10,
              ),
            ),
            style: TextStyle(fontSize: 12, color: Colors.black),
            controller: _mnameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your middle name';
              }
              if (value.length > 20) {
                return 'Use only 20 characters';
              }
              return null;
            },
          ),

          SizedBox(height: 10),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Last Name',
              labelStyle: TextStyle(fontSize: 12),
              hintText: 'Enter your last name',
              border: OutlineInputBorder(),
              isDense: true,
              contentPadding: EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 10,
              ),
            ),
            style: TextStyle(fontSize: 12, color: Colors.black),
            controller: _lnameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your last name';
              }
              if (value.length > 20) {
                return 'Use only 20 characters';
              }
              return null;
            },
          ),

          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextFormField(
                  controller: _dobController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Date of Birth',
                    labelStyle: TextStyle(fontSize: 12),
                    hintText: 'MM/DD/YYYY',
                    border: OutlineInputBorder(),
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 10,
                    ),
                  ),
                  style: TextStyle(fontSize: 12, color: Colors.black),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Date of Birth is required';
                    }

                    try {
                      final parts = value.split('/');
                      final month = int.parse(parts[0]);
                      final day = int.parse(parts[1]);
                      final year = int.parse(parts[2]);
                      final dob = DateTime(year, month, day);
                      final today = DateTime.now();
                      final age =
                          today.year -
                          dob.year -
                          ((today.month < dob.month ||
                                  (today.month == dob.month &&
                                      today.day < dob.day))
                              ? 1
                              : 0);

                      if (age < 15 || age > 30) {
                        return 'Age must be between 15 and 30 years old';
                      }
                    } catch (e) {
                      return 'Invalid date format';
                    }

                    return null;
                  },
                  onTap: () async {
                    DateTime today = DateTime.now();
                    DateTime maxDate = DateTime(
                      today.year - 15,
                      today.month,
                      today.day,
                    );
                    DateTime minDate = DateTime(
                      today.year - 30,
                      today.month,
                      today.day,
                    );

                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: maxDate,
                      firstDate: minDate,
                      lastDate: maxDate,
                    );

                    if (pickedDate != null) {
                      String formattedDate =
                          "${pickedDate.month}/${pickedDate.day}/${pickedDate.year}";
                      final today = DateTime.now();
                      int age = today.year - pickedDate.year;
                      if (today.month < pickedDate.month ||
                          (today.month == pickedDate.month &&
                              today.day < pickedDate.day)) {
                        age--;
                      }
                      setState(() {
                        _dobController.text = formattedDate;
                        _ageController.text = age.toString();
                      });
                    }
                  },
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _ageController.text != '' ? _ageController.text : '--',
                      style: TextStyle(fontSize: 17),
                    ),
                    Text(
                      'Generated age',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildDropDown(sexVal, "Select Sex", "Sex", sex, (
                  newValue,
                ) {
                  setState(() {
                    sexVal = newValue;
                  });
                }),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _buildDropDown(
                  genVal,
                  "Select Gender",
                  "Gender",
                  gender,
                  (newValue) {
                    setState(() {
                      genVal = newValue;
                    });
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          _buildDropDown(addrVal, "Select Address", "Address", address, (
            newValue,
          ) {
            setState(() {
              addrVal = newValue;
            });
          }),
          SizedBox(height: 10),
        ],
      ),
    ),

    // 2nd step
    Form(
      key: _formKeyForCurrentStep(),
      child: Column(
        children: [
          _buildDropDown(sexVal, "Select Youth type", "Type", youthType, (
                  newValue,
                ) {
                  setState(() {
                    sexVal = newValue;
                  });
                }),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Place of Birth',
              labelStyle: TextStyle(fontSize: 12),
              hintText: 'Enter your Place of Birth',
              border: OutlineInputBorder(),
              isDense: true,
              contentPadding: EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 10,
              ),
            ),
            style: TextStyle(fontSize: 12, color: Colors.black),
            controller: _lnameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your Place of Birth';
              }
              if (value.length > 30) {
                return 'Use only 30 characters';
              }
              return null;
            },
          ),
          TextFormField(
            keyboardType:TextInputType.number,
            decoration: InputDecoration(
              
              labelText: 'Contact no.',
              labelStyle: TextStyle(fontSize: 12),
              hintText: '9554433221',
              border: OutlineInputBorder(),
              isDense: true,
              contentPadding: EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 10,
              ),
            ),
            style: TextStyle(fontSize: 12, color: Colors.black),
            controller: _lnameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your last name';
              }
              if (value.length > 20) {
                return 'Use only 20 characters';
              }
              return null;
            },
          ),
        ],
      ),
    ),
  ];

  // build drop down

  Widget _buildDropDown(
    String? currentVal,
    String hintText,
    String label,
    List<String> array,
    ValueChanged<String?> onChanged,
  ) {
    return DropdownButtonFormField<String>(
      value: currentVal,
      hint: Text(hintText),
      decoration: InputDecoration(
        labelStyle: TextStyle(fontSize: 12),
        labelText: label,
        border: OutlineInputBorder(),
        isDense: true,
        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      ),
      style: TextStyle(fontSize: 12, color: Colors.black),

      items:
          array
              .map(
                (String value) =>
                    DropdownMenuItem<String>(value: value, child: Text(value)),
              )
              .toList(),
      onChanged: onChanged,
      validator: (value) => value == null ? 'Please select $label' : null,
    );
  }

  // tabs

  List<Widget> stepTab() => [
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 15,
          backgroundColor:
              _steps >= 1 ? Color.fromRGBO(20, 126, 169, 1) : Colors.black12,
          child: Text(
            '1',
            style: TextStyle(
              color: _steps >= 1 ? Colors.white : Colors.black,
              fontSize: 11,
            ),
          ),
        ),
        Text(labelStep[0], style: TextStyle(color: Colors.black, fontSize: 11)),
      ],
    ),
    Container(
      margin: EdgeInsetsDirectional.only(bottom: 12),
      height: 4,
      width: 32,
      decoration: BoxDecoration(
        color:
            _steps > 1 ? Color.fromRGBO(20, 126, 169, 1) : Colors.transparent,
        border: Border.all(color: Colors.black26, width: 1),
        borderRadius: BorderRadius.circular(25),
      ),
    ),

    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 15,
          backgroundColor:
              _steps >= 2 ? Color.fromRGBO(20, 126, 169, 1) : Colors.black12,
          child: Text(
            '2',
            style: TextStyle(
              color: _steps >= 2 ? Colors.white : Colors.black,
              fontSize: 11,
            ),
          ),
        ),
        Text(labelStep[1], style: TextStyle(color: Colors.black, fontSize: 11)),
      ],
    ),
    Container(
      margin: EdgeInsetsDirectional.only(bottom: 12),
      height: 4,
      width: 32,
      decoration: BoxDecoration(
        color:
            _steps > 2 ? Color.fromRGBO(20, 126, 169, 1) : Colors.transparent,
        border: Border.all(color: Colors.black26, width: 1),
        borderRadius: BorderRadius.circular(25),
      ),
    ),

    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 15,
          backgroundColor:
              _steps >= 3 ? Color.fromRGBO(20, 126, 169, 1) : Colors.black12,
          child: Text(
            '3',
            style: TextStyle(
              color: _steps >= 3 ? Colors.white : Colors.black,
              fontSize: 11,
            ),
          ),
        ),
        Text(labelStep[2], style: TextStyle(color: Colors.black, fontSize: 11)),
      ],
    ),
    Container(
      margin: EdgeInsetsDirectional.only(bottom: 12),
      height: 4,
      width: 32,
      decoration: BoxDecoration(
        color:
            _steps > 3 ? Color.fromRGBO(20, 126, 169, 1) : Colors.transparent,
        border: Border.all(color: Colors.black26, width: 1),
        borderRadius: BorderRadius.circular(25),
      ),
    ),

    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 15,
          backgroundColor:
              _steps >= 4 ? Color.fromRGBO(20, 126, 169, 1) : Colors.black12,
          child: Text(
            '4',
            style: TextStyle(
              color: _steps >= 4 ? Colors.white : Colors.black,
              fontSize: 11,
            ),
          ),
        ),
        Text(labelStep[3], style: TextStyle(color: Colors.black, fontSize: 11)),
      ],
    ),
    Container(
      margin: EdgeInsetsDirectional.only(bottom: 12),
      height: 4,
      width: 32,
      decoration: BoxDecoration(
        color:
            _steps > 4 ? Color.fromRGBO(20, 126, 169, 1) : Colors.transparent,
        border: Border.all(color: Colors.black26, width: 1),
        borderRadius: BorderRadius.circular(25),
      ),
    ),

    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 15,
          backgroundColor:
              _steps >= 5 ? Color.fromRGBO(20, 126, 169, 1) : Colors.black12,
          child: Text(
            '5',
            style: TextStyle(
              color: _steps >= 5 ? Colors.white : Colors.black,
              fontSize: 11,
            ),
          ),
        ),
        Text(labelStep[4], style: TextStyle(color: Colors.black, fontSize: 11)),
      ],
    ),
  ];
}
