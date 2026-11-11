import 'package:flutter/material.dart';

void main() {
  runApp(const ECommerceApp());
}

class ECommerceApp extends StatelessWidget {
  const ECommerceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Experiment 2: Responsive E-Commerce Catalog',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E88E5),
          brightness: Brightness.light,
        ),
      ),
      home: const ResponsiveCatalogScreen(),
    );
  }
}

/// Product data model
class Product {
  final String id;
  final String name;
  final String category;
  final double price;
  final double originalPrice;
  final double rating;
  final int reviewsCount;
  final String icon;
  final Color cardColor;
  final String tag;
  final String description;

  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.originalPrice,
    required this.rating,
    required this.reviewsCount,
    required this.icon,
    required this.cardColor,
    required this.tag,
    required this.description,
  });
}

class ResponsiveCatalogScreen extends StatefulWidget {
  const ResponsiveCatalogScreen({super.key});

  @override
  State<ResponsiveCatalogScreen> createState() => _ResponsiveCatalogScreenState();
}

class _ResponsiveCatalogScreenState extends State<ResponsiveCatalogScreen> {
  final List<Product> _allProducts = const [
    Product(
      id: '1',
      name: 'Wireless Noise-Canceling Headphones',
      category: 'Electronics',
      price: 199.99,
      originalPrice: 249.99,
      rating: 4.8,
      reviewsCount: 320,
      icon: '🎧',
      cardColor: Color(0xFFE3F2FD),
      tag: 'Best Seller',
      description: 'Ultra-crisp audio with active noise cancellation and 30-hour battery life.',
    ),
    Product(
      id: '2',
      name: 'Smart Fitness Watch Series 9',
      category: 'Wearables',
      price: 299.00,
      originalPrice: 349.00,
      rating: 4.9,
      reviewsCount: 512,
      icon: '⌚',
      cardColor: Color(0xFFF3E5F5),
      tag: 'New',
      description: 'Advanced heart-rate tracking, ECG, sleep monitoring, and bright OLED display.',
    ),
    Product(
      id: '3',
      name: 'Ultra-Slim 4K Gaming Laptop',
      category: 'Computers',
      price: 1299.99,
      originalPrice: 1499.99,
      rating: 4.7,
      reviewsCount: 140,
      icon: '💻',
      cardColor: Color(0xFFE8F5E9),
      tag: 'Hot Deal',
      description: 'Blazing-fast processor, dedicated GPU, and immersive 144Hz 4K display.',
    ),
    Product(
      id: '4',
      name: 'Mechanical Ergonomic Keyboard',
      category: 'Accessories',
      price: 89.99,
      originalPrice: 109.99,
      rating: 4.6,
      reviewsCount: 215,
      icon: '⌨️',
      cardColor: Color(0xFFFFF3E0),
      tag: 'Popular',
      description: 'Tactile hot-swappable switches, RGB backlighting, and padded wrist rest.',
    ),
    Product(
      id: '5',
      name: 'Mirrorless 4K Cinema Camera',
      category: 'Cameras',
      price: 849.50,
      originalPrice: 999.00,
      rating: 4.8,
      reviewsCount: 88,
      icon: '📷',
      cardColor: Color(0xFFEDE7F6),
      tag: 'Featured',
      description: 'Professional high-definition sensor with dual-pixel autofocus and 60fps recording.',
    ),
    Product(
      id: '6',
      name: 'Ergonomic Mesh Office Chair',
      category: 'Furniture',
      price: 249.00,
      originalPrice: 299.00,
      rating: 4.5,
      reviewsCount: 194,
      icon: '🪑',
      cardColor: Color(0xFFFBE9E7),
      tag: 'Sale',
      description: 'Dynamic lumbar support, breathable mesh fabric, and 3D adjustable armrests.',
    ),
    Product(
      id: '7',
      name: 'Smart Home Speaker & Hub',
      category: 'Electronics',
      price: 79.99,
      originalPrice: 99.99,
      rating: 4.6,
      reviewsCount: 430,
      icon: '🔊',
      cardColor: Color(0xFFE0F7FA),
      tag: 'Top Rated',
      description: 'Voice-controlled smart hub with room-filling 360-degree acoustic sound.',
    ),
    Product(
      id: '8',
      name: 'Precision Wireless Gaming Mouse',
      category: 'Accessories',
      price: 59.99,
      originalPrice: 79.99,
      rating: 4.7,
      reviewsCount: 180,
      icon: '🖱️',
      cardColor: Color(0xFFF1F8E9),
      tag: 'Trending',
      description: 'Sub-millisecond wireless latency with 26K DPI optical sensor.',
    ),
  ];

