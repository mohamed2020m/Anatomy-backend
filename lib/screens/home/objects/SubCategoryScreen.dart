import 'package:TerraViva/models/ThreeDObject.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import '../../../app_skoleton/appSkoleton.dart';
import '../../../controller/categoryController.dart';
import '../../../controller/objectsParCategoryController.dart';
import '../../../models/Object3d.dart';
import '../../../network/Endpoints.dart';
import '../../../provider/dataCenter.dart';
import '../../../service/serviceLocator.dart';
import 'ObjectViewScreen.dart';

class SubCategoryScreen extends StatefulWidget {
  const SubCategoryScreen({Key? key}) : super(key: key);

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<SubCategoryScreen>
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
                                        image: DecorationImage(
                                            //image: AssetImage("assets/img01.png"),
                                            image: NetworkImage(
                                              "${Endpoints.baseUrl}/files/download/${categoryProvider.currentSubCategory.image}"),
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
                                                    .currentSubCategory.name,
                                                textAlign: TextAlign.left,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              child: ReadMoreText(
                                                categoryProvider
                                                    .currentSubCategory
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
                                                  .getObject3dCountByCategory(
                                                      categoryProvider
                                                          .currentSubCategory
                                                          .id),
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
                                                      '${snapshot.data} objects',
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
  final objectsController = getIt<ObjectsParCategoryController>();

  Future<List<Object3d>> fetchSimpleList() async {
    // Simulate fetching data from an API or database.
    await Future.delayed(
        const Duration(seconds: 3)); // Simulate a delay of 2 seconds.

    // Return a simple list of integers.
    return [];
  }

  @override
  Widget build(BuildContext context) {
    var categoryProvider = Provider.of<DataCenter>(context, listen: true);
    return Container(
        // padding: EdgeInsets.only(top: 8),
        margin: const EdgeInsets.only(left: 15, right: 15),
        child: FutureBuilder(
          future: objectsController
              .getAllobjectsParCategory(categoryProvider.currentSubCategory.id),
          builder: (context, snapshot) {
            print("snapshot2: ${snapshot.data}");
            if (snapshot.connectionState == ConnectionState.waiting) {
              return GridView(
                padding: const EdgeInsets.all(8),
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 15.0,
                  crossAxisSpacing: 20.0,
                  childAspectRatio: 0.8,
                ),
                children: List<Widget>.generate(
                  5,
                  (int index) {
                    const int count = 5;
                    final Animation<double> animation =
                        Tween<double>(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                        parent: widget.animationController!,
                        curve: Interval((1 / count) * index, 1.0,
                            curve: Curves.fastOutSlowIn),
                      ),
                    );
                    widget.animationController?.forward();
                    return SkoletonView(
                      animation: animation,
                      animationController: widget.animationController,
                    );
                  },
                ),
              );
            } else if (snapshot.hasError) {
              final error = snapshot.error;
              print("error: $error");

              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                        child: Container(
                      margin: const EdgeInsets.only(
                          bottom: 20, right: 15, left: 15, top: 64),
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: const DecorationImage(
                              image: AssetImage("assets/images/error.png"),
                              fit: BoxFit.cover)),
                    )),
                    Flexible(
                        child: Container(
                      margin: const EdgeInsets.only(
                          left: 15, right: 15, bottom: 16),
                      child: const Text(
                        "Essayons a nouveau de charger votre données",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    )),
                    Flexible(
                        child: Container(
                      margin: const EdgeInsets.only(
                          left: 15, right: 15, bottom: 20),
                      child: const Text(
                        "une erreur s'est produit lors du chargement de vos données. Appuyer sur Réessayer pour charger a nouveau vos données.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16,
                            height: 1.3,
                            fontWeight: FontWeight.w500),
                      ),
                    )),
                    Flexible(
                        child: SizedBox(
                            width: 120,
                            height: 50,
                            child: TextButton(
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all(
                                    const Color.fromARGB(255, 0, 87, 209)),
                              ),
                              onPressed: () => setState(() {}),
                              child: const Text("Réessayer",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                            )))
                  ],
                ),
              );
            } else if (snapshot.hasData) {
              if (snapshot.data!.isEmpty) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(
                        bottom: 8,
                      ),
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: const DecorationImage(
                              image:
                                  AssetImage("assets/images/empty-folder.png"),
                              fit: BoxFit.cover)),
                    ),
                    const SizedBox(
                      width: 250,
                      child: Text(
                        'There is no item available for this category.',
                        style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontSize: 18,
                            fontWeight: FontWeight.normal),
                        textAlign: TextAlign.center,
                      ),
                    )
                  ],
                );
              }
              return GridView(
                padding: const EdgeInsets.all(8),
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 15.0,
                  crossAxisSpacing: 20.0,
                  childAspectRatio: 0.8,
                ),
                children: List<Widget>.generate(
                  snapshot.data!.length,
                  (int index) {
                    final int count = snapshot.data!.length;
                    final Animation<double> animation =
                        Tween<double>(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                        parent: widget.animationController!,
                        curve: Interval((1 / count) * index, 1.0,
                            curve: Curves.fastOutSlowIn),
                      ),
                    );
                    widget.animationController?.forward();
                    return ObjectsView(
                      object3d: snapshot.data![index],
                      animation: animation,
                      animationController: widget.animationController,
                    );
                  },
                ),
              );
            }
            return Container();
          },
        ));
  }
}

