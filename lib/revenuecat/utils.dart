import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class PaywallWidget extends StatelessWidget {
  final List<Package> packages;
  final String title;
  final String description;
  final Function(Package) onClickedPackage;

  const PaywallWidget({
    Key? key,
    required this.packages,
    required this.title,
    required this.description,
    required this.onClickedPackage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(
          description,
          style: TextStyle(fontSize: 16),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: packages.length,
            itemBuilder: (context, index) {
              final package = packages[index];
              return ListTile(
                title: Text(package.storeProduct.title),
                subtitle: Text(package.storeProduct.description),
                onTap: () => onClickedPackage(package),
              );
            },
          ),
        ),
      ],
    );
  }
}

class Utils {
  static void showSheet(
    BuildContext context,
    WidgetBuilder builder, {
    bool isDismissible = true,
    bool enableDrag = true,
  }) {
    showModalBottomSheet(
      context: context,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      builder: builder,
    );
  }
}
