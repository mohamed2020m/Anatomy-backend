import 'package:TerraViva/models/Category.dart';
import 'package:TerraViva/screens/home/subCategory/SubCategoryComponent.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import '../../../app_skoleton/appSkoleton.dart';
import '../../../controller/categoryController.dart';
import '../../../network/Endpoints.dart';
import '../../../provider/dataCenter.dart';
import '../../../service/serviceLocator.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen>
    with TickerProviderStateMixin {
  AnimationController? animationController;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    super.initState();
  }

  final categoryController = getIt<CategoryController>();
  @override
  Widget build(BuildContext context) {
    final Animation<double> animation2 =
        Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: animationController!, curve: Curves.fastOutSlowIn),
    );
    animationController?.forward();
    var categoryProvider = Provider.of<DataCenter>(context, listen: true);

    print("currentCategory.name: ${categoryProvider.currentCategory.name}");
    print("currentCategory.id: ${categoryProvider.currentCategory.id}");

    var size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 50,
          backgroundColor: const Color.fromARGB(255, 246, 246, 246),
          shadowColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              // handle the press
              Navigator.pop(context);
            },
          ),
          automaticallyImplyLeading: false,
        ),
        body: Column(children: [
          SizedBox(
              child: AnimatedBuilder(
                  animation: animationController!,
                  builder: (BuildContext context, Widget? child) {
                    return FadeTransition(
                      opacity: animation2,
                      child: Transform(
                          transform: Matrix4.translationValues(
                              50 * (1.0 - animation2.value), 0.0, 0.0),
                          child: Container(
                              constraints:
                                  BoxConstraints(maxHeight: size.height / 2),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                    color: const Color.fromRGBO(58, 81, 96, 1)
                                        .withOpacity(0.06),
                                    offset: const Offset(0, 2.1),
                                    blurRadius: 8.0,
                                  ),
                                  // BoxShadow(
                                  // color: Color.fromARGB(255, 255, 255, 255),

                                  // offset: const Offset(1.1, 1.1),
                                  // blurRadius: 8.0),
                                ],
                              ),
                              // color: Colors.red,
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, top: 20, bottom: 10),
                              margin: const EdgeInsets.only(bottom: 8),
                              child: SizedBox(
                                  //  height: size.height /5,
                                  child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(
                                        bottom: 8, right: 10),
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        //TODO: category image
                                        image: DecorationImage(
                                            //image: AssetImage("assets/img01.png"),
                                            image: NetworkImage(
                                                "${Endpoints.baseUrl}/files/download/${categoryProvider.currentCategory.image}"),
                                            fit: BoxFit.scaleDown)),
                                  ),
                                  // Container(
                                  //   decoration: BoxDecoration(
                                  //     borderRadius: const BorderRadius.all(
                                  //         Radius.circular(16.0)),
                                  //   ),
                                  //   child: ClipRRect(
                                  //     borderRadius: const BorderRadius.all(
                                  //         Radius.circular(30.0)),
                                  //     child: AspectRatio(
                                  //         aspectRatio: 1,
                                  //         child: Image.asset(
                                  //             'assets/images/programmation-icon-64.png')),
                                  //   ),
                                  // ),

                                  SizedBox(
                                      width: size.width / 1.5,
                                      child: SingleChildScrollView(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  bottom: 8),
                                              //TODO: category name
                                              child: Text(
                                                categoryProvider
                                                    .currentCategory.name,
                                                textAlign: TextAlign.left,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              child: ReadMoreText(
                                                categoryProvider.currentCategory
                                                    .description,
                                                trimLines: 3,
                                                trimMode: TrimMode.Line,
                                                trimCollapsedText: ' Voir plus',
                                                trimExpandedText: ' Voir moins',
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
                                              future: categoryController
                                                  .getCategoryCount(
                                                      categoryProvider
                                                          .currentCategory.id),
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            top: 8),
                                                    child: AppSkoleton(
                                                      width: 80,
                                                      height: 20,
                                                      margin:
                                                          const EdgeInsets.only(
                                                              bottom: 8,
                                                              right: 5,
                                                              left: 5),
                                                      radius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                  );
                                                } else if (snapshot.hasData) {
                                                  return Container(
                                                    decoration: BoxDecoration(
                                                      color: const Color(
                                                          0xFF6D83F2),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16),
                                                    ),
                                                    margin:
                                                        const EdgeInsets.only(
                                                            top: 8),
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 8,
                                                        vertical: 4),
                                                    child: Text(
                                                      '${snapshot.data} categories',
                                                      textAlign: TextAlign.left,
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  );
                                                }
                                                return Container();
                                              },
                                            ),
                                          ],
                                        ),
                                      )),
                                ],
                              )))),
                    );
                  })),
          Expanded(
              child: CoursViewRout(animationController: animationController))
        ]));
  }
}

