import 'package:flutter/material.dart';
import 'package:skyouthprofiling/data/app_database.dart';
import 'package:confetti/confetti.dart';
import 'package:intl/intl.dart';
import 'package:skyouthprofiling/presentation/main_screen.dart';

class More extends StatefulWidget {
  final FullYouthProfile profiles;

  const More({super.key, required this.profiles});
  @override
  State<More> createState() => _MoreState();
}

class _MoreState extends State<More> {
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

  @override
  void initState() {
    super.initState();
    _loadYouth(widget.profiles);
  }

  void _loadYouth(FullYouthProfile profiles) {
    //
    YouthUser yu = profiles.youthUser;
    YouthInfo yi = profiles.youthInfo;
    List<EducBg> edu = profiles.educBgs;
    List<CivicInvolvement> cv = profiles.civicInvolvements;
    _fnameController.text = yi.fname;
    _mnameController.text = yi.mname;
    _lnameController.text = yi.lname;
    _dobController.text = yi.dateOfBirth;
    _ageController.text = yi.age.toString();
    sexVal = yi.sex;
    genVal = yi.gender;
    civilStatsVal = yi.civilStatus;
    addrVal = yi.address;

    _skillsController.text = 'Read only';
    _occController.text = yi.occupation == "" ? 'unset' : yi.occupation;
    _pobController.text = yi.placeOfBirth;
    _cnController.text = yi.contactNo;
    _nocController.text = yi.noOfChildren.toString();
    _hController.text = yi.height != null ? yi.height.toString() : 'unset';
    _wController.text = yi.weight != null ? yi.height.toString() : 'unset';
    youthTypeVal = yi.civilStatus;
    religionVal = yi.religion;
    youthTypeVal = yu.youthType;
    skills = {for (var s in yu.skills.split(',')) s.trim(): s.trim()};

    for (int i = 0; i < edu.length && i < level.length; i++) {
      final e = edu[i];

      if (e.yearGraduate == null || e.yearGraduate!.isEmpty) {
        lastyr = true;
      }

      educbg[level[i]] = {
        'level': e.level,
        'nameOfSchool': e.nameOfSchool,
        'periodOfAttendance': e.periodOfAttendance,
        'yearGraduate': e.yearGraduate,
      };
    }

    for (var c in cv) {
      civic[c.nameOfOrganization] = {
        'nameOfOrganization': c.nameOfOrganization,
        'addressOfOrganization': c.addressOfOrganization,
        'start': c.start,
        'end': c.end,
        'yearGraduated': c.yearGraduated,
      };
    }
    if (!lastyr) {
      schoolLevelVal = 'Read only';
    }
    _nosController.text = 'Read only';
    _poaController.text = 'Read only';
    _ygschoolController.text = 'Read only';

    _ygorgController.text = 'Read only';
    _orgController.text = 'Read only';
    _orgaddrController.text = 'Read only';
    _startController.text = 'Read only';
    _endedController.text = 'Read only';
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
  bool lastyr = false;
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
  final List<String> gender = ['unselect', 'Binary', 'Non-binary', 'Others'];
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
              Icon(size: 25, Icons.verified_user),
              Text(
                'Full Youth Information',
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
                      thumbVisibility: true,
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
              : Container(
                margin: EdgeInsets.only(bottom: 45),
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
                        backgroundColor: Color.fromRGBO(20, 169, 162, 1),
                      ),
                      onPressed: () async {
                        if (_steps >= 3 ||
                            _formKeyForCurrentStep().currentState!.validate()) {
                          if (_steps == 5) {
                            Navigator.pop(context);
                          } else {
                            nextStep();
                          }
                        }
                      },
                      child: Text(
                        _steps == 5 ? 'Exit' : 'Next',
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
            readOnly: true,
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
              return null;
            },
          ),

          SizedBox(height: 10),
          TextFormField(
            readOnly: true,
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
              return null;
            },
          ),

          SizedBox(height: 10),
          TextFormField(
            readOnly: true,
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
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(_ageController.text, style: TextStyle(fontSize: 17)),
                    Text(
                      'Age',
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
                  hint: Text(genVal ?? 'unset'),
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
                  items: [],
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
            readOnly: true,
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
              return null;
            },
          ),
          SizedBox(height: 10),

