import 'package:family_tree/providers/family_tree_provider.dart';
import 'package:family_tree/views/add_member.dart';
import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';
import 'package:provider/provider.dart';

class FamilyTreeScreen extends StatelessWidget {
  final Graph graph = Graph()..isTree = true;
  final BuchheimWalkerConfiguration builder = BuchheimWalkerConfiguration();

  FamilyTreeScreen() {
    builder
      ..siblingSeparation = (100)
      ..levelSeparation = (150)
      ..subtreeSeparation = (150)
      ..orientation = BuchheimWalkerConfiguration.ORIENTATION_TOP_BOTTOM;
  }

  Widget getCircularNode(String imageUrl, String name) {
    return Column(
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(imageUrl),
          radius: 30,
        ),
        SizedBox(height: 5),
        Text(name, style: TextStyle(fontSize: 12)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final familyTreeProvider = Provider.of<FamilyTreeProvider>(context);

    var nodes = <int, Node>{};
    familyTreeProvider.members.forEach((member) {
      nodes[member.id] = Node.Id(member.id);
    });

    familyTreeProvider.members.forEach((member) {
      if (member.parentId != 0) {
        graph.addEdge(nodes[member.parentId]!, nodes[member.id]!);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Family Tree'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AddMemberPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: InteractiveViewer(
        constrained: false,
        boundaryMargin: EdgeInsets.all(100),
        minScale: 0.01,
        maxScale: 5.6,
        child: GraphView(
          graph: graph,
          algorithm:
              BuchheimWalkerAlgorithm(builder, TreeEdgeRenderer(builder)),
          builder: (Node node) {
            var member = familyTreeProvider.members
                .firstWhere((m) => m.id == node.key!.value);
            return getCircularNode(member.imageUrl, member.name);
          },
        ),
      ),
    );
  }
}
