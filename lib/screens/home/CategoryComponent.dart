import 'package:TerraViva/screens/home/subCategory/CategoryScreen.dart';
import 'package:flutter/material.dart';
import 'package:TerraViva/models/Category.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';

import '../../app_skoleton/appSkoleton.dart';
import '../../controller/categoryController.dart';
import '../../network/Endpoints.dart';
import '../../provider/dataCenter.dart';
import '../../service/serviceLocator.dart';

class CategoryComponent extends StatelessWidget { 
  CategoryComponent({
    Key? key,
    required this.category,
  }) : super(key: key);
  
  Category category;
  final categoryController = getIt<CategoryController>();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var categoryProvider = Provider.of<DataCenter>(context, listen: false);
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      splashColor: const Color.fromARGB(0, 255, 0, 0),
      onTap: () {
        //TODO: navigate to object screen
        categoryProvider.setCurretntCategory(category);

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const CategoryScreen()));
      },
      child: Container(
        width: size.width,
        margin: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 8, right: 10),
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      //TODO: category image
                      image: DecorationImage(
                          //image: AssetImage(category!.image),
                          image: NetworkImage("${Endpoints.baseUrl}/files/download/${category.image}"),
                          fit: BoxFit.scaleDown)),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: size.width - 20 - 80,
                      margin: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        overflow: TextOverflow.ellipsis,
                        category.name,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(
                      width: size.width - 20 - 80,
                      child: ReadMoreText(
                        category.description,
                        trimLines: 3,
                        trimMode: TrimMode.Line,
                        trimCollapsedText: 'Show more',
                        trimExpandedText: 'Show less',
                        moreStyle: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue),
                        lessStyle: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue),
                      ),
                    ),
                    FutureBuilder<int>(
                      future: categoryController.getCategoryCount(category.id),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Container(
                            margin: const EdgeInsets.only(top: 8),
                            child: AppSkoleton(
                              width: 80,
                              height: 20,
                              margin: const EdgeInsets.only(
                                  bottom: 8, right: 5, left: 5),
                              radius: BorderRadius.circular(5),
                            ),
                          );
                        } else if (snapshot.hasData) {
                          return Container(
                            margin: const EdgeInsets.only(top: 8),
                            //TODO: objetc count
                            child: Text(
                              '${snapshot.data} categories',
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.w400,
                                fontSize: 15,
                              ),
                            ),
                          );
                        }
                        return Container();
                      },
                    )
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
