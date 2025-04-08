import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const String appTitle = 'Flutter layout demo';
    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        // #docregion add-widget
        body: const SingleChildScrollView(
          child: Column(
            children: [
              ImageSection(image: 'images/PotatoDone.jpg'),
              TitleSection(name: 'HanGyeol Kim', studentID: '22100229'),
              Divider(height: 1.0, color: Colors.black),
              ButtonSection(),
              Divider(height: 1.0, color: Colors.black),
              TextSection(),
            ],
          ),
        ),
        // #enddocregion add-widget
      ),
    );
  }
}

class TitleSection extends StatelessWidget {
  const TitleSection({super.key, required this.name, required this.studentID});

  final String name;
  final String studentID;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Row(
        children: [
          Expanded(
            /*1*/
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /*2*/
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Text(studentID, style: TextStyle(color: Colors.grey[500])),
              ],
            ),
          ),
          /*3*/
          // #docregion icon
          FavoriteWidget(),
        ],
      ),
    );
  }
}

class ButtonSection extends StatelessWidget {
  const ButtonSection({super.key});

  @override
  Widget build(BuildContext context) {
    final Color color = Colors.black;
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
      child: SizedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ButtonWithText(color: color, icon: Icons.call, label: 'CALL'),
            ButtonWithText(color: color, icon: Icons.message, label: 'MESSAGE'),
            ButtonWithText(color: color, icon: Icons.email, label: 'EMAIL'),
            ButtonWithText(color: color, icon: Icons.share, label: 'SHARE'),
            ButtonWithText(color: color, icon: Icons.description, label: 'ETC'),
          ],
        ),
      ),
    );
  }
}

class ButtonWithText extends StatelessWidget {
  const ButtonWithText({
    super.key,
    required this.color,
    required this.icon,
    required this.label,
  });

  final Color color;
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}

class TextSection extends StatelessWidget {
  const TextSection({super.key});

  final String description = '';
  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.all(32), child: MessageSection());
  }
}

// #docregion image-asset
class ImageSection extends StatelessWidget {
  const ImageSection({super.key, required this.image});

  final String image;

  @override
  Widget build(BuildContext context) {
    // #docregion image-asset
    return Image.asset(image, width: 600, height: 240, fit: BoxFit.cover);
    // #enddocregion image-asset
  }
}
// #enddocregion image-section

// #docregion favorite-widget
class FavoriteWidget extends StatefulWidget {
  const FavoriteWidget({super.key});

  @override
  State<FavoriteWidget> createState() => _FavoriteWidgetState();
}
// #enddocregion favorite-widget

// #docregion favorite-state, favorite-state-fields, favorite-state-build
class _FavoriteWidgetState extends State<FavoriteWidget> {
  // #enddocregion favorite-state-build
  bool _isFavorited = true;
  int _favoriteCount = 41;
  // #enddocregion favorite-state-fields

  // #docregion toggle-favorite
  void _toggleFavorite() {
    setState(() {
      if (_isFavorited) {
        _favoriteCount -= 1;
        _isFavorited = false;
      } else {
        _favoriteCount += 1;
        _isFavorited = true;
      }
    });
  }
  // #enddocregion toggle-favorite

  // #docregion favorite-state-build
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(0),
          child: IconButton(
            padding: const EdgeInsets.all(0),
            alignment: Alignment.center,
            icon:
                (_isFavorited
                    ? const Icon(Icons.star)
                    : const Icon(Icons.star_border)),
            color: Colors.yellow[500],
            onPressed: _toggleFavorite,
          ),
        ),
        SizedBox(child: Text('$_favoriteCount')),
      ],
    );
  }

  // #docregion favorite-state-fields
}

// #enddocregion favorite-state, favorite-state-fields, favorite-state-build

// Message section
class MessageSection extends StatelessWidget {
  const MessageSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.message, size: 40.0),
        Padding(
          padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Recent Message',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('Long time no see!'),
            ],
          ),
        ),
      ],
    );
  }
}
