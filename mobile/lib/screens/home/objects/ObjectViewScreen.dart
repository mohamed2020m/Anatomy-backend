import 'dart:async';
import 'package:TerraViva/controller/FavouriteController.dart';
import 'package:TerraViva/controller/threeDObjectController.dart';
import 'package:TerraViva/models/ThreeDObject.dart';
import 'package:babylonjs_viewer/babylonjs_viewer.dart';
import 'package:circular_menu/circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import '../../../controller/noteController.dart';
import '../../../models/note.dart';
import '../../../network/Endpoints.dart';
import '../../../provider/dataCenter.dart';
import '../../../service/DatabaseService.dart';
import '../../../service/serviceLocator.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ObjectViewScreen extends StatefulWidget {
  ObjectViewScreen({Key? key, required this.object3d}) : super(key: key);
  late ThreeDObject object3d;

  @override
  _ObjectViewScreenState createState() => _ObjectViewScreenState();
}

class _ObjectViewScreenState extends State<ObjectViewScreen> {
  GlobalKey<CircularMenuState> key = GlobalKey<CircularMenuState>();
  final TextEditingController noteController = TextEditingController();
  bool isFavorite = false; // Track whether the item is marked as fouvourite.

  List<Note> userNotes = [];
  final NoteController noteControllerApi = getIt<NoteController>();
  final ThreeDObjectController threeDObjectController =
      getIt<ThreeDObjectController>();
  final FavouriteController favouriteController = FavouriteController();
  DatabaseService dbService = DatabaseService.instance;

  // Flutter3DController controller = Flutter3DController();

  @override
  void initState() {
    //You can download a single file

    getNotes();
    checkIfFavorite();
    super.initState();
    // controller.onModelLoaded.addListener(() {
    //   debugPrint('model is loaded : ${controller.onModelLoaded.value}');
    // });
  }

  Future<void> _refreshNotes() async {
    setState(() {});
  }

  Future<void> getNotes() async {
    userNotes =
        await noteControllerApi.getNotesByThreeDObjects(widget.object3d.id);
  }

  Future<void> checkIfFavorite() async {
    try {
      // Fetch the list of all favourites
      final favourites = await favouriteController.getAllFavourites();

      // Check if the current object's ID is in the list of favorites.
      setState(() {
        isFavorite = favourites.any((favourite) => favourite.threeDObjectId == widget.object3d.id);
      });
    } catch (e) {
      print("Error fetching favourites: $e");
    }
  }

  void toggleFavorite(String objectId, String objectName) async {
    setState(() {
      isFavorite = !isFavorite; // Toggle the favorite state.
    });

    if (isFavorite) {
      await addToFavorites(objectId, objectName);
    } else {
      await removeFromFavorites(objectId, objectName);
    }
  }

  Future<void> addToFavorites(String objectId, String objectName) async {
    try {
      await threeDObjectController.addToFavourites(objectId);
      showSnackbar(
        message: '$objectName added to favorites',
        icon: Icons.check_circle,
        iconColor: Colors.green,
      );
    } catch (e) {
      showSnackbar(
        message: 'An error occurred while adding to favorites.',
        icon: Icons.error,
        iconColor: Colors.red,
      );
    }
  }

  Future<void> removeFromFavorites(String objectId, String objectName) async {
    try {
      await threeDObjectController.removeFromFavorites(objectId);
      showSnackbar(
        message: '$objectName removed from favorites',
        icon: Icons.remove_circle,
        iconColor: Colors.red,
      );
    } catch (e) {
      showSnackbar(
        message: 'An error occurred while removing from favorites.',
        icon: Icons.error,
        iconColor: Colors.red,
      );
    }
  }

