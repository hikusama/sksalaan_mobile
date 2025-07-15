import 'package:flutter/material.dart';
import 'package:skyouthprofiling/data/app_database.dart';
import 'package:drift/drift.dart' as drift;
import 'package:confetti/confetti.dart';
import 'package:intl/intl.dart';
import 'package:skyouthprofiling/presentation/main_screen.dart';

class Edit extends StatefulWidget {
  const Edit({super.key});

  @override
  State<Edit> createState() => _EditState();
}

class _EditState extends State<Edit> {
  late final ConfettiController confettiController = ConfettiController();
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

  int _steps = 1;
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
  final _skillsController = TextEditingController();
  final _hController = TextEditingController();
  final _wController = TextEditingController();
  final _occController = TextEditingController();
  String? civilStatsVal;
  String? religionVal;
  String? youthTypeVal;
  Map<String, dynamic> skills = {};

  final _nosController = TextEditingController();
  final _poaController = TextEditingController();
  final _ygschoolController = TextEditingController();
  String? schoolLevelVal;
  Map<String, Map<String, dynamic>> educbg = {};

  final _orgController = TextEditingController();
  final _orgaddrController = TextEditingController();
  final _ygorgController = TextEditingController();
  final _startController = TextEditingController();
  final _endedController = TextEditingController();
  Map<String, Map<String, dynamic>> civic = {};

  bool isResponse = false;
  bool success = false;
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
  // 2
  final List<String> youthType = ['OSY', 'ISY'];
  final List<String> religion = [
    'Islam',
    'Christianity',
    'Judaism',
    'Buddhism',
    'Hinduism',
    'Atheism',
    'Others',
  ];
  final List<String> civilStats = [
    'Single',
    'Married',
    'Divorce',
    'Outside-marriage',
  ];

  // 1
  final List<String> sex = ['Male', 'Female'];
  final List<String> gender = [
    'unselect',
    'Transgender',
    'Agender',
    'Bigender',
    'Non-binary',
    'Others',
  ];
  final List<String> address = [
    'Zone 1',
    'Zone 2',
    'Zone 3',
    'Zone 4',
    'Sittio Lugakit',
    'Sittio Balunu',
    'Sittio Hapa',
    'Sittio Carreon',
    'Sittio San Antonio',
  ];

  // 3
  final List<String> level = ['Elementary', 'HighSchool', 'Colllege', ''];
  void nextStep({bool isNext = true}) {
    if ((isNext && _steps > 5) || (!isNext && _steps == 1)) {
      return;
    }
    isNext ? setState(() => _steps++) : setState(() => _steps--);
  }

