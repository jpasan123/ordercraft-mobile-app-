import 'package:flutter/material.dart';
import 'package:myapp/models/product_model.dart'; // Import the product model
import 'package:myapp/screens/CategoryProductPage.dart';
import 'package:myapp/screens/home_page.dart';
import 'package:myapp/screens/login_page.dart';
import 'package:myapp/screens/register_page.dart';
import 'dart:async'; // For the timer in the splash screen
import 'dart:math' as math;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Product> products = [
      Product(
        id: '1',
        name: 'Bycycle',
        price: 580.99,
        imageUrl: 'assets/images/product1.png',
        description: 'This is a great product!',
      ),
      Product(
        id: '2',
        name: 'Trousers',
        price: 100.99,
        imageUrl: 'assets/images/product2.png',
        description: 'This is another great product!',
      ),
      Product(
        id: '3',
        name: 'I Phone 16 pro',
        price: 150.99,
        imageUrl: 'assets/images/product3.png',
        description: 'This is an even better product!',
      ),
      Product(
        id: '4',
        name: 'Nike Shoes',
        price: 67.00,
        imageUrl: 'assets/images/product4.png',
        description: 'This is an even better product!',
      ),
      Product(
        id: '5',
        name: 'Addidas Cap',
        price: 45.00,
        imageUrl: 'assets/images/product5.png',
        description: 'This is an even better product!',
      ),
      Product(
        id: '6',
        name: 'SS Leather Bat',
        price: 75.99,
        imageUrl: 'assets/images/product6.png',
        description: 'This is an even better product!',
      ),
      Product(
        id: '7',
        name: 'Asus TUF Lap',
        price: 1200.99,
        imageUrl: 'assets/images/product7.png',
        description: 'This is an even better product!',
      ),
      Product(
        id: '8',
        name: 'Lenovo L0Q Lap',
        price: 1000.99,
        imageUrl: 'assets/images/product8.png',
        description: 'This is an even better product!',
      ),
    ];

    return MaterialApp(
      title: 'OrderCraft',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        hintColor: Colors.blue,
        fontFamily: 'Roboto',
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          titleLarge: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          bodyMedium: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.purple,
          textTheme: ButtonTextTheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          filled: true,
          fillColor: Colors.grey[200],
        ),
      ),
      initialRoute: '/', // SplashScreen will be the initial route
      routes: {
        '/': (context) => EnhancedSplashScreen(), // Splash screen as initial page
        '/login': (context) => LoginPage(),
        '/home': (context) => HomePage(products: products), // Pass the product list to HomePage
         '/category': (context) => CategoryProductPage(category: '',), // Category product page route
        '/register': (context) => RegisterPage(),
      },
    );
  }
}

// Define the icon-building widgets here
Widget _buildShoppingCart() {
  return Icon(Icons.shopping_cart, size: 50, color: Colors.white);
}

Widget _buildDeliveryTruck() {
  return Icon(Icons.local_shipping, size: 50, color: Colors.white);
}

Widget _buildMobilePhone() {
  return Icon(Icons.smartphone, size: 50, color: Colors.white);
}

Widget _buildCreditCard() {
  return Icon(Icons.credit_card, size: 50, color: Colors.white);
}

Widget _buildGift() {
  return Icon(Icons.card_giftcard, size: 50, color: Colors.white);
}

// SplashScreen widget definition
class EnhancedSplashScreen extends StatefulWidget {
  @override
  _EnhancedSplashScreenState createState() => _EnhancedSplashScreenState();
}

