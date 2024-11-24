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


// class SubCategoryComponent extends StatelessWidget {
//   const SubCategoryComponent({
//     Key? key,
//     required this.category,
//   }) : super(key: key);

//   final Category category;

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;

//     return InkWell(
//       borderRadius: BorderRadius.circular(16),
//       splashColor: Colors.blue.withOpacity(0.1),
//       onTap: () {
//         // Navigate to SubCategory Screen
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => const SubCategoryScreen(),
//           ),
//         );
//       },
//       child: Container(
//         margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
//         child: Row(
//           children: [
//             // Image
//             Container(
//               width: 70,
//               height: 70,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10),
//                 image: DecorationImage(
//                   image: NetworkImage(
//                     "${Endpoints.baseUrl}/files/download/${category.image}",
//                   ),
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//             const SizedBox(width: 10),
//             // Text Details
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     category.name,
//                     overflow: TextOverflow.ellipsis,
//                     style: const TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     category.description,
//                     overflow: TextOverflow.ellipsis,
//                     maxLines: 2,
//                     style: const TextStyle(
//                       fontSize: 14,
//                       color: Colors.black54,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


// class SubCategoryComponent extends StatelessWidget {
//   SubCategoryComponent({
//     Key? key,
//     required this.category,
//   }) : super(key: key);
//   Category category;
//   final categoryController = getIt<CategoryController>();

//   @override
//   Widget build(BuildContext context) {
//     var size = MediaQuery.of(context).size;
//     var categoryProvider = Provider.of<DataCenter>(context, listen: false);
//     return InkWell(
//       borderRadius: BorderRadius.circular(16),
//       splashColor: const Color.fromARGB(0, 255, 0, 0),
//       onTap: () {
//         //TODO: navigate to object screen
//         categoryProvider.setCurretntCategory(category);

//         Navigator.push(
//             context, MaterialPageRoute(builder: (context) => const SubCategoryScreen()));
//       },
//       child: Container(
//         width: size.width,
//         margin: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 20),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(
//                   margin: const EdgeInsets.only(bottom: 8, right: 10),
//                   width: 70,
//                   height: 70,
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10),
//                       //TODO: category image
//                       image: DecorationImage(
//                           //image: AssetImage(category!.image),
//                           image: NetworkImage("${Endpoints.baseUrl}/files/download/${category.image}"),
//                           fit: BoxFit.scaleDown)),
//                 ),
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Container(
//                       width: size.width - 20 - 80,
//                       margin: const EdgeInsets.only(bottom: 10),
//                       child: Text(
//                         overflow: TextOverflow.ellipsis,
//                         category.name,
//                         style: const TextStyle(
//                             fontSize: 18, fontWeight: FontWeight.w600),
//                       ),
//                     ),
//                     SizedBox(
//                       width: size.width - 20 - 80,
//                       child: ReadMoreText(
//                         category.description,
//                         trimLines: 3,
//                         trimMode: TrimMode.Line,
//                         trimCollapsedText: 'Show more',
//                         trimExpandedText: 'Show less',
//                         moreStyle: const TextStyle(
//                             fontSize: 15,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.blue),
//                         lessStyle: const TextStyle(
//                             fontSize: 15,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.blue),
//                       ),
//                     ),
//                     FutureBuilder<int>(
//                       future: categoryController.getObject3dCountByCategory(category.id),
//                       builder: (context, snapshot) {
//                         if (snapshot.connectionState == ConnectionState.waiting) {
//                           return Container(
//                             margin: const EdgeInsets.only(top: 8),
//                             child: AppSkoleton(
//                               width: 80,
//                               height: 20,
//                               margin: const EdgeInsets.only(
//                                   bottom: 8, right: 5, left: 5),
//                               radius: BorderRadius.circular(5),
//                             ),
//                           );
//                         } else if (snapshot.hasData) {
//                           return Container(
//                             margin: const EdgeInsets.only(top: 8),
//                             //TODO: objetc count
//                             child: Text(
//                               '${snapshot.data} categories',
//                               textAlign: TextAlign.left,
//                               style: const TextStyle(
//                                 color: Colors.blue,
//                                 fontWeight: FontWeight.w400,
//                                 fontSize: 15,
//                               ),
//                             ),
//                           );
//                         }
//                         return Container();
//                       },
//                     )
//                   ],
//                 )
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
