// // import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

// class FlashScreen extends StatelessWidget {
//   const FlashScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       backgroundColor: Colors.white,
//       body: Center(
//           child: CupertinoActivityIndicator(
//         radius: 15,
//       )),
//     );
//   }
// }


import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    // Bounce animation for logo
    _bounceAnimation = Tween<double>(begin: 0.0, end: 20.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Pulsating background animation
          AnimatedContainer(
            duration: const Duration(seconds: 3),
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  Color.fromARGB(255, 159, 171, 233),
                  Color(0xFF6D83F2),
                ],
                stops: [0.3, 1.0],
                center: Alignment.center,
                radius: 1.5,
              ),
            ),
          ),
          // Center content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Bouncing logo
                AnimatedBuilder(
                  animation: _bounceAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, -_bounceAnimation.value),
                      child: child,
                    );
                  },
                  child: const CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage("assets/images/img_forground.png"),
                  ),
                ),
                const SizedBox(height: 20),
                // App name
                const Text(
                  "TerraViva",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                // Tagline
                const Text(
                  "Explore the world, vividly!",
                  style: TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



// import 'package:flutter/material.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({Key? key}) : super(key: key);

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _animationController;
//   late Animation<double> _bounceAnimation;

//   @override
//   void initState() {
//     super.initState();

//     // Initialize animation controller
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 2),
//     )..repeat(reverse: true);

//     // Bounce animation for logo
//     _bounceAnimation = Tween<double>(begin: 0.0, end: 20.0).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
//     );

//     // Navigate to the next screen after 5 seconds
//     Future.delayed(const Duration(seconds: 5), () {
//       if (mounted) {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => const HomePage()),
//         );
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           // Pulsating background animation
//           AnimatedContainer(
//             duration: const Duration(seconds: 3),
//             decoration: BoxDecoration(
//               gradient: RadialGradient(
//                 colors: [
//                   Colors.blue.shade200,
//                   Colors.blue.shade500,
//                 ],
//                 stops: const [0.3, 1.0],
//                 center: Alignment.center,
//                 radius: 1.5,
//               ),
//             ),
//           ),
//           // Center content
//           Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 // Bouncing logo
//                 AnimatedBuilder(
//                   animation: _bounceAnimation,
//                   builder: (context, child) {
//                     return Transform.translate(
//                       offset: Offset(0, -_bounceAnimation.value),
//                       child: child,
//                     );
//                   },
//                   child: const CircleAvatar(
//                     radius: 60,
//                     backgroundImage: AssetImage("assets/images/logo.png"),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 // App name
//                 const Text(
//                   "TerraViva",
//                   style: TextStyle(
//                     fontSize: 30,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 // Tagline
//                 const Text(
//                   "Explore the world, vividly!",
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontStyle: FontStyle.italic,
//                     color: Colors.white70,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class HomePage extends StatelessWidget {
//   const HomePage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Home Page")),
//       body: const Center(child: Text("Welcome to TerraViva!")),
//     );
//   }
// }
