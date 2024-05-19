import 'package:flutter/material.dart';
import 'package:family_tree/model/family_member_model.dart';

class FamilyTreeProvider with ChangeNotifier {
  final List<FamilyMember> _members = [
    FamilyMember(
        id: 1,
        imageUrl:
            'https://www.shutterstock.com/image-vector/young-smiling-man-avatar-brown-600nw-2261401207.jpg',
        name: 'Grandfather',
        parentId: 0),
    FamilyMember(
        id: 3,
        imageUrl:
            'https://www.shutterstock.com/image-vector/young-smiling-man-avatar-brown-600nw-2261401207.jpg',
        name: 'Father',
        parentId: 1),
  ];

  List<FamilyMember> get members => _members;

  void addMember(FamilyMember member) {
    _members.add(member);
    notifyListeners();
  }
}
