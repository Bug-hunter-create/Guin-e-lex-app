import 'package:flutter/material.dart';

class RecentTile extends StatefulWidget {
  final String title;
  final String description;
  final Widget? leadingIcon;
  const RecentTile({
    super.key,
    this.title = '',
    this.description = '',
    this.leadingIcon,
  });

  @override
  State<RecentTile> createState() => _RecentTileState();
}

class _RecentTileState extends State<RecentTile> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: ListTile(
        contentPadding: const EdgeInsets.all(8.0),
        leading: CircleAvatar(
          radius: 30,
          backgroundColor: const Color.fromARGB(255, 79, 92, 209),
          child:
              widget.leadingIcon ??
              Icon(Icons.history, color: Colors.white, size: 30.0),
        ),
        title: Text(
          widget.title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          widget.description,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ),
    );
  }
}
