// import 'package:flutter/material.dart';

// import '../search/searchScreen.dart';

// class CustomAppBar extends StatelessWidget {
//   const CustomAppBar({
//     Key? key,
//     required this.size,
//   }) : super(key: key);

//   final Size size;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
//       width: size.width,
//       // height: size.height / 9,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             margin: const EdgeInsets.only(bottom: 10),
//             child: const Text('Terrviva',
//                 textAlign: TextAlign.left,
//                 style: TextStyle(
//                     color: Color.fromARGB(255, 0, 0, 0),
//                     fontSize: 30,
//                     fontWeight: FontWeight.bold)),
//           ),
//           SizedBox(
//               height: size.height / 18,
//               child: InkWell(
//                   onTap: () {
//                     //   if(Provider.of<CollectionProvider>(context,listen: false).isDataExist){
//                     //      Navigator.push(
//                     //     context,
//                     //     MaterialPageRoute(
//                     //         builder: (context) => SearchScreen()),
//                     //   );
//                     //   }
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => const SearchScreen()),
//                     );
//                   },
//                   child: IgnorePointer(
//                     child: TextField(
//                       readOnly: true,
//                       decoration: InputDecoration(
//                           filled: true,
//                           fillColor: const Color.fromARGB(255, 242, 242, 242),
//                           contentPadding: const EdgeInsets.all(10),
//                           suffixIcon: const Icon(
//                             Icons.search,
//                             color: Color.fromARGB(255, 144, 144, 144),
//                             size: 24,
//                             textDirection: TextDirection.ltr,
//                           ),
//                           border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(12),
//                               borderSide: BorderSide.none),
//                           hintText: "Search for something",
//                           hintStyle: const TextStyle(
//                               letterSpacing: .5,
//                               fontSize: 16,
//                               fontWeight: FontWeight.w300,
//                               color: Color.fromARGB(255, 144, 144, 144))),
//                     ),
//                   )))
//         ],
//       ),
//     );
//   }
// }


// import 'package:flutter/material.dart';

// import '../search/searchScreen.dart';

// class CustomAppBar extends StatelessWidget {
//   const CustomAppBar({
//     Key? key,
//     required this.size,
//   }) : super(key: key);

//   final Size size;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
//       width: size.width,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Gradient title with custom font style
//           Container(
//             margin: const EdgeInsets.only(bottom: 20),
//             child: ShaderMask(
//               shaderCallback: (bounds) => const LinearGradient(
//                 colors: [Color(0xFF6D83F2), Color(0xFFA393EB)],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ).createShader(bounds),
//               child: const Text(
//                 'Terraviva',
//                 style: TextStyle(
//                   fontSize: 36,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                   letterSpacing: 1.5,
//                   fontFamily: 'Lora',
//                 ),
//               ),
//             ),
//           ),
//           // Enhanced search bar with elevated shadow and rounded corners
//           SizedBox(
//             height: size.height / 16,
//             child: InkWell(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => const SearchScreen()),
//                 );
//               },
//               child: IgnorePointer(
//                 child: TextField(
//                   readOnly: true,
//                   decoration: InputDecoration(
//                     filled: true,
//                     fillColor: const Color(0xFFF5F6FA),
//                     contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//                     suffixIcon: const Icon(
//                       Icons.search,
//                       color: Color(0xFF7D8596),
//                       size: 28,
//                     ),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(30),
//                       borderSide: BorderSide.none,
//                     ),
//                     hintText: "Search and learn...",
//                     hintStyle: const TextStyle(
//                       letterSpacing: 0.8,
//                       fontSize: 16,
//                       fontWeight: FontWeight.w400,
//                       color: Color(0xFF7D8596),
//                       fontFamily: 'Poppins', 
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import '../search/searchScreen.dart';
import '../profil/Profil.dart';

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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Gradient title with custom font style
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Color(0xFF6D83F2), Color(0xFFA393EB)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(bounds),
            child: const Text(
              'Terraviva',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.5,
                // fontFamily: 'Lora', 
                fontFamily: 'Anton',
              ),
            ),
          ),
          // Profile Icon Button
          IconButton(
            icon: const Icon(
              Icons.person_outline_rounded,
              color: Color(0xFF6D83F2),
              size: 30,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Profil()),
              );
            },
          ),
        ],
      ),
    );
  }
}
