import 'package:flutter/material.dart';
// import 'package:skyouthprofiling/service/database_helper.dart';

class InsertYouth extends StatefulWidget {
  const InsertYouth({super.key});

  @override
  State<InsertYouth> createState() => _InsertYouthState();
}

class _InsertYouthState extends State<InsertYouth> {
  int currStep = 0;
  bool get isFirstStep => currStep == 0;
  bool get isLastStep => currStep == steps().length - 1;
  // final DatabaseService _databaseService = DatabaseService.instance;

  final name = TextEditingController();
  final company = TextEditingController();
  final role = TextEditingController();

  final fname = TextEditingController();
  final mname = TextEditingController();
  final lname = TextEditingController();
  final age = TextEditingController();
  final sex = TextEditingController();
  final gender = TextEditingController();

  /*
  IntColumn get userId => integer().nullable()();  
  TextColumn get youthType => text()();
  TextColumn get batchNo => text()();
  TextColumn get skills => text()();
  TextColumn get status => text()();

    TextColumn get fname => text()();
  TextColumn get mname => text()();
  TextColumn get lname => text()();
  IntColumn get age => integer()();
  TextColumn get gender => text()();
  TextColumn get sex => text()();
  TextColumn get dateOfBirth => text()();
 */
  Map<String, bool> firstHasError = {'name': false, 'age': false};
  Map<String, bool> secondHasError = {'company': false};
  Map<String, bool> thirdHasError = {'role': false};

  Map<String, dynamic> infoData = {};

  bool check(Map<String, bool> hasError) {
    // for (int i = 0; i < hasError.length; i++) {
    //   if (!hasError[i]) {

    //   }
    // }
    return true;
  }

  bool isComplete = false;

  void valFirstSection() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text('Inserting Youth')),
    body:
        isComplete
            ? _bildSuccess(context)
            : Scrollbar(
              child: Stepper(
                steps: steps(),
                type: StepperType.horizontal,
                currentStep: currStep,
                onStepContinue: () {
                  if (isLastStep) {
                    // _databaseService.addYouth(infoData);
                    setState(() {
                      isComplete = true;
                    });
                  } else {
                    setState(() {
                      currStep += 1;
                    });
                  }
                },
                stepIconHeight: 25,
                stepIconWidth: 25,
                onStepCancel:
                    isFirstStep ? null : () => setState(() => currStep -= 1),
                onStepTapped: (step) => setState(() => currStep = step),
                controlsBuilder:
                    (context, details) => Padding(
                      padding: const EdgeInsets.only(top: 32),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: details.onStepContinue,
                              child: Text(isLastStep ? 'Confirm' : 'Next'),
                              // isLastStep ? 'Confirm' : 'Next'),
                            ),
                          ),
                          if (!isFirstStep) ...[
                            const SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton(
                                onPressed:
                                    isFirstStep ? null : details.onStepCancel,
                                child: const Text('Back'),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
              ),
            ),
  );

  List<Step> steps() => [
    Step(
      state: currStep > 0 ? StepState.complete : StepState.indexed,

      // state: StepState.,
      isActive: currStep >= 0,
      title: Text('Basic'),

      content: Column(
        children: [
          TextFormField(
            controller: name,
            decoration: const InputDecoration(
              labelText: 'Name',
              errorText: "Please fill this field",
            ),
            onChanged: (value) {
              infoData['name'] = value;
            },
          ),
          TextFormField(
            controller: age,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Age'),
            onChanged: (value) {
              infoData['age'] = value;
            },
          ),
        ],
      ),
    ),
    Step(
      state: currStep > 1 ? StepState.complete : StepState.indexed,
      isActive: currStep >= 1,
      title: Text('Personal'),
      content: Column(
        children: [
          TextFormField(
            controller: company,
            decoration: const InputDecoration(labelText: 'Company'),
            onChanged: (value) {
              infoData['company'] = value;
            },
          ),
        ],
      ),
    ),
    Step(
      state: currStep > 1 ? StepState.complete : StepState.indexed,
      isActive: currStep >= 2,
      title: Text('Others'),
      content: Column(
        children: [
          TextFormField(
            controller: role,
            decoration: const InputDecoration(labelText: 'Role'),
            onChanged: (value) {
              infoData['role'] = value;
            },
          ),
        ],
      ),
    ),
    Step(
      isActive: currStep >= 3,
      title: Text('Finish up'),
      content: Column(children: [Scrollbar(child: Text("hello"))]),
    ),
  ];

  Widget _bildSuccess(context) {
    setState(() {
      isComplete = false;
    });
    return SizedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(size: 40, Icons.check_circle_outlined, color: Colors.green),
              Text(
                'Youth Successfully Added...',
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
          InkWell(
            onTap: () => {Navigator.pop(context)},

            child: Padding(
              padding: EdgeInsets.fromLTRB(8, 4, 8, 4),

              child: Text(
                'Done',
                style: TextStyle(backgroundColor: Colors.blue),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
