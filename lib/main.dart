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
      home: const MainNavigationScreen(),
    );
  }
}

// ==========================================
// Main Navigation (จัดการ Bottom Navigation Bar)
// ==========================================
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const CartScreen(),
    const ImpressionScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
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
// หน้าที่ 1: หน้าหลัก (Home Screen - หลายเมนู การ์ดเล็ก)
// ==========================================
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // เพิ่มเมนูเป็น 8 รายการ
  final List<Map<String, dynamic>> products = const [
    {'name': 'Espresso', 'price': 55, 'image': '☕', 'desc': 'เอสเพรสโซเข้มข้น'},
    {'name': 'Americano', 'price': 60, 'image': '🥤', 'desc': 'อเมริกาโนหอมเข้ม'},
    {'name': 'Latte', 'price': 65, 'image': '☕', 'desc': 'ลาเต้นุ่มละมุน'},
    {'name': 'Cappuccino', 'price': 65, 'image': '☕', 'desc': 'คาปูชิโนฟองนมนุ่ม'},
    {'name': 'Mocha', 'price': 70, 'image': '🍫', 'desc': 'มอคค่ากาแฟผสมช็อกโกแลต'},
    {'name': 'Matcha', 'price': 75, 'image': '🍵', 'desc': 'มัทฉะลาเต้แท้เข้มข้น'},
    {'name': 'Croissant', 'price': 50, 'image': '🥐', 'desc': 'ครัวซองต์เนยสดอบใหม่'},
    {'name': 'Cake', 'price': 80, 'image': '🍰', 'desc': 'เค้กช็อกโกแลตหน้านุ่ม'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coffee Shop Menu'),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'เมนูทั้งหมด (เลือกเพื่อดูรายละเอียด)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: GridView.builder(
                // ปรับเป็น 3 คอลัมน์เพื่อให้การ์ดขนาดไม่ใหญ่เกินไป
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 6,
                  mainAxisSpacing: 6,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final item = products[index];
                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetailScreen(item: item),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(item['image'], style: const TextStyle(fontSize: 32)),
                            const SizedBox(height: 4),
                            Text(
                              item['name'],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                            Text(
                              '${item['price']} ฿',
                              style: const TextStyle(color: Colors.brown, fontSize: 12),
                            ),
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
// หน้าที่ 2: รายละเอียดสินค้า (Product Detail Screen)
// ==========================================
class ProductDetailScreen extends StatelessWidget {
  final Map<String, dynamic> item;

  const ProductDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item['name']),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(item['image'], style: const TextStyle(fontSize: 80)),
            ),
            const SizedBox(height: 20),
            Text(
              item['name'],
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              '${item['price']} บาท',
              style: const TextStyle(fontSize: 18, color: Colors.brown, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            Text(
              item['desc'],
              style: const TextStyle(fontSize: 15, color: Colors.black54),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('เพิ่ม ${item['name']} ลงในตะกร้าแล้ว!')),
                  );
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.add_shopping_cart, size: 20),
                label: const Text('เพิ่มลงตะกร้า', style: TextStyle(fontSize: 16)),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// ==========================================
// หน้าที่ 3: ตะกร้าสินค้า (Cart Screen)
// ==========================================
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

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
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: const [
                  ListTile(
                    leading: Text('☕', style: TextStyle(fontSize: 28)),
                    title: Text('Espresso'),
                    subtitle: Text('1 แก้ว x 55 บาท'),
                    trailing: Text('55 ฿', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Divider(),
                  ListTile(
                    leading: Text('🥐', style: TextStyle(fontSize: 28)),
                    title: Text('Croissant'),
                    subtitle: Text('1 ชิ้น x 50 บาท'),
                    trailing: Text('50 ฿', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            const Divider(thickness: 2),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('ราคารวมทั้งสิ้น:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text('105 บาท', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.brown)),
              ],
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('สั่งซื้อสำเร็จ!'),
                      content: const Text('ขอบคุณที่ใช้บริการ ออเดอร์ของคุณกำลังถูกจัดเตรียม'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('ตกลง'),
                        )
                      ],
                    ),
                  );
                },
                child: const Text('ยืนยันการสั่งซื้อ', style: TextStyle(fontSize: 16)),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// ==========================================
// หน้าที่ 4: ประเมินความพึงพอใจแอป & รีวิว (Impression Screen)
// ==========================================
class ImpressionScreen extends StatefulWidget {
  const ImpressionScreen({super.key});

  @override
  State<ImpressionScreen> createState() => _ImpressionScreenState();
}

class _ImpressionScreenState extends State<ImpressionScreen> {
  int _appRating = 0; // คะแนนดาวสำหรับแอป
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
          'comment': _feedbackController.text.isEmpty
              ? 'ประเมินความพึงพอใจแอป $_appRating ดาว'
              : _feedbackController.text,
        });
        _feedbackController.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('บันทึกการประเมินเรียบร้อย ขอบคุณครับ!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('กรุณากดเลือกดาวเพื่อประเมินความพึงพอใจ')),
      );
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
            // ส่วนการประเมินแอป
            Card(
              elevation: 3,
              color: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'คุณพึงพอใจกับการใช้งานแอปนี้แค่ไหน?',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
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
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.brown,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: _submitAppRating,
                        child: const Text('ส่งผลประเมิน'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'ความคิดเห็นจากผู้ใช้อื่นๆ',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
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
// หน้าที่ 5: โปรไฟล์ (Profile Screen)
// ==========================================
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('โปรไฟล์ของฉัน'),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
      ),
      body: const Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.brown,
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            SizedBox(height: 10),
            Text('คุณลูกค้า', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('customer@email.com', style: TextStyle(color: Colors.grey)),
            SizedBox(height: 15),
            Divider(),
            ListTile(
              leading: Icon(Icons.history),
              title: Text('ประวัติการสั่งซื้อ'),
              trailing: Icon(Icons.arrow_forward_ios, size: 14),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('ตั้งค่าระบบ'),
              trailing: Icon(Icons.arrow_forward_ios, size: 14),
            ),
          ],
        ),
      ),
    );
  }
}