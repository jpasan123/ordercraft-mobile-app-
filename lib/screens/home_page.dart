import 'package:flutter/material.dart';
import 'package:myapp/models/product_model.dart';
import 'package:myapp/screens/CategoryProductPage.dart';
import 'package:myapp/screens/product_page.dart';
import 'package:myapp/widgets/cart_button.dart';
import 'package:myapp/widgets/drawer_menu.dart';
import 'package:myapp/widgets/notification_bell.dart';
import 'package:myapp/widgets/product_tile.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'dart:math' as math;

class HomePage extends StatefulWidget {
  final List<Product> products; // Accepting the list of products via constructor

  HomePage({required this.products}); // Modified constructor

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  String? _username;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _username = ModalRoute.of(context)?.settings.arguments as String?;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false, // Removes the back button
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple.withOpacity(0.7), Colors.blue.withOpacity(0.7)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Row(
          children: [
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _animation.value * 0.1,
                  child: Image.asset(
                    'assets/images/ordercraft.png',
                    height: 100,
                    errorBuilder: (context, error, stackTrace) {
                      print('Error loading image: $error');
                      return Icon(Icons.error, color: Colors.white, size: 40);
                    },
                  ),
                );
              },
            ),
            SizedBox(width: 10),
            Text(
              'OrderCraft',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 24,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
        actions: [
          CartButton(),
          NotificationBell(),
          _username == null
              ? PopupMenuButton<String>(
                  icon: Icon(Icons.person, color: Color.fromARGB(255, 252, 117, 7)),
                  onSelected: (value) {
                    if (value == 'Login') {
                      Navigator.pushNamed(context, '/login');
                    } else if (value == 'Register') {
                      Navigator.pushNamed(context, '/register');
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(value: 'Login', child: Text('Login')),
                    PopupMenuItem(value: 'Register', child: Text('Register')),
                  ],
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Center(
                    child: Text('Hello, $_username', style: TextStyle(color: Colors.white)),
                  ),
                ),
        ],
      ),
      drawer: DrawerMenu(), // Drawer Menu for side navigation
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.purple[50]!, Colors.blue[50]!, Colors.white],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              SearchBar(),
              CategoryList(),
              Expanded(
                child: ProductGrid(products: widget.products), // Pass products to ProductGrid
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search products...',
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide.none,
          ),
          prefixIcon: Icon(Icons.search, color: Colors.purple),
          suffixIcon: Icon(Icons.mic, color: Colors.purple),
          hintStyle: TextStyle(color: Colors.grey[400]),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide(color: Colors.purple.withOpacity(0.3), width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide(color: Colors.purple, width: 2),
          ),
        ),
      ),
    );
  }
}

class CategoryList extends StatefulWidget {
  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _scaleAnimations;
  late List<Animation<double>> _rotationAnimations;
  late List<Animation<Color?>> _colorAnimations;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  final List<Map<String, dynamic>> categories = [
    {'name': 'Electronics', 'icon': Icons.devices},
    {'name': 'Clothing', 'icon': Icons.checkroom},
    {'name': 'Books', 'icon': Icons.book},
    {'name': 'Home', 'icon': Icons.home},
    {'name': 'Sports', 'icon': Icons.sports_soccer},
  ];

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      categories.length,
      (index) => AnimationController(
        duration: Duration(milliseconds: 800 + (index * 100)),
        vsync: this,
      )..repeat(reverse: true),
    );

    _scaleAnimations = _controllers.map((controller) =>
      Tween<double>(begin: 0.8, end: 1.1).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOutBack)
      )
    ).toList();

    _rotationAnimations = _controllers.map((controller) =>
      Tween<double>(begin: -0.05, end: 0.05).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOutSine)
      )
    ).toList();

    _colorAnimations = _controllers.map((controller) =>
      ColorTween(begin: Colors.purple, end: Colors.blue).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOutSine)
      )
    ).toList();

    _pulseController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOutSine)
    );

    // Staggered start for controllers
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 150), () {
        _controllers[i].forward();
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100, // Slightly reduced the container height to fit smaller icons
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: GestureDetector(
              onTap: () {
                // Navigate to filtered product list
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CategoryProductPage(
                      category: categories[index]['name'],
                    ),
                  ),
                );
              },
              child: AnimatedBuilder(
                animation: Listenable.merge([_controllers[index], _pulseController]),
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _rotationAnimations[index].value,
                    child: Transform.scale(
                      scale: _scaleAnimations[index].value,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 65,  // Reduced width
                            height: 65,  // Reduced height
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  _colorAnimations[index].value ?? Colors.purple,
                                  Colors.blue,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: (_colorAnimations[index].value ?? Colors.purple).withOpacity(0.5),
                                  spreadRadius: 2 * _pulseAnimation.value,
                                  blurRadius: 10 * _pulseAnimation.value,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: 60,  // Adjusted to match reduced icon size
                                  height: 60,  // Adjusted to match reduced icon size
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                Icon(
                                  categories[index]['icon'],
                                  color: _colorAnimations[index].value ?? Colors.purple,
                                  size: 35,  // Reduced icon size
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 6),  // Reduced spacing between icon and label
                          Text(
                            categories[index]['name'],
                            style: TextStyle(
                              color: _colorAnimations[index].value ?? Colors.purple[700],
                              fontWeight: FontWeight.bold,
                              fontSize: 13,  // Slightly smaller font size
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}


class ProductGrid extends StatelessWidget {
  final List<Product> products;

  ProductGrid({required this.products});

  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
      child: GridView.builder(
        padding: EdgeInsets.all(16),
        itemCount: products.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemBuilder: (context, index) {
          final product = products[index]; 
          return AnimationConfiguration.staggeredGrid(
            position: index,
            duration: const Duration(milliseconds: 375),
            columnCount: 2,
            child: ScaleAnimation(
              child: FadeInAnimation(
                child: GestureDetector(
                  onTap: () {
                    // Navigate to ProductPage with the selected product
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductPage(product: product),
                      ),
                    );
                  },
                  child: ProductTile(
                    product: product,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
