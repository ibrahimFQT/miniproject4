import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future fetchData() async {
    final res = await http.get(Uri.parse("https://dummyjson.com/products"));

    final data = json.decode(res.body);

    setState(() {
      products = data['products'];
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: TextField(
          decoration: InputDecoration(
            hintText: "Cari produk...",
            filled: true,
            fillColor: Colors.white,
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: (products.length / 2).ceil(),
              itemBuilder: (context, index) {
                int first = index * 2;
                int second = first + 1;

                return Row(
                  children: [
                    Expanded(child: productCard(products[first])),

                    if (second < products.length)
                      Expanded(child: productCard(products[second]))
                    else
                      Expanded(child: Container()),
                  ],
                );
              },
            ),
    );
  }

  Widget productCard(Map item) {
    return Container(
      margin: EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // gambar + diskon
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                child: Image.network(
                  item['thumbnail'],
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

              Positioned(
                top: 5,
                right: 5,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  color: Colors.red,
                  child: Text(
                    "-${item['discountPercentage'].toInt()}%",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              )
            ],
          ),

          Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['title'],
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),

                Text(
                  "Rp ${item['price']}",
                  style: TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 2),

                Text(
                  "⭐ ${item['rating']}",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}