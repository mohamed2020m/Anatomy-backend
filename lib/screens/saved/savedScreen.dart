import 'dart:io';
import 'package:TerraViva/controller/noteController.dart';
import 'package:TerraViva/models/ThreeDObject.dart';
import 'package:TerraViva/models/note.dart';
import 'package:TerraViva/screens/home/objects/ObjectViewScreen.dart';
import 'package:TerraViva/screens/home/subCategory/CategoryScreen.dart';
import 'package:TerraViva/screens/saved/SavedObjectViewScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import '../../../app_skoleton/appSkoleton.dart';
import '../../../controller/objectsParCategoryController.dart';
import '../../../network/Endpoints.dart';
import '../../../provider/dataCenter.dart';
import '../../../service/serviceLocator.dart';

class SavedNotesScreen extends StatefulWidget {
  const SavedNotesScreen({Key? key}) : super(key: key);

  @override
  _SavedScreenScreenState createState() => _SavedScreenScreenState();
}

class _SavedScreenScreenState extends State<SavedNotesScreen>
    with TickerProviderStateMixin {
  AnimationController? animationController;

  final objectsController = getIt<ObjectsParCategoryController>();
  final noteController = getIt<NoteController>();

  // DatabaseService dbService = DatabaseService.instance;
  bool _isRefreshing = false;

  Future<void> _refreshNotes() async {
    setState(() {
      _isRefreshing = true;
    });
    try {
      await noteController.getAllNotes();
    } catch (e) {
      // Optional: show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to refresh: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isRefreshing = false;
      });
    }
  }

  @override
  void initState() {
    getCollection();
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    super.initState();
  }

  Future getCollection() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color(0xFF6D83F2),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        backgroundColor: const Color(0xFF6D83F2),
        shadowColor: Colors.transparent,
        title: const Text(
          "Saved Notes",
          style: TextStyle(
              fontWeight: FontWeight.w900, fontSize: 20, color: Colors.white),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: RefreshIndicator(
        onRefresh: () => getCollection(),
        child: Padding(
          padding: const EdgeInsets.only(top: 32),
          child: CoursViewRout(animationController: animationController),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _isRefreshing ? null : _refreshNotes,
        backgroundColor: _isRefreshing ? Colors.grey : const Color(0xFF6D83F2),
        child: _isRefreshing
          ? const CircularProgressIndicator(color: Colors.white)
          : const Icon(Icons.refresh, color: Colors.white),
      ),
    );
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
  final noteController = getIt<NoteController>();

  // DatabaseService dbService = DatabaseService.instance;

  Future<void> _refreshNotes() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshNotes,
      child: Center(
        child: Container(
          margin: const EdgeInsets.only(left: 15, right: 15),
          child: FutureBuilder(
            future: noteController.getAllNotes(),
            builder: (context, snapshot) {
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
                // Error handling code remains the same
                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Error UI remains the same
                      Flexible(
                          child: SizedBox(
                              width: 120,
                              height: 50,
                              child: TextButton(
                                style: ButtonStyle(
                                  backgroundColor: WidgetStateProperty.all(
                                      const Color.fromARGB(255, 0, 87, 209)),
                                ),
                                onPressed: () => _refreshNotes(),
                                child: const Text("Retry",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                              ))),
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
                                image: AssetImage(
                                    "assets/images/empty-folder.png"),
                                fit: BoxFit.cover)),
                      ),
                      const SizedBox(
                        width: 250,
                        child: Text(
                          'There is no item available .',
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
                // return GridView(
                //   padding: const EdgeInsets.all(8),
                //   physics: const BouncingScrollPhysics(),
                //   scrollDirection: Axis.vertical,
                //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                //     crossAxisCount: 2,
                //     mainAxisSpacing: 15.0,
                //     crossAxisSpacing: 20.0,
                //     childAspectRatio: 0.8,
                //   ),
                //   children: List<Widget>.generate(
                //     snapshot.data!.length,
                //     (int index) {
                //       final int count = snapshot.data!.length;
                //       final Animation<double> animation =
                //           Tween<double>(begin: 0.0, end: 1.0).animate(
                //         CurvedAnimation(
                //           parent: widget.animationController!,
                //           curve: Interval((1 / count) * index, 1.0,
                //               curve: Curves.fastOutSlowIn),
                //         ),
                //       );
                //       widget.animationController?.forward();
                //       return ObjectsView(
                //         note: snapshot.data![index],
                //         object3d: snapshot.data![index].threeDObject,
                //         animation: animation,
                //         animationController: widget.animationController,
                //         onDeleteCallback: _refreshNotes,
                //       );
                //     },
                //   ),
                // );

                return GridView.builder(
                  padding: const EdgeInsets.all(8),
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 15.0,
                    crossAxisSpacing: 20.0,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
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
                      note: snapshot.data![index],
                      object3d: snapshot.data![index].threeDObject,
                      animation: animation,
                      animationController: widget.animationController,
                      onDeleteCallback: _refreshNotes,
                    );
                  },
                );
              }
              return const Center(child: Text("No data available."));
            },
          ),
        ),
      ),
    );
  }
}

class ObjectsView extends StatelessWidget {
  const ObjectsView({
    Key? key,
    this.object3d,
    this.animationController,
    this.animation,
    this.note,
    this.callback,
    this.onDeleteCallback,
  }) : super(key: key);

