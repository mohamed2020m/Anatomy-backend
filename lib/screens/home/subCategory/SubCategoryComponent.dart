import 'package:TerraViva/app_skoleton/appSkoleton.dart';
import 'package:TerraViva/controller/categoryController.dart';
import 'package:TerraViva/network/Endpoints.dart';
import 'package:TerraViva/provider/dataCenter.dart';
import 'package:TerraViva/screens/home/objects/SubCategoryScreen.dart';
import 'package:TerraViva/service/serviceLocator.dart';
import 'package:flutter/material.dart';
import 'package:TerraViva/models/Category.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';


class SubCategoryComponent extends StatelessWidget {
  SubCategoryComponent({
    Key? key,
    required this.category,
  }) : super(key: key);

  final Category category;
  final categoryController = getIt<CategoryController>();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var categoryProvider = Provider.of<DataCenter>(context, listen: false);

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      splashColor: Colors.blue.withOpacity(0.2),
      onTap: () {
        // Navigate to the subcategory screen
        // categoryProvider.setCurretntCategory(category);
        categoryProvider.setCurretntSubCategory(category);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SubCategoryScreen(),
          ),
        );
      },
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // Ensure the card doesn't expand unnecessarily
          children: [
            // Image at the top
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                  "${Endpoints.baseUrl}/files/download/${category.image}",
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.broken_image, size: 40);
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              ),
            ),

            // Make the bottom section scrollable
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name of the category
                    Text(
                      category.name,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Description with a "Read More" option
                    ReadMoreText(
                      category.description,
                      trimLines: 2,
                      trimMode: TrimMode.Line,
                      // trimCollapsedText: 'Show more',
                      // trimExpandedText: 'Show less',
                      moreStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                      lessStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),

                    // const SizedBox(height: 10),

                    // // Object count (retrieved asynchronously)
                    // FutureBuilder<int>(
                    //   future: categoryController.getObject3dCountByCategory(category.id),
                    //   builder: (context, snapshot) {
                    //     if (snapshot.connectionState == ConnectionState.waiting) {
                    //       return Container(
                    //         margin: const EdgeInsets.only(top: 8),
                    //         child: AppSkoleton(
                    //           width: 80,
                    //           height: 20,
                    //           margin: const EdgeInsets.only(bottom: 8),
                    //           radius: BorderRadius.circular(5),
                    //         ),
                    //       );
                    //     } else if (snapshot.hasData) {
                    //       return Text(
                    //         '${snapshot.data} objects',
                    //         style: const TextStyle(
                    //           color: Colors.blue,
                    //           fontSize: 14,
                    //           fontWeight: FontWeight.w400,
                    //         ),
                    //       );
                    //     }
                    //     return Container();
                    //   },
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}