  @override
  void dispose() {
    _fnameController.dispose();
    _mnameController.dispose();
    _lnameController.dispose();
    _ageController.dispose();
    _dobController.dispose();
    _cnController.dispose();
    _pobController.dispose();
    _nocController.dispose();
    _skillsController.dispose();
    _hController.dispose();
    _wController.dispose();
    _occController.dispose();
    _nosController.dispose();
    _poaController.dispose();
    _ygschoolController.dispose();

    _orgController.dispose();
    _orgaddrController.dispose();
    _ygorgController.dispose();
    _endedController.dispose();

    confettiController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 60, left: 17, bottom: 20),
            // padding: EdgeInsets.only(top: 60),
            height: 20,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Row(
                children: [
                  Icon(size: 20, Icons.arrow_back, color: Colors.black),
                  SizedBox(width: 8),
                  Text(
                    'Go back..',
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  ),
                ],
              ),
            ),
          ),

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
            child:
                isResponse
                    ? contentStep[_steps.clamp(1, contentStep.length) - 1]
                    : Scrollbar(
                      thumbVisibility: true, // Optional
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child:
                              contentStep[_steps.clamp(1, contentStep.length) -
                                  1],
                        ),
                      ),
                    ),
          ),
          isResponse
              ? SizedBox.shrink()
              : Padding(
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
                      onPressed: () async {
                        if (_steps >= 3 ||
                            _formKeyForCurrentStep().currentState!.validate()) {
                          if (_steps == 5) {
                            final db = AppDatabase();
                            int youthUserID = 0;
                            bool good = false;
                            try {
                              youthUserID = await db.insertYouthUser(
                                YouthUsersCompanion(
                                  skills: drift.Value(
                                    skills.entries
                                        .map((entry) => entry.value)
                                        .toList()
                                        .join(', '),
                                  ),
                                  status: drift.Value('Standby'),
                                  youthType: drift.Value(
                                    youthTypeVal ?? 'Unknown',
                                  ),
                                ),
                              );
                              good = true;
                            } catch (e) {
                              good = false;
                            }

                            if (good) {
                              try {
                                await db.insertYouthInfo(
                                  YouthInfosCompanion(
                                    youthUserId: drift.Value(youthUserID),
                                    fname: drift.Value(
                                      _fnameController.text
                                              .toUpperCase()
                                              .characters
                                              .first +
                                          _fnameController.text
                                              .toString()
                                              .substring(1)
                                              .trim(),
                                    ),
                                    mname: drift.Value(
                                      _mnameController.text
                                              .toUpperCase()
                                              .characters
                                              .first +
                                          _mnameController.text
                                              .toString()
                                              .substring(1)
                                              .trim(),
                                    ),
                                    lname: drift.Value(
                                      _lnameController.text
                                              .toUpperCase()
                                              .characters
                                              .first +
                                          _lnameController.text
                                              .toString()
                                              .substring(1)
                                              .trim(),
                                    ),

                                    occupation: drift.Value(
                                      _occController.text.trim(),
                                    ),
                                    placeOfBirth: drift.Value(
                                      _pobController.text.trim(),
                                    ),
                                    contactNo: drift.Value(
                                      int.tryParse(_cnController.text) ?? 0,
                                    ),
                                    noOfChildren: drift.Value(
                                      int.tryParse(_nocController.text) ?? 0,
                                    ),
                                    height: drift.Value(
                                      double.tryParse(_hController.text) ?? 0,
                                    ),
                                    weight: drift.Value(
                                      double.tryParse(_wController.text) ?? 0,
                                    ),
                                    dateOfBirth: drift.Value(
                                      _dobController.text.trim(),
                                    ),
                                    age: drift.Value(
                                      int.tryParse(_ageController.text) ?? 0,
                                    ),
                                    civilStatus: drift.Value(
                                      civilStatsVal.toString().trim(),
                                    ),
                                    gender: drift.Value(genVal),
                                    religion: drift.Value(
                                      religionVal.toString().trim(),
                                    ),
                                    sex: drift.Value(sexVal.toString().trim()),
                                  ),
                                );
                                if (educbg.isNotEmpty) {
                                  await db.insertAllEducBgs(
                                    youthUserID,
                                    educbg,
                                    db,
                                  );
                                }
                                if (civic.isNotEmpty) {
                                  await db.insertAllCivic(
                                    youthUserID,
                                    civic,
                                    db,
                                  );
                                }
                                success = true;
                              } catch (e) {
                                await db.deleteYouthUser(youthUserID);
                                success = false;
                              }
                            } else {
                              success = false;
                            }
                            setState(() {
                              isResponse = true;
                            });
                            if (success) {
                              confettiController.play();
                            }
                            nextStep();
                          } else {
                            nextStep();
                          }
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
              hintText: 'Enter a first name',
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
                return 'Please enter the first name';
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
              labelText: 'Middle a Name',
              labelStyle: TextStyle(fontSize: 12),
              hintText: 'Enter Middle name',
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
                return 'Please enter the middle name';
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
              hintText: 'Enter a last name',
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
                return 'Please enter the last name';
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
                      final parts = value.split('-');
                      final year = int.parse(parts[0]);
                      final month = int.parse(parts[1]);
                      final day = int.parse(parts[2]);
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
                    final now = DateTime.now();
                    final today = DateTime(
                      now.year,
                      now.month,
                      now.day,
                    ); // normalize

                    final maxDate = DateTime(
                      today.year - 15,
                      today.month,
                      today.day,
                    );
                    final minDate = DateTime(
                      today.year - 30,
                      today.month,
                      today.day,
                    );

                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: maxDate,
                      firstDate: minDate,
                      lastDate: maxDate,
                    );

                    if (pickedDate != null) {
                      final formattedDate = DateFormat(
                        'yyyy-MM-dd',
                      ).format(pickedDate);
                      final age =
                          today.year -
                          pickedDate.year -
                          ((today.month < pickedDate.month ||
                                  (today.month == pickedDate.month &&
                                      today.day < pickedDate.day))
                              ? 1
                              : 0);

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
                  value,
                ) {
                  if (value != null) {
                    setState(() {
                      sexVal = value;
                    });
                  }
                }),
              ),
              SizedBox(width: 10),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: genVal,
                  hint: Text('Gender (optional)'),
                  decoration: InputDecoration(
                    labelStyle: TextStyle(fontSize: 12),
                    labelText: 'Select Gender',
                    border: OutlineInputBorder(),
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 10,
                    ),
                  ),
                  style: TextStyle(fontSize: 12, color: Colors.black),
                  items:
                      gender
                          .map(
                            (String value) => DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            ),
                          )
                          .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        genVal = value;
                      });
                    }
                    if (value == 'unselect') {
                      setState(() {
                        genVal = null;
                      });
                    }
                  },
                ),
              ),
            ],
          ),
          /*
          _buildDropDown(
                  genVal,
                  "Select Gender",
                  "Gender",
                  gender,
                  (value) {
                    if (value != null) {
                      setState(() {
                        genVal = value;
                      });
                    }
                  },
                ),
          */
          SizedBox(height: 10),
          _buildDropDown(addrVal, "Select Address", "Address", address, (
            value,
          ) {
            if (value != null) {
              setState(() {
                addrVal = value;
              });
            }
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
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Occupation (optional)',
              labelStyle: TextStyle(fontSize: 12),
              hintText: 'Enter a occupation',
              border: OutlineInputBorder(),
              isDense: true,
              contentPadding: EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 10,
              ),
            ),
            style: TextStyle(fontSize: 12, color: Colors.black),
            controller: _occController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return null;
              }
              if (value.length > 30) {
                return 'Use only 30 characters';
              }
              return null;
            },
          ),
          SizedBox(height: 10),

          TextFormField(
            decoration: InputDecoration(
              labelText: 'Place of Birth',
              labelStyle: TextStyle(fontSize: 12),
              hintText: 'Enter a Place of Birth',
              border: OutlineInputBorder(),
              isDense: true,
              contentPadding: EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 10,
              ),
            ),
            style: TextStyle(fontSize: 12, color: Colors.black),
            controller: _pobController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the place of birth';
              }
              if (value.length > 30) {
                return 'Use only 30 characters';
              }
              return null;
            },
          ),
          SizedBox(height: 10),

          TextFormField(
            keyboardType: TextInputType.number,
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
            controller: _cnController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the contact no.';
              }
              if (value.length != 10) {
                return 'Use correct formmat 10-Digits.';
              }
              return null;
            },
          ),
          SizedBox(height: 10),

          TextFormField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'No. of children (optional)',
              labelStyle: TextStyle(fontSize: 12),
              hintText: 'Enter the No. of children',
              border: OutlineInputBorder(),
              isDense: true,
              contentPadding: EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 10,
              ),
            ),
            style: TextStyle(fontSize: 12, color: Colors.black),
            controller: _nocController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return null; // Optional: no validation if empty
              }

              final intValue = int.tryParse(value);
              if (intValue == null) {
                return 'Enter a valid number';
              }
              if (intValue > 20) {
                return 'Max limit: 20.';
              }

              return null; // Valid input
            },
          ),
          SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Stack(
                      alignment: AlignmentDirectional.centerEnd,
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Skills',
                            labelStyle: TextStyle(fontSize: 12),
                            hintText: 'Add skills',
                            border: OutlineInputBorder(),
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 10,
                            ),
                          ),
                          style: TextStyle(fontSize: 12, color: Colors.black),
                          controller: _skillsController,
                          validator: (value) {
                            if (skills.isEmpty) {
                              return 'Please enter the skills';
                            } else {
                              if (value!.length > 30) {
                                return 'Use only 30 characters';
                              }
                            }
                            return null;
                          },
                        ),
                        Positioned(
                          child: IconButton(
                            icon: Icon(Icons.add_circle, color: Colors.blue),
                            onPressed: () {
                              final input = _skillsController.text.trim();

                              if (input.isEmpty ||
                                  input.length > 30 ||
                                  skills.containsKey(input)) {
                                return;
                              }

                              setState(() {
                                skills[input] = input;
                                _skillsController.clear();
                              });
                            },
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 5),
                    skills.isEmpty
                        ? SizedBox.shrink()
                        : Container(
                          height: skills.length > 3 ? 165 : null,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(79, 20, 127, 169),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5),
                              topRight: Radius.circular(5),
                              bottomLeft: Radius.circular(15),
                              bottomRight: Radius.circular(15),
                            ),
                            border: Border.all(
                              color: const Color.fromRGBO(20, 126, 169, 1),
                              width: 2.0,
                            ),
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children:
                                  skills.entries.map((entry) {
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(
                                            13,
                                            0,
                                            0,
                                            0,
                                          ),
                                          child: Text(
                                            entry.value,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: const Color.fromARGB(
                                                255,
                                                0,
                                                0,
                                                0,
                                              ),
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          color: Colors.red,
                                          alignment: Alignment.centerLeft,
                                          icon: Icon(
                                            Icons.delete_rounded,
                                            color: Color.fromARGB(
                                              255,
                                              142,
                                              36,
                                              36,
                                            ),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              skills.remove(entry.key);
                                            });
                                          },
                                        ),
                                      ],
                                    );
                                  }).toList(),
                            ),
                          ),
                        ),
                  ],
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Height (cm)',
                              labelStyle: TextStyle(fontSize: 12),
                              hintText: 'Height',
                              border: OutlineInputBorder(),
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 10,
                              ),
                            ),
                            style: TextStyle(fontSize: 12, color: Colors.black),
                            controller: _hController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Required';
                              }
                              if (int.parse(value) > 160) {
                                return 'max: 160cm';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Weight (kg)',
                              labelStyle: TextStyle(fontSize: 12),
                              hintText: 'Weight',
                              border: OutlineInputBorder(),
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 10,
                              ),
                            ),
                            style: TextStyle(fontSize: 12, color: Colors.black),
                            controller: _wController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Required';
                              }
                              if (int.parse(value) > 200) {
                                return 'max: 200kg';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    _buildDropDown(
                      youthTypeVal,
                      "Select Youth type",
                      "Type",
                      youthType,
                      (value) {
                        if (value != null) {
                          setState(() {
                            youthTypeVal = value;
                          });
                        }
                      },
                    ),
                    SizedBox(height: 10),

                    _buildDropDown(
                      civilStatsVal,
                      "Select Civil status",
                      "Civil status",
                      civilStats,
                      (value) {
                        if (value != null) {
                          setState(() {
                            civilStatsVal = value;
                          });
                        }
                      },
                    ),
                    SizedBox(height: 10),

                    _buildDropDown(
                      religionVal,
                      "Select Religion",
                      "Religion",
                      religion,
                      (value) {
                        if (value != null) {
                          setState(() {
                            religionVal = value;
                          });
                        }
                      },
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ),

    // 3rd step
    Form(
      key: _formKeyForCurrentStep(),
      child: Column(
        children: [
          SizedBox(
            width: 200,
            child: DropdownButtonFormField<String>(
              value: schoolLevelVal,
              hint: Text('School level'),
              decoration: InputDecoration(
                labelStyle: TextStyle(fontSize: 12),
                labelText: 'Select School level',
                border: OutlineInputBorder(),
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 10,
                ),
              ),
              style: TextStyle(fontSize: 12, color: Colors.black),
              items:
                  [
                        level[educbg.length < level.length
                            ? educbg.length
                            : level.length - 1],
                      ]
                      .map(
                        (String value) => DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        ),
                      )
                      .toList(),
              onChanged: (value) {
                if (value != null) {
                  if (value == '') {
                    schoolLevelVal = null;
                  } else {
                    setState(() {
                      schoolLevelVal = value;
                    });
                  }
                }
              },
              validator: (value) {
                if (educbg.length <= 3) {
                  if ((value == null || value.isEmpty) &&
                      (qCheck(_nosController) ||
                          qCheck(_poaController) ||
                          qCheck(_ygschoolController))) {
                    return 'Please select school level';
                  }
                }
                return null;
              },
            ),
          ),
          SizedBox(height: 10),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'School',
              labelStyle: TextStyle(fontSize: 12),
              hintText: 'Enter a name of School',
              border: OutlineInputBorder(),
              isDense: true,
              contentPadding: EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 10,
              ),
            ),
            style: TextStyle(fontSize: 12, color: Colors.black),
            controller: _nosController,
            validator: (value) {
              if (educbg.length <= 3) {
                if ((value == null || value.isEmpty) &&
                    (schoolLevelVal != null ||
                        qCheck(_poaController) ||
                        qCheck(_ygschoolController))) {
                  return 'Required';
                }
                if (value != null && value.length > 50) {
                  return 'Use only 50 characters';
                }
              }
              return null;
            },
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: TextFormField(
                  controller: _poaController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Period of Attendance',
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
                    if (educbg.length <= 3) {
                      if ((value == null || value.isEmpty) &&
                          (schoolLevelVal != null ||
                              qCheck(_nosController) ||
                              qCheck(_ygschoolController))) {
                        return 'Required';
                      }
                    }

                    return null;
                  },
                  onTap: () async {
                    DateTime today = DateTime.now();
                    DateTime maxDate = DateTime(
                      today.year,
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
                      String formattedDate = DateFormat(
                        'yyyy-MM-dd',
                      ).format(pickedDate);

                      setState(() {
                        _poaController.text = formattedDate;
                      });
                    }
                  },
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                flex: 1,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _ygschoolController,
                  decoration: InputDecoration(
                    labelText: 'Year graduate',
                    labelStyle: TextStyle(fontSize: 12),
                    hintText:
                        '${DateTime.now().year - 33} - ${DateTime.now().year}',
                    border: OutlineInputBorder(),
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 10,
                    ),
                  ),
                  style: TextStyle(fontSize: 12, color: Colors.black),
                  validator: (value) {
                    if ((value == null || value.isEmpty) &&
                        (schoolLevelVal != null ||
                            qCheck(_nosController) ||
                            qCheck(_poaController))) {
                      return 'Required';
                    }

                    final parsed = int.tryParse(value ?? '');
                    if (parsed != null) {
                      final currentYear = DateTime.now().year;
                      final minYear = currentYear - 33;

                      if (parsed < minYear) {
                        return 'Min: $minYear';
                      }
                      if (parsed > currentYear) {
                        return 'Max: $currentYear';
                      }
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 20),

          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(12, 10, 12, 12),
            child: Column(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(35, 62, 72, 1),
                  ),
                  onPressed: () {
                    if (_formKeyForCurrentStep().currentState!.validate() &&
                        (schoolLevelVal != null &&
                            qCheck(_nosController) &&
                            qCheck(_poaController) &&
                            qCheck(_ygschoolController))) {
                      final idx =
                          educbg.length < level.length
                              ? educbg.length
                              : level.length - 1;
                      setState(() {
                        educbg[level[idx]] = {
                          'level': schoolLevelVal,
                          'nameOfSchool': _nosController.text,
                          'periodOfAttendance': _poaController.text,
                          'yearGraduate': _ygschoolController.text,
                        };
                        schoolLevelVal = null;
                        _nosController.clear();
                        _poaController.clear();
                        _ygschoolController.clear();
                      });
                    } else {}
                  },
                  child: Text('Add', style: TextStyle(color: Colors.white)),
                ),
                SizedBox(height: 10),

                Container(
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(8, 32, 8, 12),

                  child: SizedBox(
                    height: 150,
                    width: 240,
                    child:
                        educbg.isEmpty
                            ? Align(
                              alignment: Alignment.center,
                              child: Text('No Educational Background'),
                            )
                            : PageView.builder(
                              scrollDirection: Axis.horizontal,

                              controller: PageController(viewportFraction: 0.9),
                              itemCount: educbg.length,
                              itemBuilder: (context, index) {
                                final entry = educbg.entries.toList()[index];
                                final key = entry.key;
                                final data = entry.value;

                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  child: Stack(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.black,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            7,
                                          ),
                                        ),
                                        padding: const EdgeInsets.all(12),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              key,
                                              style: TextStyle(fontSize: 12),
                                            ),
                                            Text(
                                              'Level',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              data['nameOfSchool'],
                                              style: TextStyle(fontSize: 12),
                                            ),
                                            Text(
                                              'School',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            ),
                                            SizedBox(height: 8),
                                            Row(
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      DateFormat(
                                                        'MMM d, yyy',
                                                      ).format(
                                                        DateTime.parse(
                                                          data['periodOfAttendance'],
                                                        ),
                                                      ),
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                    Text(
                                                      'Last attendance',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(width: 20),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      data['yearGraduate'],
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                    Text(
                                                      'Year Graduate',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),

                                      // Optional delete button
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child:
                                            educbg.length != index + 1
                                                ? SizedBox.shrink()
                                                : IconButton(
                                                  icon: Icon(
                                                    Icons.delete,
                                                    color: Colors.red,
                                                  ),
                                                  onPressed: () {
                                                    setState(() {
                                                      educbg.remove(key);
                                                    });
                                                  },
                                                ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),

    // 4rth step
    Form(
      key: _formKeyForCurrentStep(),
      child: Column(
        children: [
          SizedBox(
            width: 250,
            child: TextFormField(
              decoration: InputDecoration(
                labelText: 'Organization',
                labelStyle: TextStyle(fontSize: 12),
                hintText: 'Enter a name of Organization',
                border: OutlineInputBorder(),
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 10,
                ),
              ),
              style: TextStyle(fontSize: 12, color: Colors.black),
              controller: _orgController,
              validator: (value) {
                if ((value == null || value.isEmpty) &&
                    (qCheck(_endedController) ||
                        qCheck(_orgaddrController) ||
                        qCheck(_startController) ||
                        qCheck(_ygorgController))) {
                  return 'Required';
                }
                if (value != null && value.length > 50) {
                  return 'Use only 50 characters';
                }
                return null;
              },
            ),
          ),
          SizedBox(height: 10),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Organization address',
              labelStyle: TextStyle(fontSize: 12),
              hintText: 'Enter a Address of Organization',
              border: OutlineInputBorder(),
              isDense: true,
              contentPadding: EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 10,
              ),
            ),
            style: TextStyle(fontSize: 12, color: Colors.black),
            controller: _orgaddrController,
            validator: (value) {
              if ((value == null || value.isEmpty) &&
                  (qCheck(_orgController) ||
                      qCheck(_startController) ||
                      qCheck(_endedController) ||
                      qCheck(_ygorgController))) {
                return 'Required';
              }
              if (value != null && value.length > 50) {
                return 'Use only 50 characters';
              }
              return null;
            },
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: TextFormField(
                  controller: _startController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Started',
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
                    if (value == null ||
                        value.isEmpty &&
                            (qCheck(_orgController) ||
                                qCheck(_orgaddrController) ||
                                qCheck(_endedController) ||
                                qCheck(_ygorgController))) {
                      return 'Required';
                    }

                    return null;
                  },
                  onTap: () async {
                    DateTime today = DateTime.now();
                    DateTime maxDate = DateTime(
                      today.year,
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
                      String formattedDate = DateFormat(
                        'yyyy-MM-dd',
                      ).format(pickedDate);

                      setState(() {
                        _startController.text = formattedDate;
                      });
                    }
                  },
                ),
              ),

              SizedBox(width: 10),
              Expanded(
                flex: 1,
                child: TextFormField(
                  controller: _endedController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Ended',
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
                    if ((value == null || value.isEmpty) &&
                        (qCheck(_orgController) ||
                            qCheck(_orgaddrController) ||
                            qCheck(_startController) ||
                            qCheck(_ygorgController))) {
                      return 'Required';
                    }

                    return null;
                  },
                  onTap: () async {
                    DateTime today = DateTime.now();
                    DateTime maxDate = DateTime(
                      today.year,
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
                      String formattedDate = DateFormat(
                        'yyyy-MM-dd',
                      ).format(pickedDate);

                      setState(() {
                        _endedController.text = formattedDate;
                      });
                    }
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: 150,
              child: TextFormField(
                keyboardType: TextInputType.number,
                controller: _ygorgController,
                decoration: InputDecoration(
                  labelText: 'Year Graduated',
                  labelStyle: TextStyle(fontSize: 12),
                  hintText:
                      '${DateTime.now().year - 33} - ${DateTime.now().year}',
                  border: OutlineInputBorder(),
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 10,
                  ),
                ),
                style: TextStyle(fontSize: 12, color: Colors.black),
                validator: (value) {
                  if ((value == null || value.isEmpty) &&
                      (qCheck(_orgController) ||
                          qCheck(_orgaddrController) ||
                          qCheck(_startController) ||
                          qCheck(_endedController))) {
                    return 'Required';
                  }

                  final parsed = int.tryParse(value ?? '');
                  if (parsed != null) {
                    if (DateTime.now().year - 33 > parsed) {
                      return 'Min: ${DateTime.now().year - 33}';
                    }
                    if (DateTime.now().year < parsed) {
                      return 'Max: ${DateTime.now().year}';
                    }
                  }

                  return null;
                },
              ),
            ),
          ),
          SizedBox(height: 20),

          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(12, 10, 12, 12),
            child: Column(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(35, 62, 72, 1),
                  ),
                  onPressed: () {
                    if (_formKeyForCurrentStep().currentState!.validate() &&
                        (qCheck(_orgController) &&
                            qCheck(_orgaddrController) &&
                            qCheck(_startController) &&
                            qCheck(_ygorgController) &&
                            qCheck(_endedController))) {
                      setState(() {
                        civic[_orgController.text] = {
                          'nameOfOrganization': _orgController.text,
                          'addressOfOrganization': _orgaddrController.text,
                          'start': _startController.text,
                          'end': _endedController.text,
                          'yearGraduated': _ygorgController.text,
                        };
                        _orgController.clear();
                        _orgaddrController.clear();
                        _startController.clear();
                        _endedController.clear();
                        _ygorgController.clear();
                      });
                    }
                  },
                  child: Text('Add', style: TextStyle(color: Colors.white)),
                ),
                SizedBox(height: 10),

                Container(
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(8, 32, 8, 12),

                  child: SizedBox(
                    height: 150,
                    width: 240,
                    child:
                        civic.isEmpty
                            ? Align(
                              alignment: Alignment.center,
                              child: Text('No Civic involvement records'),
                            )
                            : PageView.builder(
                              scrollDirection: Axis.horizontal,

                              controller: PageController(viewportFraction: 0.9),
                              itemCount: civic.length,
                              itemBuilder: (context, index) {
                                final entry = civic.entries.toList()[index];
                                final key = entry.key;
                                final data = entry.value;

                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  child: Stack(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.black,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            7,
                                          ),
                                        ),
                                        padding: const EdgeInsets.all(12),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              key,
                                              style: TextStyle(fontSize: 12),
                                            ),
                                            Text(
                                              'Organization',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              data['addressOfOrganization'],
                                              style: TextStyle(fontSize: 12),
                                            ),
                                            Text(
                                              'Address',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            ),
                                            SizedBox(height: 8),
                                            Row(
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      DateFormat(
                                                        'MMM d, yyy',
                                                      ).format(
                                                        DateTime.parse(
                                                          data['start'],
                                                        ),
                                                      ),
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                    Text(
                                                      'Started',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(width: 20),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      DateFormat(
                                                        'MMM d, yyy',
                                                      ).format(
                                                        DateTime.parse(
                                                          data['end'],
                                                        ),
                                                      ),
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                    Text(
                                                      'Ended',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(width: 20),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      data['yearGraduated'],
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                    Text(
                                                      'Year Graduated',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),

                                      // Optional delete button
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child:
                                            civic.length != index + 1
                                                ? SizedBox.shrink()
                                                : IconButton(
                                                  icon: Icon(
                                                    Icons.delete,
                                                    color: Colors.red,
                                                  ),
                                                  onPressed: () {
                                                    setState(() {
                                                      civic.remove(key);
                                                    });
                                                  },
                                                ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),

    Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Finish up',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 22),

          // card 1
          Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              color: Color.fromRGBO(20, 127, 169, 0.484),
              border: Border.all(
                color: Color.fromRGBO(13, 67, 88, 1),
                width: 1.3,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(10),
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 15,
                  child: SizedBox(
                    height: 25,
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: const Color.fromARGB(141, 0, 0, 0),
                      child: Text(
                        '1',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: const Color.fromARGB(255, 81, 81, 81),
                            width: 0.8,
                          ),
                        ),
                      ),
                      padding: EdgeInsets.only(bottom: 4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,

                        children: [
                          Text(
                            _fnameController.text.isEmpty
                                ? '--'
                                : _fnameController.text,
                          ),
                          SizedBox(width: 15),
                          Text(
                            _mnameController.text.isEmpty
                                ? '--'
                                : _mnameController.text,
                          ),
                          SizedBox(width: 15),
                          Text(
                            _lnameController.text.isEmpty
                                ? '--'
                                : _lnameController.text,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Name",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: const Color.fromARGB(
                                      255,
                                      81,
                                      81,
                                      81,
                                    ),
                                    width: 0.8,
                                  ),
                                ),
                              ),
                              padding: EdgeInsets.only(bottom: 4),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    _dobController.text.isEmpty
                                        ? '--'
                                        : DateFormat('MMMM d, yyy').format(
                                          DateTime.parse(_dobController.text),
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 4),

                            Text(
                              "Date of Birth",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 20),

                        Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: const Color.fromARGB(
                                      255,
                                      81,
                                      81,
                                      81,
                                    ),
                                    width: 0.8,
                                  ),
                                ),
                              ),
                              padding: EdgeInsets.only(bottom: 4),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    _ageController.text.isEmpty
                                        ? '--'
                                        : _ageController.text,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Age",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 20),
                        Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: const Color.fromARGB(
                                      255,
                                      81,
                                      81,
                                      81,
                                    ),
                                    width: 0.8,
                                  ),
                                ),
                              ),
                              padding: EdgeInsets.only(bottom: 4),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    sexVal == null ? '--' : sexVal.toString(),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Sex",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 20),
                        Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: const Color.fromARGB(
                                      255,
                                      81,
                                      81,
                                      81,
                                    ),
                                    width: 0.8,
                                  ),
                                ),
                              ),
                              padding: EdgeInsets.only(bottom: 4),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    genVal == null ? '--' : genVal.toString(),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Gender",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: const Color.fromARGB(255, 81, 81, 81),
                            width: 0.8,
                          ),
                        ),
                      ),
                      padding: EdgeInsets.only(bottom: 4),
                      child: Text(addrVal == null ? '--' : addrVal.toString()),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Address",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 10),

          // card 2
          Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              color: Color.fromRGBO(20, 127, 169, 0.484),
              border: Border.all(
                color: Color.fromRGBO(13, 67, 88, 1),
                width: 1.3,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(10),
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 15,
                  child: SizedBox(
                    height: 25,
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: const Color.fromARGB(141, 0, 0, 0),
                      child: Text(
                        '2',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: const Color.fromARGB(255, 81, 81, 81),
                            width: 0.8,
                          ),
                        ),
                      ),
                      padding: EdgeInsets.only(bottom: 4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,

                        children: [
                          Text(
                            youthTypeVal == null
                                ? '--'
                                : youthTypeVal.toString(),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Type",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: const Color.fromARGB(
                                      255,
                                      81,
                                      81,
                                      81,
                                    ),
                                    width: 0.8,
                                  ),
                                ),
                              ),
                              padding: EdgeInsets.only(bottom: 4),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    _pobController.text.isEmpty
                                        ? '--'
                                        : _pobController.text,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 4),

                            Text(
                              "Place of Birth",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 20),

                        Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: const Color.fromARGB(
                                      255,
                                      81,
                                      81,
                                      81,
                                    ),
                                    width: 0.8,
                                  ),
                                ),
                              ),
                              padding: EdgeInsets.only(bottom: 4),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    _occController.text.isEmpty
                                        ? '--'
                                        : _occController.text,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Occupation",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: const Color.fromARGB(
                                      255,
                                      81,
                                      81,
                                      81,
                                    ),
                                    width: 0.8,
                                  ),
                                ),
                              ),
                              padding: EdgeInsets.only(bottom: 4),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    _hController.text.isEmpty
                                        ? '--'
                                        : '${_hController.text}cm',
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 4),

                            Text(
                              "Height",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 20),

                        Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: const Color.fromARGB(
                                      255,
                                      81,
                                      81,
                                      81,
                                    ),
                                    width: 0.8,
                                  ),
                                ),
                              ),
                              padding: EdgeInsets.only(bottom: 4),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    _wController.text.isEmpty
                                        ? '--'
                                        : '${_wController.text}kg',
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Weight",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 20),
                        Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: const Color.fromARGB(
                                      255,
                                      81,
                                      81,
                                      81,
                                    ),
                                    width: 0.8,
                                  ),
                                ),
                              ),
                              padding: EdgeInsets.only(bottom: 4),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    _nocController.text.isEmpty
                                        ? '--'
                                        : _nocController.text,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Children",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 20),
                        Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: const Color.fromARGB(
                                      255,
                                      81,
                                      81,
                                      81,
                                    ),
                                    width: 0.8,
                                  ),
                                ),
                              ),
                              padding: EdgeInsets.only(bottom: 4),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    civilStatsVal == null
                                        ? '--'
                                        : civilStatsVal.toString(),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Civil status",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: const Color.fromARGB(
                                      255,
                                      81,
                                      81,
                                      81,
                                    ),
                                    width: 0.8,
                                  ),
                                ),
                              ),
                              padding: EdgeInsets.only(bottom: 4),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    religionVal == null
                                        ? '--'
                                        : religionVal.toString(),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 4),

                            Text(
                              "Religion",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 20),

                        Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: const Color.fromARGB(
                                      255,
                                      81,
                                      81,
                                      81,
                                    ),
                                    width: 0.8,
                                  ),
                                ),
                              ),
                              padding: EdgeInsets.only(bottom: 4),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    _cnController.text.isEmpty
                                        ? '--'
                                        : '0${_cnController.text}',
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Contact no",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: const Color.fromARGB(255, 81, 81, 81),
                            width: 0.8,
                          ),
                        ),
                      ),
                      padding: EdgeInsets.only(bottom: 4),
                      child: Text(
                        skills.isEmpty
                            ? '--'
                            : skills.entries
                                .map((entry) => entry.value)
                                .join(', '),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Skills",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 10),

          // card 3
          Container(
            width: double.infinity,
            height: educbg.isEmpty || educbg.length <= 1 ? 210 : null,
            padding: EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Color.fromRGBO(20, 127, 169, 0.484),
              border: Border.all(
                color: Color.fromRGBO(13, 67, 88, 1),
                width: 1.3,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(10),
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 10,
                  left: 15,
                  child: SizedBox(
                    height: 25,
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: const Color.fromARGB(141, 0, 0, 0),
                      child: Text(
                        '3',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),

                Container(
                  padding: EdgeInsets.fromLTRB(20, 40, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children:
                        educbg.isEmpty
                            ? [
                              Align(
                                alignment: Alignment.center,
                                child: Text('No educational Background set.'),
                              ),
                            ]
                            : educbg.entries.map((entry) {
                              return Container(
                                padding: EdgeInsets.only(bottom: 5),
                                margin: EdgeInsets.only(bottom: 20),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: const Color.fromARGB(144, 0, 0, 0),
                                      width: 1.4,
                                    ),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  border: Border(
                                                    bottom: BorderSide(
                                                      color:
                                                          const Color.fromARGB(
                                                            255,
                                                            81,
                                                            81,
                                                            81,
                                                          ),
                                                      width: 0.8,
                                                    ),
                                                  ),
                                                ),
                                                padding: EdgeInsets.only(
                                                  bottom: 4,
                                                ),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(entry.value['level']),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: 2),
                                              Text(
                                                "Level",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 113,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  border: Border(
                                                    bottom: BorderSide(
                                                      color:
                                                          const Color.fromARGB(
                                                            255,
                                                            81,
                                                            81,
                                                            81,
                                                          ),
                                                      width: 0.8,
                                                    ),
                                                  ),
                                                ),
                                                padding: EdgeInsets.only(
                                                  bottom: 4,
                                                ),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      DateFormat(
                                                        'MMM d, yyy',
                                                      ).format(
                                                        DateTime.parse(
                                                          entry
                                                              .value['periodOfAttendance'],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: 2),
                                              Text(
                                                "Period of Attendance",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  border: Border(
                                                    bottom: BorderSide(
                                                      color:
                                                          const Color.fromARGB(
                                                            255,
                                                            81,
                                                            81,
                                                            81,
                                                          ),
                                                      width: 0.8,
                                                    ),
                                                  ),
                                                ),
                                                padding: EdgeInsets.only(
                                                  bottom: 4,
                                                ),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      entry
                                                          .value['nameOfSchool'],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                "School",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 113,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  border: Border(
                                                    bottom: BorderSide(
                                                      color:
                                                          const Color.fromARGB(
                                                            255,
                                                            81,
                                                            81,
                                                            81,
                                                          ),
                                                      width: 0.8,
                                                    ),
                                                  ),
                                                ),
                                                padding: EdgeInsets.only(
                                                  bottom: 4,
                                                ),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      entry
                                                          .value['yearGraduate'],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                "Year Graduate",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),

          // card 4
          Container(
            width: double.infinity,
            height: educbg.isEmpty || educbg.length <= 1 ? 237 : null,
            padding: EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Color.fromRGBO(20, 127, 169, 0.484),
              border: Border.all(
                color: Color.fromRGBO(13, 67, 88, 1),
                width: 1.3,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(10),
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 10,
                  left: 15,
                  child: SizedBox(
                    height: 25,
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: const Color.fromARGB(141, 0, 0, 0),
                      child: Text(
                        '4',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),

                Container(
                  padding: EdgeInsets.fromLTRB(
                    20,
                    40,
                    20,
                    civic.length <= 1 ? 15 : 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children:
                        civic.isEmpty
                            ? [
                              Align(
                                alignment: Alignment.center,
                                child: Text('No Civic Involvement set.'),
                              ),
                            ]
                            : civic.entries.map((entry) {
                              return Container(
                                padding: EdgeInsets.only(bottom: 5),
                                margin: EdgeInsets.only(bottom: 20),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: const Color.fromARGB(144, 0, 0, 0),
                                      width: 1.4,
                                    ),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  border: Border(
                                                    bottom: BorderSide(
                                                      color:
                                                          const Color.fromARGB(
                                                            255,
                                                            81,
                                                            81,
                                                            81,
                                                          ),
                                                      width: 0.8,
                                                    ),
                                                  ),
                                                ),
                                                padding: EdgeInsets.only(
                                                  bottom: 4,
                                                ),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      entry
                                                          .value['nameOfOrganization'],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: 2),
                                              Text(
                                                "Organization",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 113,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  border: Border(
                                                    bottom: BorderSide(
                                                      color:
                                                          const Color.fromARGB(
                                                            255,
                                                            81,
                                                            81,
                                                            81,
                                                          ),
                                                      width: 0.8,
                                                    ),
                                                  ),
                                                ),
                                                padding: EdgeInsets.only(
                                                  bottom: 4,
                                                ),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      DateFormat(
                                                        'MMM d, yyy',
                                                      ).format(
                                                        DateTime.parse(
                                                          entry.value['start'],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: 2),
                                              Text(
                                                "Started",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  border: Border(
                                                    bottom: BorderSide(
                                                      color:
                                                          const Color.fromARGB(
                                                            255,
                                                            81,
                                                            81,
                                                            81,
                                                          ),
                                                      width: 0.8,
                                                    ),
                                                  ),
                                                ),
                                                padding: EdgeInsets.only(
                                                  bottom: 4,
                                                ),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      entry
                                                          .value['addressOfOrganization'],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                "Address",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 113,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  border: Border(
                                                    bottom: BorderSide(
                                                      color:
                                                          const Color.fromARGB(
                                                            255,
                                                            81,
                                                            81,
                                                            81,
                                                          ),
                                                      width: 0.8,
                                                    ),
                                                  ),
                                                ),
                                                padding: EdgeInsets.only(
                                                  bottom: 4,
                                                ),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      DateFormat(
                                                        'MMM d, yyy',
                                                      ).format(
                                                        DateTime.parse(
                                                          entry.value['end'],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                "Ended",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,

                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                border: Border(
                                                  bottom: BorderSide(
                                                    color: const Color.fromARGB(
                                                      255,
                                                      81,
                                                      81,
                                                      81,
                                                    ),
                                                    width: 0.8,
                                                  ),
                                                ),
                                              ),
                                              padding: EdgeInsets.only(
                                                bottom: 4,
                                              ),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    entry
                                                        .value['yearGraduated'],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              "Year Graduated",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),

    Stack(
      alignment: Alignment.topCenter,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  SizedBox(
                    height: 190,
                    child:
                        success
                            ? Image.asset('assets/images/success.png')
                            : Image.asset('assets/images/failed.png'),
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 8,
                        backgroundColor: success ? Colors.green : Colors.red,
                        child: Icon(
                          size: 15,
                          success ? Icons.check : Icons.close,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 4),
                      success
                          ? Text(
                            'Success....',
                            style: TextStyle(color: Colors.black, fontSize: 18),
                          )
                          : Text(
                            'Something went wrong',
                            style: TextStyle(color: Colors.black, fontSize: 18),
                          ),
                    ],
                  ),
                  SizedBox(height: 8),

                  MaterialButton(
                    minWidth: 80,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MainScreen(),
                        ),
                      );
                    },
                    color: Color.fromRGBO(20, 126, 169, 1),
                    child: Text('Done', style: TextStyle(color: Colors.white)),
                  ),
                  SizedBox(height: 150),
                ],
              ),
            ),
          ],
        ),

        Positioned(
          top: 10,
          child: ConfettiWidget(
            numberOfParticles: 15,
            confettiController: confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            colors: const [
              Colors.red,
              Colors.blue,
              Colors.green,
              Colors.orange,
              Colors.purple,
            ],
            gravity: 0.3,
          ),
        ),
      ],
    ),
  ];

  bool qCheck(TextEditingController controller) {
    return controller.text.trim().isNotEmpty;
  }
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