  final VoidCallback? callback;
  final VoidCallback? onDeleteCallback; // New callback for deletion
  final ThreeDObject? object3d;
  final Note? note;
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
            child: Container(
              decoration: BoxDecoration(
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color:
                        const Color.fromRGBO(58, 81, 96, 1).withOpacity(0.08),
                    offset: const Offset(-6.1, 6.1),
                    blurRadius: 4.0,
                  ),
                ],
                border: Border.all(
                    color: const Color.fromARGB(193, 212, 224, 230), width: 2),
                // Changed background color of the card
                color: Colors.blueGrey[50], // You can customize the color here
                borderRadius: const BorderRadius.all(Radius.circular(16.0)),
              ),
              child: Stack(
                children: [
                  Column(
                    children: <Widget>[
                      // Note Image - Expanded to fill the available space
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            // Show bottom sheet with interaction hint
                            _showInteractionBottomSheet(context);
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(193, 212, 224, 230),
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(5.0),
                                  bottomRight: Radius.circular(5.0)),
                            ),
                            child: Hero(
                              tag: object3d!.image,
                              child: Container(
                                margin:
                                    const EdgeInsets.all(0), // Remove margin
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(0), // No radius
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      "${Endpoints.baseUrl}/files/download/${object3d!.image}",
                                    ),
                                    fit: BoxFit
                                        .cover, // Ensure the image covers the area
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Note Header
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 0, left: 16, right: 16, bottom: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.view_in_ar,
                                  color: Colors.blue),
                              onPressed: () {
                                object3dProvider.setCurretntObject3d(object3d!);
                                Navigator.push<dynamic>(
                                    context,
                                    MaterialPageRoute<dynamic>(
                                      builder: (BuildContext context) =>
                                          ObjectViewScreen(
                                              object3d: object3d!),
                                    ));
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _confirmDelete(context),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showNoteDetailsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(object3d?.name ?? 'Note Details'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Object Image
                if (object3d?.image != null)
                  Container(
                    height: 200,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: NetworkImage(
                          "${Endpoints.baseUrl}/files/download/${object3d!.image}",
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                SizedBox(height: 16),
                // Note Content
                const Text(
                  'Object Description:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  object3d?.description ?? 'No additional content',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showNoteContentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Note Content'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                //   Container(
                //     height: 200,
                //     width: double.maxFinite,
                //     decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(10),
                //       image: DecorationImage(
                //         image: NetworkImage(
                //           "${Endpoints.baseUrl}/files/download/${object3d!.image}",
                //         ),
                //         fit: BoxFit.cover,
                //       ),
                //     ),
                //   ),
                // SizedBox(height: 16),
                // // Note Content
                // const Text(
                //   'Note Content: ',
                //   style: TextStyle(
                //     fontWeight: FontWeight.bold,
                //     fontSize: 16,
                //   ),
                // ),
                // const SizedBox(height: 8),
                Text(
                  note?.content ?? 'No additional content',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showInteractionBottomSheet(BuildContext context) {
    final object3dProvider = Provider.of<DataCenter>(context, listen: false);
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Interaction Options',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      IconButton(
                        icon: Icon(Icons.view_in_ar, color: Colors.blue[800]),
                        onPressed: () {
                          Navigator.pop(context);
                          object3dProvider.setCurretntObject3d(object3d!);
                          Navigator.push<dynamic>(
                            context,
                            MaterialPageRoute<dynamic>(
                                builder: (BuildContext context) =>
                                    // SavedObjectViewScreen(object3d: object3d!),
                                    ObjectViewScreen(object3d: object3d!)),
                          );
                        },
                      ),
                      Text('View 3D', style: TextStyle(color: Colors.blue[800]))
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        icon:
                            Icon(Icons.info_outline, color: Color(0xFF7D6E2E)),
                        onPressed: () {
                          // TODO: Implement details view if needed
                          Navigator.pop(context);
                          _showNoteDetailsDialog(context);
                        },
                      ),
                      const Text('Object 3D Details',
                          style: TextStyle(color: Color(0xFF7D6E2E)))
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        icon: Icon(Icons.info_sharp, color: Colors.green[800]),
                        onPressed: () {
                          // TODO: Implement details view if needed
                          Navigator.pop(context);
                          _showNoteContentDialog(context);
                        },
                      ),
                      Text('Note Details',
                          style: TextStyle(color: Colors.green[800]))
                    ],
                  ),
                ],
              ),
              // const SizedBox(height: 8),
              // Text(
              //   'Tap the image to explore your note',
              //   style: TextStyle(
              //       color: Colors.grey[600], fontStyle: FontStyle.italic),
              // )
            ],
          ),
        );
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      backgroundColor: Colors.transparent,
    );
  }

  void _confirmDelete(BuildContext context) {
    final noteController = getIt<NoteController>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Note'),
          content: const Text('Are you sure you want to delete this note?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () async {
                // Perform delete operation
                if (object3d != null) {
                  await noteController.deleteNote(note!.id);
                  Navigator.of(context).pop(); // Close dialog

                  // Call the onDeleteCallback to refresh the list
                  if (onDeleteCallback != null) {
                    onDeleteCallback!();
                  }

                  // Show SnackBar
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Note deleted successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
