import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:wineasy/components/custom_button.dart';
import 'package:wineasy/components/error_card.dart';
import 'package:wineasy/components/side_nav_bar.dart';

class AddProducts extends StatefulWidget {
  const AddProducts({super.key});

  @override
  State<AddProducts> createState() => _AddProductsState();
}

class _AddProductsState extends State<AddProducts> {
  //to check is form submitting
  bool isSubmitting = false;

  //DropDown Values for Form
  static const List<String> typeOfFood = ["Veg", "Non-Veg"];
  String typeOfFoodValue = "";

  //DropDown Values for Form
  // ignore: unused_field
  static const List<String> categoryOfFood = [
    "BIRYANI",
    "PIZZA",
    "ICE CREAME",
    "PARATHA"
  ];
  String categoryOfFoodValue = "";

  //Image Picker Variables
  late File? file;
  String finalImageName = "";
  late String fullImageName;

  //TextEditingControllers for Form
  TextEditingController productName = TextEditingController();
  TextEditingController productPrice = TextEditingController();
  TextEditingController productDescription = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideNavBar(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Center(
          child: Text(
            "Add Product",
            style: TextStyle(
                fontSize: 25, fontWeight: FontWeight.w600, color: Colors.black),
          ),
        ),
      ),
      body: Center(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width * 0.4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Center(
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: 20,
                  ),
                  child: Text(
                    "EasyEatz",
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w900,
                        color: Colors.red),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: TextField(
                  controller: productName,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Product Name',
                      hintText: 'Enter valid a product name'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Container(
                  decoration: BoxDecoration(border: Border.all()),
                  width: double.maxFinite,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextButton(
                        onPressed: imagePick,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Select Image \n$finalImageName',
                            style: const TextStyle(
                                color: Colors.red, fontSize: 16),
                          ),
                        )),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: TextField(
                  controller: productPrice,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Price',
                      hintText: 'Enter Price in Paise'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: DropdownMenu(
                          width: MediaQuery.of(context).size.width * 0.19,
                          hintText: "Select Category",
                          onSelected: (String? value) {
                            setState(() {
                              if (value != null) {
                                categoryOfFoodValue = value;
                              }
                            });
                          },
                          dropdownMenuEntries: categoryOfFood
                              .map<DropdownMenuEntry<String>>((eachType) {
                            return DropdownMenuEntry<String>(
                                value: eachType, label: eachType);
                          }).toList()),
                    ),
                    DropdownMenu(
                        width: MediaQuery.of(context).size.width * 0.19,
                        hintText: "Select Type",
                        onSelected: (String? value) {
                          setState(() {
                            typeOfFoodValue = value!;
                          });
                        },
                        dropdownMenuEntries: typeOfFood
                            .map<DropdownMenuEntry<String>>((eachType) {
                          return DropdownMenuEntry<String>(
                              value: eachType, label: eachType);
                        }).toList()),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: TextField(
                  controller: productDescription,
                  maxLines: 4,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Description',
                      hintText: 'Message'),
                ),
              ),
              InkWell(
                onTap: () => handleAddProductSubmission(context),
                splashColor: Colors.red,
                child: CustomButton(
                  buttonText: "ADD PRODUCT",
                  buttonColor: Colors.red.withOpacity(0.9),
                  isSubmitting: isSubmitting,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void imagePick() async {
    try {
      FilePickerResult? result =
          await FilePicker.platform.pickFiles(type: FileType.image);

      if (result != null) {
        file = File(result.files.single.path!);

        //handling the file name
        setState(() {
          fullImageName = basename(file!.path);

          if (fullImageName.length < 15) {
            finalImageName = '$fullImageName...';
          } else {
            finalImageName = '${fullImageName.substring(0, 14)}...';
          }
        });
      } else {
        // User canceled the picker
        setState(() {
          finalImageName = 'Please Select Image  !';
        });
      }
    } catch (error) {
      print('Error: $error');
    }
  }

//Add Product function

  void handleAddProductSubmission(BuildContext context) async {
    try {
      String nameValue = productName.value.text;
      String priceValue = (productPrice.value.text);
      String descriptionValue = productDescription.value.text;

      //Coverting the price value to int
      int? priceValueConvertedToInt = int.tryParse(priceValue);

      // If All feilds are not field then if condition will run otherwise else will run
      if (nameValue == "" ||
          priceValue == "" ||
          descriptionValue == "" ||
          finalImageName == "" ||
          typeOfFoodValue == "" ||
          categoryOfFoodValue == "") {
//Error Snackbar If data is empty
        final formErrorSnackBar = SnackBar(
          duration: const Duration(milliseconds: 800),
          showCloseIcon: true,
          closeIconColor: Colors.black,
          backgroundColor: Colors.red.withOpacity(1),
          content: const Text(
            'All fields are required!',
            style: TextStyle(color: Colors.black, fontSize: 30),
          ),
        );

        // Find the ScaffoldMessenger in the widget tree
        // and use it to show a SnackBar.
        ScaffoldMessenger.of(context).showSnackBar(formErrorSnackBar);
      } else {
        //checking is the price value int ?

        if ((priceValueConvertedToInt.runtimeType) != int) {
          //Error Snackbar If data is empty

          final priceTypeErrorSnackbar = SnackBar(
            duration: const Duration(milliseconds: 800),
            showCloseIcon: true,
            closeIconColor: Colors.black,
            backgroundColor: Colors.red.withOpacity(1),
            content: const Text(
              'Price Should be a Number !',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
          );

          // Find the ScaffoldMessenger in the widget tree
          // and use it to show a SnackBar.
          ScaffoldMessenger.of(context).showSnackBar(priceTypeErrorSnackbar);
        } else {
          //call api here

          setState(() {
            isSubmitting = true;
          });

          Map<String, dynamic> vals = {
            'name': nameValue,
            'price': priceValueConvertedToInt,
            'description': descriptionValue,
            'type': typeOfFoodValue,
            'category': categoryOfFoodValue,
            'file': await MultipartFile.fromFile(file!.path,
                filename: fullImageName),
          };

          FormData formData = FormData.fromMap(vals);

          const String addProductUrl = "http://localhost:4848/api/add-product";

          Response serverResponse = await Dio().post(
            addProductUrl,
            data: formData,
            options: Options(
              contentType: Headers.formUrlEncodedContentType,
            ),
          );

//if upload was successfull then
          if (serverResponse.statusCode == 200) {
            //snackbar to show that product was added
            final productAddedSnackBar = SnackBar(
              duration: const Duration(milliseconds: 800),
              showCloseIcon: true,
              closeIconColor: Colors.black,
              backgroundColor: Colors.green.withOpacity(1),
              content: const Text(
                'Product Added Successfully',
                style: TextStyle(color: Colors.black, fontSize: 30),
              ),
            );

            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(productAddedSnackBar);

            //Clearing the controllers
            productName.clear();
            productPrice.clear();
            productDescription.clear();

            //Resetting dropdown valus
            setState(() {
              file = null;
              finalImageName = "";
            });
          } else {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => const ErrorCard(errorText: 'Adding Product Failed');))

          }
        }
      }
    } catch (error) {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => const ErrorCard(errorText: 'Adding Product Failed');))


    } finally {
      setState(() {
        isSubmitting = false;
      });
    }
  }
}