  String _selectedCategory = 'All';
  int _navIndex = 0;
  final Set<String> _cartProductIds = {};

  @override
  Widget build(BuildContext context) {
    final categories = ['All', 'Electronics', 'Wearables', 'Computers', 'Accessories', 'Cameras', 'Furniture'];
    final filtered = _selectedCategory == 'All'
        ? _allProducts
        : _allProducts.where((p) => p.category == _selectedCategory).toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        // Breakpoint definitions
        final isDesktop = screenWidth >= 1000;
        final isTablet = screenWidth >= 600 && screenWidth < 1000;
        final isMobile = screenWidth < 600;

        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          appBar: AppBar(
            title: Text(
              isMobile ? 'TechStore' : 'TechStore Catalog (Responsive)',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.white,
            foregroundColor: const Color(0xFF1E293B),
            elevation: 1,
            actions: [
              // Screen size badge indicator
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isDesktop
                      ? Colors.purple.shade50
                      : isTablet
                          ? Colors.orange.shade50
                          : Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDesktop
                        ? Colors.purple
                        : isTablet
                            ? Colors.orange
                            : Colors.blue,
                  ),
                ),
                child: Text(
                  isDesktop
                      ? 'Desktop (≥1000px)'
                      : isTablet
                          ? 'Tablet (600-999px)'
                          : 'Mobile (<600px)',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isDesktop
                        ? Colors.purple.shade800
                        : isTablet
                            ? Colors.orange.shade800
                            : Colors.blue.shade800,
                  ),
                ),
              ),
              IconButton(
                icon: Badge(
                  label: Text('${_cartProductIds.length}'),
                  isLabelVisible: _cartProductIds.isNotEmpty,
                  child: const Icon(Icons.shopping_cart_outlined),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Cart contains ${_cartProductIds.length} item(s)'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: Row(
            children: [
              // Adaptive Navigation: Rail for Desktop/Tablet
              if (!isMobile)
                NavigationRail(
                  selectedIndex: _navIndex,
                  onDestinationSelected: (idx) => setState(() => _navIndex = idx),
                  labelType: isDesktop ? NavigationRailLabelType.all : NavigationRailLabelType.selected,
                  leading: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Icon(Icons.storefront, size: 32, color: Color(0xFF1E88E5)),
                  ),
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.grid_view),
                      selectedIcon: Icon(Icons.grid_view_rounded),
                      label: Text('Catalog'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.local_offer_outlined),
                      selectedIcon: Icon(Icons.local_offer),
                      label: Text('Offers'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.favorite_border),
                      selectedIcon: Icon(Icons.favorite),
                      label: Text('Favorites'),
                    ),
                  ],
                ),
              if (!isMobile) const VerticalDivider(thickness: 1, width: 1),

              // Main Catalog Content
              Expanded(
                child: Column(
                  children: [
                    // Adaptive Responsive Banner
                    AdaptiveBanner(isDesktop: isDesktop, isTablet: isTablet),

                    // Category Filter Chips
                    Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: categories.length,
                        separatorBuilder: (_, _) => const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          final cat = categories[index];
                          final isSelected = cat == _selectedCategory;
                          return FilterChip(
                            label: Text(cat),
                            selected: isSelected,
                            onSelected: (val) {
                              setState(() {
                                _selectedCategory = cat;
                              });
                            },
                            selectedColor: const Color(0xFF1E88E5).withValues(alpha: 0.2),
                            checkmarkColor: const Color(0xFF1E88E5),
                          );
                        },
                      ),
                    ),

                    // Responsive Grid using dynamic crossAxisCount
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: GridView.builder(
                          itemCount: filtered.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            // 4 columns on desktop, 3 on tablet, 1 or 2 on mobile
                            crossAxisCount: isDesktop
                                ? 4
                                : isTablet
                                    ? 3
                                    : (screenWidth > 380 ? 2 : 1),
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: isDesktop
                                ? 0.76
                                : isTablet
                                    ? 0.72
                                    : (screenWidth > 380 ? 0.68 : 1.25),
                          ),
                          itemBuilder: (context, index) {
                            final product = filtered[index];
                            final isInCart = _cartProductIds.contains(product.id);
                            return ProductCard(
                              product: product,
                              isInCart: isInCart,
                              onToggleCart: () {
                                setState(() {
                                  if (isInCart) {
                                    _cartProductIds.remove(product.id);
                                  } else {
                                    _cartProductIds.add(product.id);
                                  }
                                });
                              },
                              onTap: () => _showProductDetails(context, product, isDesktop),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Adaptive Bottom Bar for Mobile only
          bottomNavigationBar: isMobile
              ? NavigationBar(
                  selectedIndex: _navIndex,
                  onDestinationSelected: (idx) => setState(() => _navIndex = idx),
                  destinations: const [
                    NavigationDestination(icon: Icon(Icons.grid_view), label: 'Catalog'),
                    NavigationDestination(icon: Icon(Icons.local_offer_outlined), label: 'Offers'),
                    NavigationDestination(icon: Icon(Icons.favorite_border), label: 'Favorites'),
                  ],
                )
              : null,
        );
      },
    );
  }

  void _showProductDetails(BuildContext context, Product product, bool isDesktop) {
    if (isDesktop) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 450),
            child: ProductDetailContent(product: product),
          ),
        ),
      );
    } else {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        builder: (context) => Padding(
          padding: const EdgeInsets.all(20),
          child: ProductDetailContent(product: product),
        ),
      );
    }
  }
}

