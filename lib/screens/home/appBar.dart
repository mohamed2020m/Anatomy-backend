import 'package:flutter/material.dart';

import '../search/searchScreen.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
      width: size.width,
      // height: size.height / 9,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: const Text('Explorer',
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontSize: 30,
                    fontWeight: FontWeight.bold)),
          ),
          SizedBox(
              height: size.height / 18,
              child: InkWell(
                  // ignore: avoid_print
                  //TODO:

                  onTap: () {
                    //   if(Provider.of<CollectionProvider>(context,listen: false).isDataExist){
                    //      Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => SearchScreen()),
                    //   );
                    //   }
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SearchScreen()),
                    );
                  },
                  child: IgnorePointer(
                    child: TextField(
                      readOnly: true,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color.fromARGB(255, 242, 242, 242),
                          contentPadding: const EdgeInsets.all(10),
                          suffixIcon: const Icon(
                            Icons.search,
                            color: Color.fromARGB(255, 144, 144, 144),
                            size: 24,
                            textDirection: TextDirection.ltr,
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none),
                          hintText: "Search for something",
                          hintStyle: const TextStyle(
                              letterSpacing: .5,
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                              color: Color.fromARGB(255, 144, 144, 144))),
                    ),
                  )))
        ],
      ),
    );
  }
}