class CoursViewRout extends StatefulWidget {
  const CoursViewRout({
    Key? key,
    this.animationController,
  }) : super(key: key);

  final AnimationController? animationController;

  @override
  _CoursViewRoutState createState() => _CoursViewRoutState();
}

class _CoursViewRoutState extends State<CoursViewRout> {
  final categoryController = getIt<CategoryController>();

  @override
  Widget build(BuildContext context) {
    var categoryProvider = Provider.of<DataCenter>(context, listen: true);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: FutureBuilder<List<Category>>(
        future: categoryController.getSubCategories(
          categoryProvider.currentCategory.id,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show Skeleton Loading Grid
            return GridView.builder(
              padding: const EdgeInsets.all(8),
              physics: const BouncingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 15.0,
                crossAxisSpacing: 20.0,
                childAspectRatio: 0.8,
              ),
              itemCount: 5,
              itemBuilder: (context, index) {
                return SkoletonView(
                  animationController: widget.animationController,
                  animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                      parent: widget.animationController!,
                      curve: Interval(
                        (1 / 5) * index,
                        1.0,
                        curve: Curves.fastOutSlowIn,
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            // Error Message
            return _buildErrorWidget();
          } else if (snapshot.hasData && snapshot.data!.isEmpty) {
            // Empty Data
            return _buildEmptyState();
          } else if (snapshot.hasData) {
            // Grid of Subcategories
            return GridView.builder(
              padding: const EdgeInsets.all(8),
              physics: const BouncingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 15.0,
                crossAxisSpacing: 20.0,
                childAspectRatio: 0.8,
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final category = snapshot.data![index];
                return SubCategoryComponent(category: category);
              },
            );
          }
          return Container(); // Fallback (unlikely case)
        },
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 64,
            height: 64,
            child: Image(
              image: AssetImage("assets/images/error.png"),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "An error occurred while loading your data.",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => setState(() {}),
            child: const Text(
              "Retry",
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 64,
            height: 64,
            child: Image(
              image: AssetImage("assets/images/empty-folder.png"),
            ),
          ),
          SizedBox(height: 8),
          Text(
            "There are no items available for this category.",
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class SkoletonView extends StatelessWidget {
  const SkoletonView({
    Key? key,
    this.animationController,
    this.animation,
  }) : super(key: key);

  final AnimationController? animationController;
  final Animation<double>? animation;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 50 * (1.0 - animation!.value), 0.0),
            child: InkWell(
              splashColor: const Color.fromARGB(0, 255, 0, 0),
              child: SizedBox(
                height: 280,
                child: Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: <Widget>[
                    Container(
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Color.fromARGB(0, 56, 55, 55),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16.0)),
                              ),
                              child: Column(
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 16, left: 16, right: 16),
                                              child: AppSkoleton(
                                                  width: size.width / 3.8,
                                                  height: 12,
                                                  margin: const EdgeInsets.only(
                                                      bottom: 5),
                                                  radius:
                                                      BorderRadius.circular(5))
                                              ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 8,
                                                left: 16,
                                                right: 16,
                                                bottom: 8),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                //TODO:
                                                AppSkoleton(
                                                    width: size.width / 5,
                                                    height: 10,
                                                    margin:
                                                        const EdgeInsets.only(
                                                            bottom: 5),
                                                    radius:
                                                        BorderRadius.circular(
                                                            5))
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Padding(
                        padding:
                            const EdgeInsets.only(top: 20, right: 16, left: 16),
                        child: Container(
                          child: ClipRRect(
                            child: AspectRatio(
                                aspectRatio: 1,
                                child: AppSkoleton(
                                    width: size.width / 3,
                                    height: size.width / 3,
                                    margin: const EdgeInsets.only(bottom: 5),
                                    radius: BorderRadius.circular(5))),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
