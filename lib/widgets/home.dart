import 'package:flutter/material.dart';
import 'package:flutter_toko_online_uas_1/widgets/detail_produk.dart';
import 'package:flutter_toko_online_uas_1/widgets/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Product {
  final String name;
  final double price;
  final String imageUrl;
  final String description;
  final double weight;

  Product({
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.description,
    required this.weight,
  });
}

final List<Product> products = [
  Product(
    name: 'Wortel',
    price: 10000,
    imageUrl: 'images/image1.jpg',
    description:
        'Wortel (Daucus carota L.) adalah sayuran umbi yang populer dengan warna oranye khasnya. Sayuran ini termasuk jenis tanaman semusim, berbentuk semak, dan dapat tumbuh hingga ketinggian 100 cm. Wortel terkenal dengan kandungan beta karotennya yang tinggi, pendahulu vitamin A, yang bermanfaat untuk kesehatan mata.',
    weight: 1,
  ),
  Product(
    name: 'Jahe',
    price: 20000,
    imageUrl: 'images/image2.jpg',
    description:
        'Jahe (Zingiber officinale) adalah tanaman rimpang yang berasal dari Asia Tenggara. Rimpangnya telah lama digunakan dalam pengobatan tradisional dan kuliner di berbagai negara. Jahe memiliki rasa pedas dan aroma hangat yang khas.',
    weight: 1.5,
  ),
  Product(
    name: 'Bawang Merah',
    price: 30000,
    imageUrl: 'images/image3.jpg',
    description:
        'Bawang merah (Allium cepa L. var. aggregatum) adalah salah satu bumbu masak utama di dunia yang berasal dari Asia Tengah. Umbinya yang berwarna merah memiliki rasa pedas dan aroma khas yang kuat. Bawang merah tidak hanya lezat, tetapi juga kaya akan manfaat kesehatan.',
    weight: 3,
  ),
  Product(
    name: 'Bawang Bombay',
    price: 30000,
    imageUrl: 'images/image4.jpg',
    description:
        'Bawang bombay (Allium cepa L.), yang juga dikenal dengan sebutan bawang bombai merah atau bawang besar, adalah sayuran umbi yang populer di seluruh dunia. Berbeda dengan bawang merah yang berukuran kecil dan pedas, bawang bombay memiliki ukuran lebih besar, bentuk lebih bulat, dan rasa yang cenderung manis dan sedikit tajam.',
    weight: 1,
  ),
  Product(
    name: 'Cabe Rawit',
    price: 30000,
    imageUrl: 'images/image5.jpg',
    description:
        'Cabe rawit (Capsicum frutescens L.) adalah cabai kecil yang populer di berbagai masakan Indonesia. Berukuran mungil dengan panjang sekitar 2-5 cm, cabe rawit memiliki rasa pedas yang membakar lidah.',
    weight: 2,
  ),
];

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({Key? key}) : super(key: key);

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token'); // Hapus token dari SharedPreferences

    // Arahkan kembali ke layar login
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Produk'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Jumlah kolom dalam grid
          crossAxisSpacing: 10.0, // Spasi horizontal antar grid
          mainAxisSpacing: 10.0, // Spasi vertikal antar grid
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailScreen(product: product),
                ),
              );
            },
            child: Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(product.imageUrl, fit: BoxFit.cover),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(product.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            )),
                        Text('Rp ${product.price.toStringAsFixed(0)}'),
                        // Text('Berat: ${product.weight.toString()} kg'),
                        // Text('Deskripsi: ${product.description}'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
