import 'package:demo_app/models/customer.models.dart';
import 'package:demo_app/styles/allDialog.dart';
import 'package:demo_app/styles/theme.color.dart';
import 'package:demo_app/view.models/customer.view.model.dart';
import 'package:demo_app/views/customer.view/customer.view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

class AddCustomerView extends StatefulWidget {
  const AddCustomerView({super.key});

  @override
  State<AddCustomerView> createState() => _AddCustomerViewState();
}

class _AddCustomerViewState extends State<AddCustomerView> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Add Customer')),
        body: const Center(
          child: StepperExample(),
        ),
      ),
    );
  }
}

class StepperExample extends StatefulWidget {
  const StepperExample({super.key});

  @override
  State<StepperExample> createState() => _StepperExampleState();
}

class _StepperExampleState extends State<StepperExample> {
  int _index = 0;
  double widthScreen = 0;
  FocusNode cIdNode = FocusNode();
  FocusNode cFirstNameNode = FocusNode();
  FocusNode cLastNameNode = FocusNode();
  FocusNode cAddressNode = FocusNode();
  FocusNode cTellNode = FocusNode();

  TextEditingController cIdController = TextEditingController();
  TextEditingController cFirstNameController = TextEditingController();
  TextEditingController cLastNameController = TextEditingController();
  TextEditingController cAddressController = TextEditingController();
  String cDistrictController = "";
  String cSubDistrictController = "";
  String cProvinceController = "";
  String cPostCodeController = "10110";
  TextEditingController cTellController = TextEditingController();
  List<DropdownMenuItem> provinceList = [
    DropdownMenuItem(
      value: "",
      child: Text(
        "Please choose a province",
        style: TextStyle(color: ThemeColorApp().placeholder),
      ),
    ),
    const DropdownMenuItem(
      value: "กรุงเทพมหานคร",
      child: Text("กรุงเทพมหานคร"),
    ),
    const DropdownMenuItem(
      value: "พะเยา",
      child: Text("พะเยา"),
    ),
  ];

  List<DropdownMenuItem> districtList = [
    DropdownMenuItem(
      value: "",
      child: Text(
        "Please choose a district",
        style: TextStyle(color: ThemeColorApp().placeholder),
      ),
    ),
  ];

