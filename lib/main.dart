import 'package:flutter/material.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

void main() => runApp(const MyApp()); // added const for optimization

class MyApp extends StatelessWidget {
  const MyApp({super.key}); // added const

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lazy Loader Demo', // CHANGED: updated app title
      theme: ThemeData(          // ADDED: app-wide theme
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Lazy Loader Example'), // CHANGED: new title
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<int> data = [];
  int currentLength = 0;
  final int increment = 8; // CHANGED: was 10, now 8 for quicker lazy loading
  bool isLoading = false;

  @override
  void initState() {
    _loadMore();
    super.initState();
  }

  Future _loadMore() async {
    setState(() {
      isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 1)); // CHANGED: shorter delay (was 2 seconds)
    for (var i = currentLength; i < currentLength + increment; i++) {
      data.add(i);
    }
    setState(() {
      isLoading = false;
      currentLength = data.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.blue.shade700, // CHANGED: was green
        foregroundColor: Colors.white,         // CHANGED: text color
        centerTitle: true,                     // ADDED: center title
      ),
      body: Column(
        children: [
          Expanded(
            child: LazyLoadScrollView(
              isLoading: isLoading,
              onEndOfPage: () => _loadMore(),
              child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, position) {
                  return DemoItem(position);
                },
              ),
            ),
          ),
          if (isLoading)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12), // CHANGED: bigger padding
                child: CircularProgressIndicator(
                  color: Colors.blue.shade900, // CHANGED: loader color (was green)
                  strokeWidth: 4,              // ADDED: loader thickness
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class DemoItem extends StatelessWidget {
  final int position;

  const DemoItem(this.position, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      // kept card style same as original
      child: Padding(
        padding: const EdgeInsets.all(8.0), // kept same as original
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  color: Colors.deepOrange, // kept same as original
                  height: 40.0,
                  width: 40.0,
                ),
                const SizedBox(width: 8.0),
                Text("Item $position"), // kept same as original
              ],
            ),
            const Text(
              "GeeksforGeeks.org was created with a goal "
              "in mind to provide well written, well "
              "thought and well explained solutions for selected"
              " questions. The core team of five super geeks"
              " constituting of technology lovers and computer"
              " science enthusiasts have been constantly working"
              " in this direction."
            ), // kept same as original
          ],
        ),
      ),
    );
  }
}
