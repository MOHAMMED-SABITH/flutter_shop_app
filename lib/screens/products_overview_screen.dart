import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import '../widgets/products_grid.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import '../widgets/badge.dart';
import '../providers/cart.dart';
import './cart_screen.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductOverviewScreen extends StatefulWidget {
  ProductOverviewScreen({super.key});

  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _showFavotitesOnly = false;
  var _isInit = true;
  var _isLoading = false;
  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts()
        .then((_) {
      setState(() {
        _isLoading = false;
      });
    }); //Won't work

    // Future.delayed(Duration.zero).then((_) {
    //   Provider.of<Products>(context, listen: false).fetchAndSetProducts();
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print(Provider.of<Cart>(context).itemCount);
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyShop'),
        actions: <Widget>[
          PopupMenuButton(
              onSelected: (FilterOptions selectedValue) {
                setState(() {
                  if (selectedValue == FilterOptions.Favorites) {
                    _showFavotitesOnly = true;
                  } else {
                    _showFavotitesOnly = false;
                  }
                });
              },
              icon: const Icon(
                Icons.more_vert,
              ),
              itemBuilder: (_) => [
                    const PopupMenuItem(
                        value: FilterOptions.Favorites,
                        child: Text('Only Favorites')),
                    const PopupMenuItem(
                        value: FilterOptions.All, child: Text('Show All')),
                  ]),
          Consumer<Cart>(
            builder: (_, cart, ch) {
              return Badges(
                value: cart.itemCount.toString(),
                child: ch as Widget,
              );
            },
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
              icon: const Icon(
                Icons.shopping_cart,
              ),
            ),
          )
        ],
      ),
      drawer: const AppDrawer(),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ProductGrid(_showFavotitesOnly),
    );
  }
}
