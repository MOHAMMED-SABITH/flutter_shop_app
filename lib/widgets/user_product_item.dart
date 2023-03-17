import 'package:flutter/material.dart';
import '../screens/edit_product_screen.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';

class UserProductItem extends StatelessWidget {
  const UserProductItem(this.id, this.title, this.imageUrl, {super.key});
  final String id;
  final String title;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final scaffold= ScaffoldMessenger.of(context);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: SizedBox(
        width: 100,
        child: Row(children: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(EditproductScreen.routeName, arguments: id);
            },
            icon: const Icon(Icons.edit),
            color: Theme.of(context).colorScheme.primary,
          ),
          IconButton(
            onPressed: () async {
              try {
                await Provider.of<Products>(context, listen: false).deleteproduct(id);
              } catch (error) {
               scaffold.showSnackBar(
                  const SnackBar(
                    content: Text('Deleting Failed.',textAlign: TextAlign.center,),
                  ),
                );
              }
            },
            icon: const Icon(Icons.delete),
            color: Theme.of(context).colorScheme.error,
          ),
        ]),
      ),
    );
  }
}
