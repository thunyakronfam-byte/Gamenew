import 'package:flutter/material.dart';

void main() {
  runApp(const CoffeeShopApp());
}

class CoffeeShopApp extends StatelessWidget {
  const CoffeeShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coffee & Impression App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.brown,
        scaffoldBackgroundColor: const Color(0xFFA8F6FA),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}

// ==========================================
// 1. หน้าล็อกอิน (Login Screen)
// ==========================================
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _login() {
    if (_formKey.currentState!.validate()) {
      String username = _usernameController.text.trim();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MainNavigationScreen(username: username),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.coffee, size: 64, color: Colors.brown),
                    const SizedBox(height: 12),
                    const Text('เข้าสู่ระบบ Coffee Shop', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        labelText: 'ชื่อผู้ใช้ (Username)',
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => value == null || value.trim().isEmpty ? 'กรุณากรอกชื่อผู้ใช้' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'รหัสผ่าน (Password)',
                        prefixIcon: Icon(Icons.lock),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => value == null || value.isEmpty ? 'กรุณากรอกรหัสผ่าน' : null,
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.brown,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: _login,
                        child: const Text('เข้าสู่ระบบ', style: TextStyle(fontSize: 16)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ==========================================
// Main Navigation (จัดการ Bottom Navigation & Global State)
// ==========================================
class MainNavigationScreen extends StatefulWidget {
  final String username;
  const MainNavigationScreen({super.key, required this.username});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Map<String, dynamic>> _cartItems = [];
  final List<Map<String, dynamic>> _orderHistory = [];
  int _userPoints = 50;

  void _addToCart(Map<String, dynamic> customizedProduct) {
    setState(() {
      _cartItems.add(customizedProduct);
    });
  }

  void _updateCartQty(int index, int delta) {
    setState(() {
      _cartItems[index]['qty'] += delta;
      if (_cartItems[index]['qty'] <= 0) {
        _cartItems.removeAt(index);
      }
    });
  }

  void _removeFromCart(int index) {
    setState(() {
      _cartItems.removeAt(index);
    });
  }

  void _addOrderToHistoryAndClearCart(Map<String, dynamic> newOrder, int earnedPoints) {
    setState(() {
      _orderHistory.insert(0, newOrder);
      _userPoints += earnedPoints;
      _cartItems.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomeScreen(onAddToCart: _addToCart),
      CartScreen(
        cartItems: _cartItems,
        onUpdateQty: _updateCartQty,
        onRemoveItem: _removeFromCart,
        onOrderComplete: _addOrderToHistoryAndClearCart,
      ),
      const ImpressionScreen(),
      ProfileScreen(
        username: widget.username,
        points: _userPoints,
        orderHistory: _orderHistory,
      ),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.brown[800],
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'หน้าหลัก'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'ตะกร้า'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'ประเมินแอป'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'โปรไฟล์'),
        ],
      ),
    );
  }
}

// ==========================================
// หน้าที่ 1: หน้าหลัก (Home Screen)
// ==========================================
class HomeScreen extends StatefulWidget {
  final Function(Map<String, dynamic>) onAddToCart;
  const HomeScreen({super.key, required this.onAddToCart});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCategory = 'ทั้งหมด';
  String _searchQuery = '';

  final List<Map<String, dynamic>> products = const [
    // --- หมวดหมู่อาหาร/กาแฟ (Coffee) ---
    {'name': 'Espresso', 'price': 55, 'image': '☕', 'category': 'กาแฟ', 'desc': 'เอสเพรสโซช็อตเข้มข้น หอมกลิ่นกาแฟคั่วบดสดใหม่'},
    {'name': 'Americano', 'price': 60, 'image': '🥤', 'category': 'กาแฟ', 'desc': 'อเมริกาโนรสชาติเข้มข้น ดื่มง่าย สดชื่นได้ตลอดวัน'},
    {'name': 'Latte', 'price': 65, 'image': '☕', 'category': 'กาแฟ', 'desc': 'กาแฟเอสเพรสโซผสมนมสดนุ่มละมุน รสชาติกลมกล่อม'},
    {'name': 'Cappuccino', 'price': 65, 'image': '☕', 'category': 'กาแฟ', 'desc': 'คาปูชิโนฟองนมนุ่มฟู โรยผงโกโก้หอมกรุ่น'},
    {'name': 'Mocha', 'price': 70, 'image': '🍫', 'category': 'กาแฟ', 'desc': 'กาแฟผสมซอสช็อกโกแลตพรีเมียม เข้มข้นหวานมัน'},
    {'name': 'Caramel Macchiato', 'price': 75, 'image': '🍯', 'category': 'กาแฟ', 'desc': 'เอสเพรสโซผสมนมสด ราดด้วยไซรัปคาราเมลหอมหวาน'},
    {'name': 'Dirty Coffee', 'price': 80, 'image': '🥛', 'category': 'กาแฟ', 'desc': 'นมสดเย็นจัด ท็อปด้วยช็อตเอสเพรสโซเข้มข้นชั้นเลิศ'},
    {'name': 'Cold Brew', 'price': 70, 'image': '🧊', 'category': 'กาแฟ', 'desc': 'กาแฟสกัดเย็นนุ่มลึก ดื่มง่าย ได้รสสัมผัสกาแฟแท้'},
    {'name': 'Affogato', 'price': 85, 'image': '🍨', 'category': 'กาแฟ', 'desc': 'ไอศกรีมวานิลลาพรีเมียมราดด้วยช็อตเอสเพรสโซร้อนเข้มข้น'},
    {'name': 'Hazelnut Latte', 'price': 75, 'image': '🌰', 'category': 'กาแฟ', 'desc': 'ลาเต้นมสดเพิ่มความหอมนุ่มด้วยไซรัปเฮเซลนัทคุณภาพ'},

    // --- หมวดหมู่ชา (Tea) ---
    {'name': 'Matcha Latte', 'price': 75, 'image': '🍵', 'category': 'ชา', 'desc': 'มัทฉะแท้เกรดพรีเมียมจากอุจิ ประเทศญี่ปุ่น หอมเข้มกลมกล่อม'},
    {'name': 'Thai Tea', 'price': 65, 'image': '🧋', 'category': 'ชา', 'desc': 'ชาไทยรสเข้มข้น สูตรกลมกล่อม หวานมันกำลังดี'},
    {'name': 'Green Tea', 'price': 60, 'image': '🍃', 'category': 'ชา', 'desc': 'ชาเขียวนมสด รสหอมหวาน ดื่มแล้วสดชื่นกระปรี้กระเปร่า'},
    {'name': 'Earl Grey Lemon', 'price': 65, 'image': '🍋', 'category': 'ชา', 'desc': 'ชาเอิร์ลเกรย์หอมกลิ่นมะกรูด ผสมน้ำมะนาวสดเปรี้ยวหวานลงตัว'},
    {'name': 'Peach Tea', 'price': 65, 'image': '🍑', 'category': 'ชา', 'desc': 'ชาพีชหอมหวานชานม เปรี้ยวเล็กน้อย ดื่มแก้เลี่ยนได้ดีเยี่ยม'},
    {'name': 'Hojicha Latte', 'price': 75, 'image': '🌾', 'category': 'ชา', 'desc': 'ชาคั่วโฮจิฉะสไตล์ญี่ปุ่น หอมกลิ่นคั่วเอกลักษณ์ นุ่มละมุนลิ้น'},
    {'name': 'Taiwanese Milk Tea', 'price': 65, 'image': '🧋', 'category': 'ชา', 'desc': 'ชานมไต้หวันต้นตำรับ หอมกลิ่นใบชาเข้มข้น รสนุ่มกลมกล่อม'},

    // --- หมวดหมู่เบเกอรี่ (Bakery) ---
    {'name': 'Croissant', 'price': 50, 'image': '🥐', 'category': 'เบเกอรี่', 'desc': 'ครัวซองต์เนยสดแท้ฝรั่งเศส อบใหม่กรอบนอกนุ่มใน'},
    {'name': 'Chocolate Cake', 'price': 80, 'image': '🍰', 'category': 'เบเกอรี่', 'desc': 'เค้กช็อกโกแลตหน้านุ่ม รสเข้มข้น หวานกำลังพอดี'},
    {'name': 'New York Cheesecake', 'price': 85, 'image': '🧀', 'category': 'เบเกอรี่', 'desc': 'ชีสเค้กเนื้อเนียนนุ่ม หอมมันชีสสไตล์นิวยอร์กแท้'},
    {'name': 'Blueberry Muffin', 'price': 55, 'image': '🧁', 'category': 'เบเกอรี่', 'desc': 'มัฟฟินนุ่มฟูอัดแน่นด้วยบลูเบอร์รีสด เปรี้ยวหวานกำลังดี'},
    {'name': 'Fudge Brownie', 'price': 60, 'image': '🍫', 'category': 'เบเกอรี่', 'desc': 'บราวนี่ฟัดจ์ฉ่ำช็อกโกแลต เข้มข้น เนื้อแน่นหนึบหนับ'},
    {'name': 'Almond Danis', 'price': 65, 'image': '🍞', 'category': 'เบเกอรี่', 'desc': 'พายเนยสดท็อปด้วยอัลมอนด์สไลซ์ กรุบกรอบหอมหวาน'},
    {'name': 'Strawberry Tart', 'price': 90, 'image': '🍓', 'category': 'เบเกอรี่', 'desc': 'ทาร์ตกรอบคัสตาร์ดครีมนุ่ม ท็อปด้วยสตรอว์เบอร์รีสดฉ่ำๆ'},
    {'name': 'Garlic Cream Bread', 'price': 70, 'image': '🧄', 'category': 'เบเกอรี่', 'desc': 'ขนมปังกระเทียมชีสสไตล์เกาหลี หอมกระเทียมชีสเน้นๆ'},
    {'name': 'Choco Chip Cookie', 'price': 40, 'image': '🍪', 'category': 'เบเกอรี่', 'desc': 'คุกกี้ช็อกโกแลตชิปชิ้นใหญ่ กรอบนอกนุ่มใน หอมเนยแท้'},
    {'name': 'Waffle Ice Cream', 'price': 95, 'image': '🧇', 'category': 'เบเกอรี่', 'desc': 'วาฟเฟิลอบร้อนๆ เสิร์ฟคู่กับไอศกรีมวานิลลาและซอสช็อกโกแลต'},
  ];

  @override
  Widget build(BuildContext context) {
    final filteredProducts = products.where((item) {
      final matchesCategory = _selectedCategory == 'ทั้งหมด' || item['category'] == _selectedCategory;
      final matchesSearch = item['name'].toString().toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Coffee Shop Menu'),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // แบนเนอร์โปรโมชัน
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.brown[700],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Text('🎉', style: TextStyle(fontSize: 28)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('โปรโมชันต้อนรับสมาชิกใหม่!', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                        Text('ใช้โค้ด COFFEE10 ลดทันที 10%', style: TextStyle(color: Colors.white70, fontSize: 12)),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 12),

            // ช่องค้นหา
            TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'ค้นหาเมนู...',
                prefixIcon: const Icon(Icons.search, color: Colors.brown),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // หมวดหมู่สินค้า
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['ทั้งหมด', 'กาแฟ', 'ชา', 'เบเกอรี่'].map((cat) {
                  final isSelected = _selectedCategory == cat;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(cat),
                      selected: isSelected,
                      selectedColor: Colors.brown,
                      labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black87),
                      onSelected: (bool selected) {
                        setState(() {
                          _selectedCategory = cat;
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 12),

            // รายการสินค้า
            Expanded(
              child: filteredProducts.isEmpty
                  ? const Center(child: Text('ไม่พบเมนูที่ค้นหา', style: TextStyle(fontSize: 16)))
                  : GridView.builder(
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 160,
                        mainAxisExtent: 130,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: filteredProducts.length,
                      itemBuilder: (context, index) {
                        final item = filteredProducts[index];
                        return Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductDetailScreen(
                                    item: item,
                                    onAddToCart: widget.onAddToCart,
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(item['image'], style: const TextStyle(fontSize: 36)),
                                  const SizedBox(height: 4),
                                  Text(
                                    item['name'],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                  ),
                                  const SizedBox(height: 2),
                                  Text('${item['price']} ฿', style: const TextStyle(color: Colors.brown, fontSize: 12, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// หน้าที่ 2: รายละเอียดสินค้า
// ==========================================
class ProductDetailScreen extends StatefulWidget {
  final Map<String, dynamic> item;
  final Function(Map<String, dynamic>) onAddToCart;

  const ProductDetailScreen({super.key, required this.item, required this.onAddToCart});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  String _type = 'เย็น';
  String _sweetness = '100%';
  bool _addWhippedCream = false;
  bool _addExtraShot = false;

  bool get isDrink => widget.item['category'] == 'กาแฟ' || widget.item['category'] == 'ชา';

  int get calculatedPrice {
    int price = widget.item['price'];
    if (isDrink) {
      if (_type == 'เย็น') price += 5;
      if (_type == 'ปั่น') price += 10;
      if (_addWhippedCream) price += 10;
      if (_addExtraShot) price += 15;
    }
    return price;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item['name']),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Text(widget.item['image'], style: const TextStyle(fontSize: 90))),
            const SizedBox(height: 16),
            Text(widget.item['name'], style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text('${widget.item['price']} บาท ${isDrink ? '(ราคาเริ่มต้น)' : ''}', style: const TextStyle(fontSize: 16, color: Colors.brown, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(widget.item['desc'], style: const TextStyle(fontSize: 14, color: Colors.black54)),
            const Divider(height: 32),

            if (isDrink) ...[
              const Text('เลือกประเภท:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Row(
                children: ['ร้อน', 'เย็น (+5฿)', 'ปั่น (+10฿)'].map((t) {
                  final rawType = t.split(' ')[0];
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(t),
                      selected: _type == rawType,
                      onSelected: (val) {
                        setState(() {
                          _type = rawType;
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              const Text('ระดับความหวาน:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Row(
                children: ['0%', '25%', '50%', '100%'].map((s) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(s),
                      selected: _sweetness == s,
                      onSelected: (val) {
                        setState(() {
                          _sweetness = s;
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              const Text('ท็อปปิ้งเพิ่มเติม:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              CheckboxListTile(
                title: const Text('เพิ่มวิปครีม (+10 บาท)'),
                value: _addWhippedCream,
                onChanged: (val) => setState(() => _addWhippedCream = val ?? false),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
              CheckboxListTile(
                title: const Text('เพิ่มช็อตเอสเพรสโซ (+15 บาท)'),
                value: _addExtraShot,
                onChanged: (val) => setState(() => _addExtraShot = val ?? false),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 16),
            ],

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('ราคารวมสุทธิ:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('$calculatedPrice บาท', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.brown)),
              ],
            ),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  List<String> toppings = [];
                  if (isDrink) {
                    if (_addWhippedCream) toppings.add('วิปครีม');
                    if (_addExtraShot) toppings.add('ช็อตเอสเพรสโซ');
                  }

                  final itemData = {
                    'name': widget.item['name'],
                    'image': widget.item['image'],
                    'unitPrice': calculatedPrice,
                    'type': isDrink ? _type : '-',
                    'sweetness': isDrink ? _sweetness : '-',
                    'toppings': toppings,
                    'qty': 1,
                  };

                  widget.onAddToCart(itemData);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('เพิ่ม ${widget.item['name']} ลงในตะกร้าแล้ว!')),
                  );
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.add_shopping_cart),
                label: const Text('เพิ่มลงตะกร้า', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// หน้าที่ 3: ตะกร้าสินค้า
// ==========================================
class CartScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final Function(int, int) onUpdateQty;
  final Function(int) onRemoveItem;
  final Function(Map<String, dynamic>, int) onOrderComplete;

  const CartScreen({
    super.key,
    required this.cartItems,
    required this.onUpdateQty,
    required this.onRemoveItem,
    required this.onOrderComplete,
  });

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _promoController = TextEditingController();
  int _discountPercent = 0;
  String _discountMsg = '';

  int get subtotal => widget.cartItems.fold(0, (sum, item) => sum + ((item['unitPrice'] as int) * (item['qty'] as int)));
  int get discountAmount => (subtotal * _discountPercent / 100).round();
  int get finalTotal => subtotal - discountAmount;

  void _applyPromoCode() {
    setState(() {
      if (_promoController.text.trim().toUpperCase() == 'COFFEE10') {
        _discountPercent = 10;
        _discountMsg = 'ใช้ส่วนลด 10% สำเร็จ!';
      } else {
        _discountPercent = 0;
        _discountMsg = 'โค้ดส่วนลดไม่ถูกต้อง';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ตะกร้าสินค้า'),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: widget.cartItems.isEmpty
            ? const Center(child: Text('ไม่มีสินค้าในตะกร้า', style: TextStyle(fontSize: 18, color: Colors.black54)))
            : Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      itemCount: widget.cartItems.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        final item = widget.cartItems[index];
                        final toppingsStr = (item['toppings'] as List).isNotEmpty ? ' (+${(item['toppings'] as List).join(', ')})' : '';

                        return ListTile(
                          leading: Text(item['image'], style: const TextStyle(fontSize: 28)),
                          title: Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(
                            item['type'] != '-' 
                              ? '${item['type']} | ความหวาน ${item['sweetness']}$toppingsStr\n${item['unitPrice']} ฿ / ชิ้น' 
                              : '${item['unitPrice']} ฿ / ชิ้น',
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline, color: Colors.brown),
                                onPressed: () => widget.onUpdateQty(index, -1),
                              ),
                              Text('${item['qty']}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              IconButton(
                                icon: const Icon(Icons.add_circle_outline, color: Colors.brown),
                                onPressed: () => widget.onUpdateQty(index, 1),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => widget.onRemoveItem(index),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const Divider(thickness: 2),

                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _promoController,
                          decoration: const InputDecoration(
                            hintText: 'ใส่โค้ดส่วนลด (ลอง COFFEE10)',
                            isDense: true,
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.all(10),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.brown, foregroundColor: Colors.white),
                        onPressed: _applyPromoCode,
                        child: const Text('ใช้โค้ด'),
                      ),
                    ],
                  ),
                  if (_discountMsg.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(_discountMsg, style: TextStyle(color: _discountPercent > 0 ? Colors.green : Colors.red, fontSize: 13)),
                    ),
                  const SizedBox(height: 12),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('ราคารวม:', style: TextStyle(fontSize: 14)),
                      Text('$subtotal บาท', style: const TextStyle(fontSize: 14)),
                    ],
                  ),
                  if (_discountPercent > 0)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('ส่วนลด ($_discountPercent%):', style: const TextStyle(fontSize: 14, color: Colors.green)),
                        Text('-$discountAmount บาท', style: const TextStyle(fontSize: 14, color: Colors.green)),
                      ],
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('ราคารวมทั้งสิ้น:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Text('$finalTotal บาท', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.brown)),
                    ],
                  ),
                  const SizedBox(height: 12),

                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DeliveryScreen(
                              cartItems: widget.cartItems,
                              finalTotal: finalTotal,
                              onOrderComplete: widget.onOrderComplete,
                            ),
                          ),
                        );
                      },
                      child: const Text('ดำเนินการสั่งซื้อ', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

// ==========================================
// หน้าที่ 4: หน้าจัดส่งและเลือกการชำระเงิน
// ==========================================
class DeliveryScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final int finalTotal;
  final Function(Map<String, dynamic>, int) onOrderComplete;

  const DeliveryScreen({
    super.key,
    required this.cartItems,
    required this.finalTotal,
    required this.onOrderComplete,
  });

  @override
  State<DeliveryScreen> createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends State<DeliveryScreen> {
  final _addressController = TextEditingController();
  TimeOfDay _selectedTime = TimeOfDay.now();
  String _paymentMethod = 'เงินสด';

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('จัดส่ง & ชำระเงิน'),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('ที่อยู่จัดส่ง', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _addressController,
              maxLines: 2,
              decoration: const InputDecoration(
                hintText: 'กรุณากรอกบ้านเลขที่ ถนน ซอย...',
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            const Text('เวลารับของ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Card(
              color: Colors.white,
              child: ListTile(
                leading: const Icon(Icons.access_time, color: Colors.brown),
                title: Text('เวลารับสินค้า: ${_selectedTime.format(context)}'),
                trailing: ElevatedButton(
                  onPressed: () => _selectTime(context),
                  child: const Text('เลือกเวลา'),
                ),
              ),
            ),
            const SizedBox(height: 16),

            const Text('ช่องทางการชำระเงิน', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            RadioListTile(
              title: const Text('ชำระเงินปลายทาง (เงินสด)'),
              value: 'เงินสด',
              groupValue: _paymentMethod,
              onChanged: (val) => setState(() => _paymentMethod = val.toString()),
            ),
            RadioListTile(
              title: const Text('สแกน QR Code (PromptPay)'),
              value: 'สแกน QR Code',
              groupValue: _paymentMethod,
              onChanged: (val) => setState(() => _paymentMethod = val.toString()),
            ),

            if (_paymentMethod == 'สแกน QR Code')
              Card(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Icon(Icons.qr_code_2, size: 120, color: Colors.black87),
                      const SizedBox(height: 8),
                      Text('สแกนจ่ายจำนวน ${widget.finalTotal} บาท', style: const TextStyle(fontWeight: FontWeight.bold)),
                      const Text('พร้อมเพย์: 081-234-5678 (Coffee Shop)', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('ยอดชำระทั้งหมด:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text('${widget.finalTotal} บาท', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.brown)),
              ],
            ),
            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                onPressed: () {
                  if (_addressController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('กรุณากรอกที่อยู่จัดส่ง')));
                    return;
                  }

                  final now = DateTime.now();
                  int earnedPoints = (widget.finalTotal / 50).floor();

                  final newOrder = {
                    'id': now.millisecondsSinceEpoch.toString().substring(7),
                    'date': '${now.day}/${now.month}/${now.year} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}',
                    'items': List<Map<String, dynamic>>.from(widget.cartItems),
                    'totalPrice': widget.finalTotal,
                    'address': _addressController.text.trim(),
                    'deliveryTime': _selectedTime.format(context),
                    'paymentMethod': _paymentMethod,
                    'status': 'กำลังเตรียมสินค้า',
                  };

                  widget.onOrderComplete(newOrder, earnedPoints);

                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('สั่งซื้อสำเร็จ!'),
                      content: Text(
                        'ขอบคุณที่ใช้บริการ\n\nจัดส่งไปที่:\n${_addressController.text.trim()}\n\nชำระโดย: $_paymentMethod\nรับแต้มสะสม: +$earnedPoints แต้ม',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          child: const Text('ตกลง'),
                        )
                      ],
                    ),
                  );
                },
                child: const Text('ยืนยันการสั่งซื้อ', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// หน้าประวัติการสั่งซื้อ (Order History & Tracking)
// ==========================================
class OrderHistoryScreen extends StatelessWidget {
  final List<Map<String, dynamic>> orderHistory;

  const OrderHistoryScreen({super.key, required this.orderHistory});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ประวัติการสั่งซื้อ'),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
      ),
      body: orderHistory.isEmpty
          ? const Center(child: Text('ยังไม่มีประวัติการสั่งซื้อ', style: TextStyle(fontSize: 18, color: Colors.black54)))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: orderHistory.length,
              itemBuilder: (context, index) {
                final order = orderHistory[index];
                final items = order['items'] as List<Map<String, dynamic>>;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  child: ExpansionTile(
                    leading: const Icon(Icons.receipt_long, color: Colors.brown),
                    title: Text('คำสั่งซื้อ #${order['id']} - ${order['totalPrice']} ฿', style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('วันที่: ${order['date']}\nสถานะ: ${order['status']}'),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(color: Colors.orange[100], borderRadius: BorderRadius.circular(4)),
                              child: Text('สถานะ: ${order['status']}', style: TextStyle(color: Colors.orange[900], fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(height: 8),
                            Text('ชำระเงินโดย: ${order['paymentMethod']}'),
                            Text('เวลารับสินค้า: ${order['deliveryTime']}'),
                            const Divider(),
                            const Text('รายการสินค้า:', style: TextStyle(fontWeight: FontWeight.bold)),
                            ...items.map((item) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('${item['image']} ${item['name']} x ${item['qty']}'),
                                  Text('${item['unitPrice'] * item['qty']} ฿'),
                                ],
                              ),
                            )),
                            const Divider(),
                            Text('ที่อยู่จัดส่ง: ${order['address']}'),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

// ==========================================
// หน้าที่ 5: ประเมินความพึงพอใจแอป & รีวิว (Impression Screen)
// ==========================================
class ImpressionScreen extends StatefulWidget {
  const ImpressionScreen({super.key});

  @override
  State<ImpressionScreen> createState() => _ImpressionScreenState();
}

class _ImpressionScreenState extends State<ImpressionScreen> {
  int _appRating = 0;
  final _feedbackController = TextEditingController();

  final List<Map<String, dynamic>> _reviews = [
    {'name': 'สมชาย', 'rating': 5, 'comment': 'แอปใช้งานง่าย สั่งกาแฟสะดวกมาก!'},
    {'name': 'มณี', 'rating': 4, 'comment': 'ระบบรวดเร็วดี เมนูน่ารัก'},
  ];

  void _submitAppRating() {
    if (_appRating > 0) {
      setState(() {
        _reviews.insert(0, {
          'name': 'คุณ (ผู้ใช้งาน)',
          'rating': _appRating,
          'comment': _feedbackController.text.isEmpty ? 'ประเมินความพึงพอใจแอป $_appRating ดาว' : _feedbackController.text,
        });
        _feedbackController.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('บันทึกการประเมินเรียบร้อย ขอบคุณครับ!')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('กรุณากดเลือกดาวเพื่อประเมินความพึงพอใจ')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ประเมินความพึงพอใจแอป'),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 3,
              color: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text('คุณพึงพอใจกับการใช้งานแอปนี้แค่ไหน?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return IconButton(
                          icon: Icon(
                            index < _appRating ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                            size: 32,
                          ),
                          onPressed: () {
                            setState(() {
                              _appRating = index + 1;
                            });
                          },
                        );
                      }),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _feedbackController,
                      decoration: const InputDecoration(
                        hintText: 'ข้อเสนอแนะเพิ่มเติม (ถ้ามี)...',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.brown, foregroundColor: Colors.white),
                        onPressed: _submitAppRating,
                        child: const Text('ส่งผลประเมิน'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text('ความคิดเห็นจากผู้ใช้อื่นๆ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _reviews.length,
              itemBuilder: (context, index) {
                final review = _reviews[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    title: Text(review['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    subtitle: Text(review['comment']),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('${review['rating']}'),
                        const Icon(Icons.star, color: Colors.amber, size: 18),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// หน้าที่ 6: โปรไฟล์ (Profile Screen)
// ==========================================
class ProfileScreen extends StatelessWidget {
  final String username;
  final int points;
  final List<Map<String, dynamic>> orderHistory;

  const ProfileScreen({
    super.key,
    required this.username,
    required this.points,
    required this.orderHistory,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('โปรไฟล์ของฉัน'),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundColor: Colors.brown,
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 10),
            Text(username.isEmpty ? 'คุณลูกค้า' : username, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Text('customer@email.com', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 16),

            Card(
              color: Colors.brown[600],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.stars, color: Colors.amber, size: 32),
                        SizedBox(width: 8),
                        Text('แต้มสะสมของคุณ', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Text('$points แต้ม', style: const TextStyle(color: Colors.amber, fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            const Divider(),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('ประวัติการสั่งซื้อ'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 14),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OrderHistoryScreen(orderHistory: orderHistory)),
                );
              },
            ),
            const ListTile(
              leading: Icon(Icons.settings),
              title: Text('ตั้งค่าระบบ'),
              trailing: Icon(Icons.arrow_forward_ios, size: 14),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red[400], foregroundColor: Colors.white),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                    (route) => false,
                  );
                },
                icon: const Icon(Icons.logout),
                label: const Text('ออกจากระบบ'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}