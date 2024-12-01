import 'package:flutter/material.dart';
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
          // IconButton(
          //   icon: const Icon(
          //     Icons.person_outline_rounded,
          //     color: Color(0xFF6D83F2),
          //     size: 30,
          //   ),
          //   onPressed: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => const Profil()),
          //     );
          //   },
          // ),
          Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                // color: Colors.grey[200],
                color: const Color(0xFF6D83F2),
                border: Border.all(
                  color: const Color.fromARGB(255, 255, 255, 255),
                )),
            child: IconButton(
              icon: const Icon(
                Icons.person_outline_rounded,
                // color: Color(0xFF6D83F2),
                color: Colors.white,
                size: 30,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Profil()),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