          TextFormField(
            readOnly: true,
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
              return null;
            },
          ),
          SizedBox(height: 10),

          TextFormField(
            readOnly: true,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Contact no.',
              labelStyle: TextStyle(fontSize: 12),
              hintText: '09554433221',
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
              return null;
            },
          ),
          SizedBox(height: 10),

          TextFormField(
            readOnly: true,
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
              return null;
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
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: 'Skills',
                            labelStyle: TextStyle(fontSize: 12),
                            hintText: 'Read only',
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
                            return null;
                          },
                        ),
                        Positioned(
                          child: IconButton(
                            icon: Icon(
                              Icons.add_circle,
                              color: const Color.fromARGB(103, 33, 149, 243),
                            ),
                            onPressed: () {},
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
                                          color: const Color.fromARGB(
                                            93,
                                            244,
                                            67,
                                            54,
                                          ),
                                          alignment: Alignment.centerLeft,
                                          icon: Icon(
                                            Icons.delete_rounded,
                                            color: Color.fromARGB(
                                              103,
                                              142,
                                              36,
                                              36,
                                            ),
                                          ),
                                          onPressed: () {},
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
                            readOnly: true,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Height (cm)',
                              labelStyle: TextStyle(fontSize: 12),
                              hintText: '(optional)',
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
                              return null;
                            },
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            readOnly: true,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Weight (kg)',
                              labelStyle: TextStyle(fontSize: 12),
                              hintText: '(optional)',
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
              hint: Text(
                lastyr || educbg.length == 3
                    ? 'Nothing follows!!'
                    : 'Read only',
              ),
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
                  lastyr || educbg.length == 3
                      ? []
                      : [
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
                return null;
              },
            ),
          ),
          SizedBox(height: 10),
          TextFormField(
            readOnly: true,
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
                    return null;
                  },
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                flex: 1,
                child: TextFormField(
                  readOnly: true,
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
                    backgroundColor: Color.fromRGBO(35, 62, 72, 0.458),
                  ),
                  onPressed: () {},
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
                                                      data['yearGraduate'] ??
                                                          '',
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
              readOnly: true,
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
                return null;
              },
            ),
          ),
          SizedBox(height: 10),
          TextFormField(
            readOnly: true,
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
                    return null;
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
                    return null;
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
                readOnly: true,
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
                    backgroundColor: Color.fromRGBO(35, 62, 72, 0.458),
                  ),
                  onPressed: () {},
                  child: Text('Add', style: TextStyle(color: Colors.white)),
                ),
                SizedBox(height: 10),

                Container(
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(0, 32, 0, 12),

                  child: SizedBox(
                    height: 150,
                    width: 260,
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
                          Text("${_lnameController.text.trim()}, "),
                          Text(_fnameController.text.trim()),
                          Text(" - ${_mnameController.text.trim()}."),
                        ],
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Name (l,f-m)",
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
                                        ? ''
                                        : DateFormat('MMMM d, yyyy').format(
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
                                children: [Text(_ageController.text)],
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
                                children: [Text(sexVal.toString())],
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
                                    genVal == null
                                        ? 'unset'
                                        : genVal.toString(),
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
                      child: Text(addrVal.toString()),
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

                        children: [Text(youthTypeVal.toString())],
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
                                children: [Text(_pobController.text)],
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
                                        ? 'unset'
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
                                        ? 'unset'
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
                                        ? 'unset'
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
                                        ? '0'
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
                                children: [Text(civilStatsVal.toString())],
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
                                children: [Text(religionVal.toString())],
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
                                children: [Text(_cnController.text)],
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
                        skills.entries.map((entry) => entry.value).join(', '),
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
                  padding: EdgeInsets.fromLTRB(20, 40, 20, 10),
                  child: Wrap(
                    runSpacing: 45,
                    children:
                        educbg.isEmpty
                            ? [
                              Align(
                                alignment: Alignment.center,
                                child: Text('No educational Background set.'),
                              ),
                            ]
                            : educbg.entries.map((entry) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,

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
                                        width: 130,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
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
                                              softWrap: false,
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
                                                    entry.value['nameOfSchool'],
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
                                                    entry.value['yearGraduate'] ==
                                                            null
                                                        ? entry
                                                            .value['yearGraduate']
                                                        : "unfinished",
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
            padding: EdgeInsets.only(top: 10, bottom: 0),
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
                  padding: EdgeInsets.fromLTRB(20, 40, 20, 20),
                  child: Wrap(
                    runSpacing: 45,
                    children:
                        civic.isEmpty
                            ? [
                              Align(
                                alignment: Alignment.center,
                                child: Text('No Civic Involvement set.'),
                              ),
                            ]
                            : civic.entries.map((entry) {
                              return Column(
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
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
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
                                    mainAxisAlignment: MainAxisAlignment.center,

                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 100,
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
                                                  entry.value['yearGraduated'],
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
      hint: Text(currentVal.toString()),
      decoration: InputDecoration(
        labelStyle: TextStyle(fontSize: 12),
        labelText: label,
        border: OutlineInputBorder(),
        isDense: true,
        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      ),
      style: TextStyle(fontSize: 12, color: Colors.black),

      items: [],
      onChanged: onChanged,
      validator: (value) {
        return null;
      },
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
              _steps >= 1 ? Color.fromRGBO(20, 169, 162, 1) : Colors.black12,
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
            _steps > 1 ? Color.fromRGBO(20, 169, 162, 1) : Colors.transparent,
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
              _steps >= 2 ? Color.fromRGBO(20, 169, 162, 1) : Colors.black12,
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
            _steps > 2 ? Color.fromRGBO(20, 169, 162, 1) : Colors.transparent,
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
              _steps >= 3 ? Color.fromRGBO(20, 169, 162, 1) : Colors.black12,
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
            _steps > 3 ? Color.fromRGBO(20, 169, 162, 1) : Colors.transparent,
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
              _steps >= 4 ? Color.fromRGBO(20, 169, 162, 1) : Colors.black12,
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
            _steps > 4 ? Color.fromRGBO(20, 169, 162, 1) : Colors.transparent,
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
              _steps >= 5 ? Color.fromRGBO(20, 169, 162, 1) : Colors.black12,
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