/// REUSABLE CUSTOM WIDGET 1: ProductCard
class ProductCard extends StatelessWidget {
  final Product product;
  final bool isInCart;
  final VoidCallback onToggleCart;
  final VoidCallback onTap;

  const ProductCard({
    super.key,
    required this.product,
    required this.isInCart,
    required this.onToggleCart,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Image/Icon Container with Badge
            Stack(
              children: [
                Container(
                  height: 120,
                  width: double.infinity,
                  color: product.cardColor,
                  alignment: Alignment.center,
                  child: Text(product.icon, style: const TextStyle(fontSize: 52)),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      product.tag,
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),

            // Product Details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.category.toUpperCase(),
                          style: TextStyle(
                            fontSize: 10,
                            letterSpacing: 0.8,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          product.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.star, size: 14, color: Colors.amber),
                            const SizedBox(width: 4),
                            Text(
                              '${product.rating} (${product.reviewsCount})',
                              style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
                            ),
                          ],
                        ),
                      ],
                    ),

                    // Price & Cart Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '\$${product.originalPrice.toStringAsFixed(0)}',
                                style: TextStyle(
                                  fontSize: 11,
                                  decoration: TextDecoration.lineThrough,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                              Text(
                                '\$${product.price.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E88E5),
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: onToggleCart,
                          icon: Icon(isInCart ? Icons.check : Icons.add_shopping_cart, size: 18),
                          style: IconButton.styleFrom(
                            backgroundColor: isInCart ? Colors.green : const Color(0xFF1E88E5),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.all(6),
                            minimumSize: const Size(32, 32),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// REUSABLE CUSTOM WIDGET 2: AdaptiveBanner
class AdaptiveBanner extends StatelessWidget {
  final bool isDesktop;
  final bool isTablet;

  const AdaptiveBanner({
    super.key,
    required this.isDesktop,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      padding: EdgeInsets.all(isDesktop ? 24 : 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0D47A1), Color(0xFF1976D2)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'EXP 2: ADAPTIVE & RESPONSIVE UI',
                  style: TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  isDesktop
                      ? 'Multi-Column Grid, NavigationRail & Adaptive Layouts'
                      : 'Responsive Product Catalog for All Devices',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: isDesktop ? 20 : 16,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            isDesktop
                ? Icons.desktop_windows
                : isTablet
                    ? Icons.tablet_mac
                    : Icons.phone_android,
            color: Colors.white,
            size: isDesktop ? 42 : 32,
          ),
        ],
      ),
    );
  }
}

/// Reusable Product Detail Dialog/Sheet content
class ProductDetailContent extends StatelessWidget {
  final Product product;

  const ProductDetailContent({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              color: product.cardColor,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(product.icon, style: const TextStyle(fontSize: 48)),
          ),
        ),
        const SizedBox(height: 16),
        Text(product.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Row(
          children: [
            Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1E88E5)),
            ),
            const SizedBox(width: 10),
            Text(
              '\$${product.originalPrice.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 14, decoration: TextDecoration.lineThrough, color: Colors.grey),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(product.description, style: const TextStyle(fontSize: 14, height: 1.4)),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E88E5),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: const Text('Close'),
          ),
        ),
      ],
    );
  }
}
