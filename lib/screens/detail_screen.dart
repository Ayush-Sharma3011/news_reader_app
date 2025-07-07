import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/news_article.dart';

class DetailScreen extends StatelessWidget {
  final NewsArticle article;
  const DetailScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(article.title, maxLines: 1, overflow: TextOverflow.ellipsis)),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Image.network(article.imageUrl),
            const SizedBox(height: 10),
            Text(article.description, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text("Read Full Article"),
              onPressed: () async {
                final uri = Uri.parse(article.url);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri);
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