class _EnhancedSplashScreenState extends State<EnhancedSplashScreen> with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _backgroundController;
  late AnimationController _particleController;
  late Animation<double> _logoAnimation;
  late Animation<double> _fadeAnimation;
  late List<AnimationController> _elementControllers;
  late List<Particle> _particles;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..forward();

    _logoAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _logoController, curve: Interval(0.5, 1, curve: Curves.easeIn)),
    );

    _backgroundController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();

    _particleController = AnimationController(
      duration: const Duration(seconds: 15),
      vsync: this,
    )..repeat();

    _elementControllers = List.generate(
      5,
      (index) => AnimationController(
        duration: Duration(seconds: 4 + index),
        vsync: this,
      )..repeat(reverse: true),
    );

    _particles = List.generate(50, (_) => Particle());

    Timer(Duration(seconds: 8), () {
      Navigator.pushReplacementNamed(context, '/home');  // Changed to '/home'
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _backgroundController.dispose();
    _particleController.dispose();
    for (var controller in _elementControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Animated Background
          AnimatedBuilder(
            animation: _backgroundController,
            builder: (context, child) {
              return CustomPaint(
                painter: EnhancedBackgroundPainter(_backgroundController.value),
              );
            },
          ),

          // Particles
          AnimatedBuilder(
            animation: _particleController,
            builder: (context, child) {
              return CustomPaint(
                painter: ParticlePainter(_particles, _particleController.value),
              );
            },
          ),

          // Animated Elements
          ...List.generate(5, (index) {
            return Positioned(
              left: MediaQuery.of(context).size.width * (index * 0.2),
              bottom: MediaQuery.of(context).size.height * 0.1,
              child: EnhancedAnimatedElement(controller: _elementControllers[index], index: index),
            );
          }),

          // Logo and Text
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated Logo
                AnimatedBuilder(
                  animation: _logoAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _logoAnimation.value,
                      child: ShaderMask(
                        shaderCallback: (Rect bounds) {
                          return LinearGradient(
                            colors: [Colors.purple, Colors.blue],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ).createShader(bounds);
                        },
                        child: Image.asset(
                          'assets/images/ordercraft.png',
                          width: 200,
                          height: 200,
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 30),
                // Fading Text
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      ShaderMask(
                        shaderCallback: (Rect bounds) {
                          return LinearGradient(
                            colors: [Colors.purple, Colors.blue],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ).createShader(bounds);
                        },
                        child: Text(
                          'OrderCraft',
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                blurRadius: 10.0,
                                color: Colors.purple,
                                offset: Offset(5.0, 5.0),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Deal With Us, Make Your Profit',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
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

class EnhancedAnimatedElement extends StatelessWidget {
  final AnimationController controller;
  final int index;

  EnhancedAnimatedElement({required this.controller, required this.index});

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: Tween<double>(begin: 0.8, end: 1.2).animate(
        CurvedAnimation(parent: controller, curve: Curves.elasticInOut),
      ),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: index.isEven ? Colors.purple : Colors.blue,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 5,
              blurRadius: 10,
            ),
          ],
        ),
        child: _buildElement(),
      ),
    );
  }

  Widget _buildElement() {
    switch (index) {
      case 0:
        return _buildShoppingCart();
      case 1:
        return _buildDeliveryTruck();
      case 2:
        return _buildMobilePhone();
      case 3:
        return _buildCreditCard();
      case 4:
        return _buildGift();
      default:
        return Container();
    }
  }
}

class Particle {
  double x;
  double y;
  double size;
  double speed;
  double angle;

  Particle()
      : x = math.Random().nextDouble() * 1.0,
        y = math.Random().nextDouble() * 1.0,
        size = math.Random().nextDouble() * 3 + 1,
        speed = math.Random().nextDouble() * 0.005 + 0.002,
        angle = math.Random().nextDouble() * math.pi * 2;
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double animationValue;

  ParticlePainter(this.particles, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.7);

    for (var particle in particles) {
      final double dx = particle.x * size.width;
      final double dy = particle.y * size.height;

      canvas.drawCircle(Offset(dx, dy), particle.size, paint);

      particle.x += math.cos(particle.angle) * particle.speed;
      particle.y += math.sin(particle.angle) * particle.speed;

      if (particle.x < 0 || particle.x > 1) particle.x = math.Random().nextDouble();
      if (particle.y < 0 || particle.y > 1) particle.y = math.Random().nextDouble();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class EnhancedBackgroundPainter extends CustomPainter {
  final double animationValue;

  EnhancedBackgroundPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final gradient = LinearGradient(
      colors: [
        Colors.purple.shade300,
        Colors.blue.shade300,
        Colors.purple.shade900,
      ],
      stops: [
        (0.5 + animationValue / 2) % 1.0,
        animationValue,
        (animationValue + 0.5) % 1.0
      ],
    );
    final paint = Paint()..shader = gradient.createShader(rect);
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
