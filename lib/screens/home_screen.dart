import 'package:flutter/material.dart';
import '../services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<String>> _annotations;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _annotations = ApiService.fetchAnnotations("Microsoft released Windows 11");
  }

  Future<void> _refreshAnnotations() async {
    setState(() {
      _annotations = ApiService.fetchAnnotations(_controller.text);
    });
  }

  void _searchAnnotations() {
    setState(() {
      _annotations = ApiService.fetchAnnotations(_controller.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Entity Annotator'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: _controller,
              onSubmitted: (_) => _searchAnnotations(),
              decoration: InputDecoration(
                hintText: 'Enter text to annotate...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _controller.clear();
                    _searchAnnotations();
                  },
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshAnnotations,
        child: FutureBuilder<List<String>>(
          future: _annotations,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No annotations found.'));
            }

            final annotations = snapshot.data!;
            return ListView.builder(
              itemCount: annotations.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(annotations[index]),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
