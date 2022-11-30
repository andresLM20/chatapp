import 'package:flutter/material.dart';

class GroupInfo extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String adminName;
  GroupInfo(
      {Key? key,
      required this.groupId,
      required this.groupName,
      required this.adminName})
      : super(key: key);

  @override
  State<GroupInfo> createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
