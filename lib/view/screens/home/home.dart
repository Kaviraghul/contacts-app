import 'package:contacts_app/view/common/app_bottom_sheets.dart';
import 'package:contacts_app/view/resources/router_manager.dart';
import 'package:contacts_app/view/screens/home/widgets/bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.white,
        child: Scaffold(
          appBar: PreferredSize(
              preferredSize: const Size.fromHeight(200),
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30))),
              )),
          bottomNavigationBar: MyBottomNavigationBar(
            onAddPressed: () => GoRouter.of(context)
                .pushNamed(RouteNamesAndPath.addNewBirthdayScreenName),
          ),
        ),
      ),
    );
  }
}
