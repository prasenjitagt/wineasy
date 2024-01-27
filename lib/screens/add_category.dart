// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:wineasy/components/custom_button.dart';
import 'package:wineasy/components/error_card.dart';
import 'package:wineasy/components/side_nav_bar.dart';
import 'package:wineasy/screens/dashboard.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({super.key});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  List? categoryList;

  //to check is form submitting
  bool isSubmitting = false;
  //state controller for delete
  bool isDeleting = false;

  //TextEditingControllers for Form
  TextEditingController productCategory = TextEditingController();

//Image Picker Variables
  late File? file;
  String finalImageName = "";
  late String fullImageName;

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideNavBar(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Center(
          child: Text(
            "ADD CATEGORY",
            style: TextStyle(
                fontSize: 25, fontWeight: FontWeight.w600, color: Colors.black),
          ),
        ),
      ),
      body: Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                //1st widget in coloumn
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

                //2nd widget in coloumn
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 80.0),
                  child: TextField(
                    controller: productCategory,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Category Name',
                        hintText: 'Enter valid a category name'),
                  ),
                ),

                // 3rd Widget in coloumn
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

                // 4th Widget in coloumn
                InkWell(
                  onTap: () => handleAddCategoryubmission(context),
                  splashColor: Colors.red,
                  child: CustomButton(
                    buttonText: "ADD CATEGORY",
                    buttonColor: Colors.red.withOpacity(0.9),
                    isSubmitting: isSubmitting,
                  ),
                )
              ],
            ),
          ),
          const VerticalDivider(
            color: Colors.black,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width * 0.3,
            child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 30.0),
                child: categoryList == null
                    ? const Center(child: Text('No Categories yet'))
                    : ListView.builder(
                        itemCount: categoryList!.length,
                        itemBuilder: (context, index) => ListTile(
                              leading: Text(
                                '${index + 1}. ${categoryList![index]['categoryName']}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 15),
                              ),
                              trailing: IconButton(
                                  onPressed: () {
                                    deleteCategory(categoryList![index]['_id']);
                                  },
                                  icon:
                                      const Icon(Icons.delete_forever_rounded)),
                            ))),
          )
        ],
      ),
    );
  }

  //function for picking image
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

  //ADD CATEGORY function

  void handleAddCategoryubmission(BuildContext context) async {
    try {
      String categoryValue = productCategory.value.text;

      // If All feilds are not filled then if condition will run otherwise else will run
      if (categoryValue == "" || finalImageName == "") {
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
        //call api here

        setState(() {
          isSubmitting = true;
        });

        const String addCategoryUrl = "http://localhost:4848/api/add-category";

        List<int> fileBytes = await file!.readAsBytes();
        String encodedImage = base64Encode(fileBytes);

        //converting category data to json
        Map<String, dynamic> val = {
          'category': categoryValue,
          'categoryImage': encodedImage,
          'imageName': fullImageName
        };

        Response serverResponse = await Dio().post(
          addCategoryUrl,
          data: val,
        );

        //if upload was successfull then
        if (serverResponse.statusCode == 200) {
          //snackbar to show that product was added
          final categoryAddedSnackBar = SnackBar(
            duration: const Duration(milliseconds: 800),
            showCloseIcon: true,
            closeIconColor: Colors.black,
            backgroundColor: Colors.green.withOpacity(1),
            content: const Text(
              'Category Added Successfully',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
          );

          ScaffoldMessenger.of(context).showSnackBar(categoryAddedSnackBar);

          //Clearing the controller
          productCategory.clear();

          fetchCategories();
        } else if (serverResponse.statusCode == 205) {
          //snackbar to show that category already exists
          final categoryExistsSnackBar = SnackBar(
            duration: const Duration(milliseconds: 800),
            showCloseIcon: true,
            closeIconColor: Colors.black,
            backgroundColor: Colors.red.withOpacity(1),
            content: const Text(
              'Category Already Exists',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
          );

          ScaffoldMessenger.of(context).showSnackBar(categoryExistsSnackBar);

          //Clearing the controller
          productCategory.clear();
        } else {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const ErrorCard(
                        errorText:
                            'Adding Category Failed\nGo to Dashboard and retry',
                        destinationWidgetName: 'Dashboard',
                        destinationWidget: Dashboard(),
                      )));
        }
      }
    } catch (error) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const ErrorCard(
                    errorText:
                        'Adding Category Failed\nGo to Dashboard and retry',
                    destinationWidgetName: 'Dashboard',
                    destinationWidget: Dashboard(),
                  )));
    } finally {
      setState(() {
        isSubmitting = false;
      });
    }
  }

  void fetchCategories() async {
    const String getCategoriesUrl = "http://localhost:4848/api/get-categories";
    try {
      Response serverResponse = await Dio().get(getCategoriesUrl);

      if (serverResponse.statusCode == 200) {
        // Setting the serverResponse data to category List
        setState(() {
          categoryList = serverResponse.data;
        });
      } else if (serverResponse.statusCode == 204) {
        setState(() {
          categoryList = null;
        });
      } else {
        setState(() {
          categoryList = null;
        });
      }
    } catch (e) {
      print('Error fetching data: $e');

      rethrow;
    }
  }

  deleteCategory(String categoryId) async {
    isDeleting = true;

    //API endpoint
    const String deleteCategoryUrl =
        "http://localhost:4848/api/delete-category";

    //enconding the product Id
    String encodedString = base64Encode(utf8.encode(categoryId));

    try {
      Response serverResponse =
          await Dio().delete(deleteCategoryUrl, queryParameters: {
        'categoryId': encodedString,
      });

      if (serverResponse.statusCode == 200) {
        fetchCategories();
      }
    } catch (error) {
      print('unexpected server error at product description: $error');
    } finally {
      isDeleting = false;
    }
  }
}
