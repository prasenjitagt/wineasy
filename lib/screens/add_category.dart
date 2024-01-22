// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
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
  //to check is form submitting
  bool isSubmitting = false;

  //TextEditingControllers for Form
  TextEditingController productCategory = TextEditingController();

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
      body: Center(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width * 0.4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                  controller: productCategory,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Category Name',
                      hintText: 'Enter valid a category name'),
                ),
              ),
              InkWell(
                onTap: () => handleAddCategoryubmission(context),
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

//ADD PRODUCT function

  void handleAddCategoryubmission(BuildContext context) async {
    try {
      String categoryValue = productCategory.value.text;

      // If All feilds are not filled then if condition will run otherwise else will run
      if (categoryValue == "") {
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

        const String addCategoryUrl = "http://localhost:4848/api/add-product";

        Response serverResponse = await Dio().post(
          addCategoryUrl,
          data: categoryValue,
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
              'Category Added Successfully',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
          );

          ScaffoldMessenger.of(context).showSnackBar(productAddedSnackBar);

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
}