  void showSnackbar({
    required String message,
    required IconData icon,
    required Color iconColor,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: iconColor),
            const SizedBox(width: 10),
            Expanded(child: Text(message)),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.white,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var object3dProvider = Provider.of<DataCenter>(context, listen: true);

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color(0xFF6D83F2),
      ),
    );

    return ScaffoldMessenger(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF6D83F2),
          actions: [
            IconButton(
              icon: Animate(
                effects: const [
                  ScaleEffect(duration: Duration(milliseconds: 25)),
                  FadeEffect(duration: Duration(milliseconds: 25))
                ],
                child: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : Colors.white,
                ),
              ),
              onPressed: () => toggleFavorite(
                object3dProvider.currentObject3d.id.toString(),
                object3dProvider.currentObject3d.name,
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.info,
                color: Colors.white,
              ),
              onPressed: () {
                showModalBottomSheet<void>(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width,
                    minWidth: MediaQuery.of(context).size.width,
                    maxHeight: MediaQuery.of(context).size.height / 3,
                    minHeight: MediaQuery.of(context).size.height / 3,
                  ),
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24.0),
                      topRight: Radius.circular(24.0),
                    ),
                  ),
                  context: context,
                  builder: (BuildContext context) {
                    return SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(
                                bottom: 10, left: 16, top: 10),
                            height: 30,
                            child: const Text('Description',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold)),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                bottom: 10, left: 16, top: 10),
                            child: Text(
                                object3dProvider.currentObject3d.description,
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400)),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
          title: Text(
            object3dProvider.currentObject3d.name,
            style: const TextStyle(
                fontWeight: FontWeight.w900, fontSize: 20, color: Colors.white),
          ),
          centerTitle: true,
          toolbarHeight: 50,
          // backgroundColor: const Color.fromARGB(255, 246, 246, 246),
          shadowColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          automaticallyImplyLeading: false,
        ),
        body: Center(
            child: BabylonJSViewer(
                src:
                    '${Endpoints.baseUrl}/files/download/${widget.object3d.object}')),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xFF6D83F2),
          shape: const CircleBorder(),
          onPressed: () {
            // Directly show the notes modal without the save button.
            showNotesModal(context);
          },
          child: const Icon(Icons.note_add, color: Colors.white),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      ),
    );
  }

  void showNotesModal(BuildContext context) {
    showModalBottomSheet<void>(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width,
        minWidth: MediaQuery.of(context).size.width,
        maxHeight: MediaQuery.of(context).size.height - 120,
        minHeight: MediaQuery.of(context).size.height - 120,
      ),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
      ),
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Scaffold(
              resizeToAvoidBottomInset:
                  true, // Ensures content resizes when keyboard appears
              body: GestureDetector(
                onTap: () {
                  // Dismiss keyboard when tapping outside
                  FocusScope.of(context).unfocus();
                },
                child: SingleChildScrollView(
                  // Allows the content to scroll
                  child: Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Column(
                      children: [
                        // Header Section - Title and Close Button
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'My Notes',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.close, color: Colors.black87),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                            ],
                          ),
                        ),

                        // List of Notes
                        SizedBox(
                          height: MediaQuery.of(context).size.height - 320,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: userNotes.length,
                            itemBuilder: (ctx, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 16.0),
                                child: Card(
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  color: Colors.white,
                                  child: Dismissible(
                                    background: _dismissBackground(Colors.green,
                                        "Favorite", Icons.favorite),
                                    secondaryBackground: _dismissBackground(
                                        Colors.red, "Delete", Icons.delete),
                                    confirmDismiss:
                                        (DismissDirection direction) async {
                                      if (direction ==
                                          DismissDirection.startToEnd) {
                                        return await _showConfirmationDialog(
                                            context,
                                            "Move to Favorites",
                                            "Are you sure you want to move this note to favorites?",
                                            index);
                                      } else {
                                        return await _showConfirmationDialog(
                                            context,
                                            "Remove Note",
                                            "Are you sure you want to remove this note?",
                                            index);
                                      }
                                    },
                                    key: Key(userNotes[index].id.toString()),
                                    child: ListTile(
                                      contentPadding: const EdgeInsets.all(15),
                                      title: ReadMoreText(
                                        userNotes[index].content,
                                        trimLines: 3,
                                        trimMode: TrimMode.Line,
                                        trimCollapsedText: 'Show more',
                                        trimExpandedText: 'Show less',
                                        moreStyle:
                                            const TextStyle(color: Colors.blue),
                                        lessStyle:
                                            const TextStyle(color: Colors.blue),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        // New Note Input Section
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12.0, horizontal: 20.0),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(30),
                              bottomRight: Radius.circular(30),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: noteController,
                                  minLines: 1,
                                  maxLines: 3,
                                  decoration: InputDecoration(
                                    hintText: 'Add a new note...',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    contentPadding: const EdgeInsets.all(12),
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder(),
                                  backgroundColor: noteController.text.isEmpty
                                      ? Colors.grey
                                      : const Color(0xFF6D83F2),
                                  padding: const EdgeInsets.all(12),
                                ),
                                onPressed: noteController.text.isEmpty
                                    ? null
                                    : () async {
                                        userNotes.add(
                                            await noteControllerApi.addNewNote(
                                          noteController.text,
                                          widget.object3d.id,
                                        ));
                                        noteController.clear();
                                        setState(() {});
                                        _refreshNotes();
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                'Note created successfully!'),
                                            backgroundColor: Colors.green,
                                          ),
                                        );
                                      },
                                child: const Text(
                                  "Save",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
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
      },
    );
  }

  Widget _dismissBackground(Color color, String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
      ),
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          Icon(icon, color: Colors.white),
          SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Future<bool?> _showConfirmationDialog(
      BuildContext context, String title, String content, int index) {
    bool isDeleting = false; // Add this state variable
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            ElevatedButton(
              onPressed: isDeleting
                  ? null // Disable button while deleting
                  : () async {
                      setState(() {
                        isDeleting = true; // Show loading spinner
                      });

                      await noteControllerApi.deleteNote(userNotes[index].id);
                      await getNotes();

                      setState(() {
                        isDeleting = false; // Hide loading spinner
                      });

                      Navigator.of(context).pop(true);
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: isDeleting
                  ? CircularProgressIndicator(
                      color: Colors.white, // Adjust spinner color if needed
                    )
                  : const Text(
                      "Yes",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(false),
              child:
                  const Text("No", style: const TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }
}