class ObjectsView extends StatelessWidget {
  const ObjectsView(
      {Key? key,
      this.object3d,
      this.animationController,
      this.animation,
      this.callback})
      : super(key: key);

  final VoidCallback? callback;
  final ThreeDObject? object3d;
  final AnimationController? animationController;
  final Animation<double>? animation;

  @override
  Widget build(BuildContext context) {
    var object3dProvider = Provider.of<DataCenter>(context, listen: false);
    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 50 * (1.0 - animation!.value), 0.0),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              splashColor: const Color.fromARGB(0, 255, 0, 0),
              onTap: () {
                //TODO: navigate to object screen
                object3dProvider.setCurretntObject3d(object3d!);
                Navigator.push<dynamic>(
                    context,
                    MaterialPageRoute<dynamic>(
                        builder: (BuildContext context) =>
                            ObjectViewScreen(object3d: object3d!)));
              },
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color:
                          const Color.fromRGBO(58, 81, 96, 1).withOpacity(0.08),
                      offset: const Offset(-6.1, 6.1),
                      blurRadius: 4.0,
                    ),
                    // BoxShadow(
                    // color: Color.fromARGB(255, 255, 255, 255),

                    // offset: const Offset(1.1, 1.1),
                    // blurRadius: 8.0),
                  ],
                  border: Border.all(
                      color: const Color.fromARGB(193, 212, 224, 230),
                      width: 2),
                  color: const Color.fromARGB(193, 255, 255, 255),
                  borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                  // border: new Border.all(
                  //     color: DesignCourseAppTheme.notWhite),
                ),
                child: Column(
                  children: <Widget>[
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 8, left: 16, right: 16, bottom: 8),
                            child: Text(
                              object3d!.name,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              maxLines: 1,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  letterSpacing: 0.27,
                                  color: Color(0xFF253840)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(193, 212, 224, 230),
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(5.0),
                              bottomRight: Radius.circular(5.0)),
                          // border: new Border.all(
                          //     color: DesignCourseAppTheme.notWhite),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 8, right: 4, left: 4, bottom: 8),
                          child: Hero(
                            tag: object3d!.image,
                            child: Container(
                              // margin: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                      //image: AssetImage(category!.image),
                                      image: NetworkImage(
                                          "${Endpoints.baseUrl}/files/download/${object3d!.image}"),
                                      fit: BoxFit.cover)),
                            ),
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
                              //TODO:
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
                                              //TODO:

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
                        //TODO:
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
