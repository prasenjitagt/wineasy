
/*

// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:wineasy/components/custom_button.dart';
import 'package:wineasy/components/error_card.dart';
import 'package:wineasy/components/side_nav_bar.dart';
import 'package:wineasy/models/category_model.dart';
import 'package:wineasy/screens/dashboard.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({super.key});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  late Future<List<CategoryModel>> futureProductCategories;

  //to check is form submitting
  bool isSubmitting = false;
  //state controller for delete
  bool isDeleting = false;

  //TextEditingControllers for Form
  TextEditingController productCategory = TextEditingController();

  @override
  void initState() {
    super.initState();
    futureProductCategories = fetchCategories();
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
          const VerticalDivider(
            color: Colors.black,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width * 0.3,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 30.0),
              child: FutureBuilder<List<CategoryModel>>(
                future: futureProductCategories,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text('NO CATEGORIES YET');
                  } else {
                    // Data loaded successfully
                    List<CategoryModel> categoriesList =
                        snapshot.data as List<CategoryModel>;
                    if (categoriesList.isEmpty == true) {
                      return const Center(
                          child: Text(
                        'NO CATEGORIES YET',
                        style: TextStyle(fontSize: 35),
                      ));
                    } else {
                      return ListView.builder(
                          itemCount: categoriesList.length,
                          itemBuilder: (context, index) => ListTile(
                                leading: Text(
                                  '${index + 1}. ${categoriesList[index].categoryOfFood}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 15),
                                ),
                                trailing: IconButton(
                                    onPressed: () {},
                                    // onPressed: deleteCategory(
                                    //     categoriesList[index].categoryId),
                                    icon: const Icon(
                                        Icons.delete_forever_rounded)),
                              ));
                    }
                  }
                },
              ),
            ),
          )
        ],
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

        const String addCategoryUrl = "http://localhost:4848/api/add-category";

        //converting category data to json
        Map<String, dynamic> val = {'category': categoryValue};

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

  Future<List<CategoryModel>> fetchCategories() async {
    const String getCategoriesUrl = "http://localhost:4848/api/get-categories";
    try {
      Response serverResponse = await Dio().get(getCategoriesUrl);

      if (serverResponse.data.runtimeType == List) {
        // Process the data
        List<CategoryModel> categoriesList =
            (serverResponse.data as List<dynamic>)
                .map((categoryData) => CategoryModel.fromJson(categoryData))
                .toList();

        return categoriesList;
      } else {
        return List.empty();
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
        print('deleted');

        // Fetch updated categories after deletion
        List<CategoryModel> updatedCategories = await fetchCategories();

        // Update the UI with the updated list
        setState(() {
          futureProductCategories = Future.value(updatedCategories);
        });
      }
    } catch (error) {
      print('unexpected server error at product description: $error');
    } finally {
      isDeleting = false;
    }
  }
}





*/