  List<DropdownMenuItem> subDistrictList = [
    DropdownMenuItem(
      value: "",
      child: Text(
        "Please choose a subdistrict",
        style: TextStyle(color: ThemeColorApp().placeholder),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    widthScreen = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Stepper(
            currentStep: _index,
            onStepCancel: () {
              if (_index > 0) {
                setState(() {
                  _index -= 1;
                });
              }
            },
            onStepContinue: () {
              switch (_index) {
                case 0:
                  {
                    if ((cIdController.text.length < 13) ||
                        (cIdController.text == "") ||
                        (cFirstNameController.text == "") ||
                        (cLastNameController.text == "")) {
                      Tdialog.errorDialog(
                        context,
                        'Please enter Information.',
                        () {
                          Navigator.of(context, rootNavigator: true).pop("Ok");
                        },
                      );
                    } else {
                      if (_index <= 0) {
                        setState(() {
                          _index += 1;
                        });
                      }
                    }
                  }
                  break;
                case 1:
                  {
                    if ((cAddressController.text == "") ||
                        (cDistrictController == "") ||
                        (cSubDistrictController == "") ||
                        (cProvinceController == "") ||
                        (cPostCodeController == "")) {
                      Tdialog.errorDialog(
                        context,
                        'Please enter address.',
                        () {
                          Navigator.of(context, rootNavigator: true).pop("Ok");
                        },
                      );
                    } else {
                      final viewModel = Provider.of<CustomerViewModel>(context,
                          listen: false);
                      CustomerDataModel req = CustomerDataModel(
                          cId: cIdController.text,
                          cFirstName: cFirstNameController.text,
                          cLastName: cLastNameController.text,
                          cAddress: cAddressController.text,
                          cDistrict: cDistrictController,
                          cSubDistrict: cSubDistrictController,
                          cProvince: cProvinceController,
                          cPostCode: cPostCodeController,
                          cTell: cTellController.text);
                      bool validateCustomer = viewModel.validateCustomer(req);
                      if (validateCustomer == true) {
                        Tdialog.errorDialog(
                          context,
                          'Identification number is already.',
                          () {
                            Navigator.of(context, rootNavigator: true)
                                .pop("Ok");
                          },
                        );
                      } else {
                        viewModel.addCustomer(req);
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => const CustomerView()),
                            (Route<dynamic> route) => false);
                      }
                    }
                  }
                  break;
              }
            },
            // onStepTapped: (int index) {
            //   setState(() {
            //     _index = index;
            //   });
            // },
            steps: <Step>[
              Step(
                title: const Text('Information'),
                content: Container(
                  alignment: Alignment.centerLeft,
                  child: informationForm(),
                ),
              ),
              Step(
                  title: const Text('Address'),
                  content: Container(
                    alignment: Alignment.centerLeft,
                    child: addressForm(),
                  )),
            ],
          ),
        ],
      ),
    );
  }

  Widget informationForm() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: widthScreen * 0.8,
            height: 48,
            child: Center(
              child: TextFormField(
                focusNode: cIdNode,
                cursorColor: ThemeColorApp().primaryColor,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(13),
                ],
                keyboardType: TextInputType.number,
                controller: cIdController,
                style: TextStyle(
                  fontSize: 14.0,
                  color: ThemeColorApp().secondaryColor,
                ),
                decoration: InputDecoration(
                  hintText: "Identification Number 13 digit",
                  hintStyle: TextStyle(
                    color: ThemeColorApp().placeholder,
                    fontSize: 14.0,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    cIdController.text = value;
                    cIdController.selection = TextSelection.fromPosition(
                        TextPosition(offset: cIdController.text.length));
                  });
                },
                onFieldSubmitted: (value) {
                  setState(() {
                    cIdController.text = value;
                  });
                  FocusScope.of(context).requestFocus(cFirstNameNode);
                },
              ),
            ),
          ),
          Container(
            width: widthScreen * 0.8,
            height: 48,
            child: Center(
              child: TextFormField(
                focusNode: cFirstNameNode,
                cursorColor: ThemeColorApp().primaryColor,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(13),
                ],
                keyboardType: TextInputType.text,
                controller: cFirstNameController,
                style: TextStyle(
                  fontSize: 14.0,
                  color: ThemeColorApp().secondaryColor,
                ),
                decoration: InputDecoration(
                  hintText: "First Name",
                  hintStyle: TextStyle(
                    color: ThemeColorApp().placeholder,
                    fontSize: 14.0,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    cFirstNameController.text = value;
                    cFirstNameController.selection = TextSelection.fromPosition(
                        TextPosition(offset: cFirstNameController.text.length));
                  });
                },
                onFieldSubmitted: (value) {
                  setState(() {
                    cFirstNameController.text = value;
                  });
                  FocusScope.of(context).requestFocus(cLastNameNode);
                },
              ),
            ),
          ),
          Container(
            width: widthScreen * 0.8,
            height: 48,
            child: Center(
              child: TextFormField(
                focusNode: cLastNameNode,
                cursorColor: ThemeColorApp().primaryColor,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(13),
                ],
                keyboardType: TextInputType.text,
                controller: cLastNameController,
                style: TextStyle(
                  fontSize: 14.0,
                  color: ThemeColorApp().secondaryColor,
                ),
                decoration: InputDecoration(
                  hintText: "Last Name",
                  hintStyle: TextStyle(
                    color: ThemeColorApp().placeholder,
                    fontSize: 14.0,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    cLastNameController.text = value;
                    cLastNameController.selection = TextSelection.fromPosition(
                        TextPosition(offset: cLastNameController.text.length));
                  });
                },
                onFieldSubmitted: (value) {
                  setState(() {
                    cLastNameController.text = value;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget addressForm() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: widthScreen * 0.8,
            height: 48,
            child: Center(
              child: TextFormField(
                focusNode: cAddressNode,
                cursorColor: ThemeColorApp().primaryColor,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(13),
                ],
                keyboardType: TextInputType.number,
                controller: cAddressController,
                style: TextStyle(
                  fontSize: 14.0,
                  color: ThemeColorApp().secondaryColor,
                ),
                decoration: InputDecoration(
                  hintText: "Address",
                  hintStyle: TextStyle(
                    color: ThemeColorApp().placeholder,
                    fontSize: 14.0,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    cAddressController.text = value;
                    cAddressController.selection = TextSelection.fromPosition(
                        TextPosition(offset: cAddressController.text.length));
                  });
                },
                onFieldSubmitted: (value) {
                  setState(() {
                    cAddressController.text = value;
                  });
                },
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Container(
            width: widthScreen * 0.8,
            height: 48,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(9.0)),
                border: Border.all(color: ThemeColorApp().placeholder)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                  icon: Icon(Icons.arrow_drop_down_circle,
                      color: Colors.grey.withOpacity(0.7)),
                  items: provinceList,
                  onChanged: (value) {
                    setState(() {
                      cProvinceController = value;
                      cDistrictController = "";
                      cSubDistrictController = "";
                      cPostCodeController = "";
                      districtList = [];
                      subDistrictList = [];
                      switch (value) {
                        case "พะเยา":
                          {
                            cPostCodeController = "56000";
                            districtList = [
                              DropdownMenuItem(
                                value: "",
                                child: Text(
                                  "Please choose a district",
                                  style: TextStyle(
                                      color: ThemeColorApp().placeholder),
                                ),
                              ),
                              const DropdownMenuItem(
                                value: "แม่กา",
                                child: Text("แม่กา"),
                              )
                            ];

                            subDistrictList = [
                              DropdownMenuItem(
                                value: "",
                                child: Text(
                                  "Please choose a subdistrict",
                                  style: TextStyle(
                                      color: ThemeColorApp().placeholder),
                                ),
                              ),
                              const DropdownMenuItem(
                                value: "เมืองพะเยา",
                                child: Text("เมืองพะเยา"),
                              )
                            ];
                          }
                        case "กรุงเทพมหานคร":
                          {
                            cPostCodeController = "10110";
                            districtList = [
                              DropdownMenuItem(
                                value: "",
                                child: Text(
                                  "Please choose a district",
                                  style: TextStyle(
                                      color: ThemeColorApp().placeholder),
                                ),
                              ),
                              const DropdownMenuItem(
                                value: "คลองเตย",
                                child: Text("คลองเตย"),
                              )
                            ];

                            subDistrictList = [
                              DropdownMenuItem(
                                value: "",
                                child: Text(
                                  "Please choose a subdistrict",
                                  style: TextStyle(
                                      color: ThemeColorApp().placeholder),
                                ),
                              ),
                              const DropdownMenuItem(
                                value: "คลองเตย",
                                child: Text("คลองเตย"),
                              ),
                              const DropdownMenuItem(
                                value: "คลองตัน",
                                child: Text("คลองตัน"),
                              ),
                              const DropdownMenuItem(
                                value: "พระโขนง",
                                child: Text("พระโขนง"),
                              ),
                            ];
                          }
                      }
                    });
                  },
                  value: cProvinceController,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Container(
            width: widthScreen * 0.8,
            height: 48,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(9.0)),
                border: Border.all(color: ThemeColorApp().placeholder)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                  icon: Icon(Icons.arrow_drop_down_circle,
                      color: Colors.grey.withOpacity(0.7)),
                  items: districtList,
                  onChanged: (value) {
                    setState(() {
                      cDistrictController = value;
                    });
                  },
                  value: cDistrictController,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Container(
            width: widthScreen * 0.8,
            height: 48,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(9.0)),
                border: Border.all(color: ThemeColorApp().placeholder)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                  icon: Icon(Icons.arrow_drop_down_circle,
                      color: Colors.grey.withOpacity(0.7)),
                  items: subDistrictList,
                  onChanged: (value) {
                    setState(() {
                      cSubDistrictController = value;
                      if (value == "เมืองพะเยา") {
                        cPostCodeController = "56000";
                      }
                    });
                  },
                  value: cSubDistrictController,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Container(
              width: widthScreen * 0.8,
              height: 48,
              decoration: BoxDecoration(
                color: HexColor("#f1f1f1"),
                borderRadius: const BorderRadius.all(Radius.circular(9.0)),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 12, 8, 8),
                child: Text(cSubDistrictController == ""
                    ? "00000"
                    : cPostCodeController),
              )),
          const SizedBox(
            height: 16,
          ),
          Container(
            width: widthScreen * 0.8,
            height: 48,
            child: Center(
              child: TextFormField(
                focusNode: cTellNode,
                cursorColor: ThemeColorApp().primaryColor,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(10),
                ],
                keyboardType: TextInputType.number,
                controller: cTellController,
                style: TextStyle(
                  fontSize: 14.0,
                  color: ThemeColorApp().secondaryColor,
                ),
                decoration: InputDecoration(
                  hintText: "Tell",
                  hintStyle: TextStyle(
                    color: ThemeColorApp().placeholder,
                    fontSize: 14.0,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    cTellController.text = value;
                    cTellController.selection = TextSelection.fromPosition(
                        TextPosition(offset: cTellController.text.length));
                  });
                },
                onFieldSubmitted: (value) {
                  setState(() {
                    cTellController.text = value;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
