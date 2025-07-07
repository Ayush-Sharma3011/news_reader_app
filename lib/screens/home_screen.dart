import 'package:flutter/material.dart';
import '../models/news_article.dart';
import '../services/api_service.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<NewsArticle>> _news;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _news = ApiService.fetchNews();
  }

  Future<void> _refreshNews() async {
    setState(() {
      _news = ApiService.fetchNews(_controller.text);
    });
  }

  void _searchNews() {
    setState(() {
      _news = ApiService.fetchNews(_controller.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News Reader'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: _controller,
              onSubmitted: (_) => _searchNews(),
              decoration: InputDecoration(
                hintText: 'Search news...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _controller.clear();
                    _searchNews();
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
        onRefresh: _refreshNews,
        child: FutureBuilder<List<NewsArticle>>(
          future: _news,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No news found.'));
            }

            final articles = snapshot.data!;
            return ListView.builder(
              itemCount: articles.length,
              itemBuilder: (context, index) {
                final article = articles[index];
                return ListTile(
                  leading: Image.network(article.imageUrl, width: 100, fit: BoxFit.cover),
                  title: Text(article.title, maxLines: 2, overflow: TextOverflow.ellipsis),
                  subtitle: Text(article.description, maxLines: 2),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => DetailScreen(article: article)),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
