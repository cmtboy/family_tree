import 'package:family_tree/model/family_member_model.dart';
import 'package:family_tree/providers/family_tree_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddMemberPage extends StatefulWidget {
  const AddMemberPage({super.key});

  @override
  _AddMemberPageState createState() => _AddMemberPageState();
}

class _AddMemberPageState extends State<AddMemberPage> {
  final _formKey = GlobalKey<FormState>();
  String _imageUrl = '';
  String _name = '';
  int _parentId = 0;

  @override
  Widget build(BuildContext context) {
    final familyTreeProvider = Provider.of<FamilyTreeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Family Member'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Image URL'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an image URL';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _imageUrl = value!;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _name = value!;
                  },
                ),
                DropdownButtonFormField<int>(
                  decoration: InputDecoration(labelText: 'Parent'),
                  items: familyTreeProvider.members
                      .map((member) => DropdownMenuItem<int>(
                            value: member.id,
                            child: Text(member.name),
                          ))
                      .toList(),
                  onChanged: (value) {
                    _parentId = value!;
                  },
                  validator: (value) {
                    if (value == null || value == 0) {
                      return 'Please select a parent';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();

            final newMember = FamilyMember(
              id: DateTime.now().millisecondsSinceEpoch, // Generate a unique ID
              imageUrl: _imageUrl,
              name: _name,
              parentId: _parentId,
            );

            familyTreeProvider.addMember(newMember);

            Navigator.of(context).pop();
          }
        },
        child: Icon(Icons.check),
      ),
    );
  }
}
