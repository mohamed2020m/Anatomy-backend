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
        categoryProvider.setCurretntCategory(category);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const CategoryScreen()));
      },
      child: Stack(
        children: [
          Container(
            width: size.width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color.fromARGB(255, 146, 146, 146),
              ),
            ),
            margin:
                const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 8, right: 10),
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: NetworkImage(
                            "${Endpoints.baseUrl}/files/download/${category.image}"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            category.name,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                        ),
                        ReadMoreText(
                          category.description,
                          trimLines: 3,
                          trimMode: TrimMode.Line,
                          trimCollapsedText: 'Show more',
                          trimExpandedText: 'Show less',
                          moreStyle: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                          lessStyle: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 5,
            right: 10,
            child: FutureBuilder<int>(
              future: categoryController.getCategoryCount(category.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    ),
                  );
                } else if (snapshot.hasData) {
                  return Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF6D83F2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Text(
                      '${snapshot.data} categories',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                      ),
                    ),
                  );
                }
                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }
}
