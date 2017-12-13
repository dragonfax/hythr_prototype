import 'package:flutter/material.dart';
import '../content/content.dart';
import 'package:hythr/pages/page.dart';
import 'package:flutter_fab_dialer/flutter_fab_dialer.dart';
import 'package:hythr/widgets/current_user.dart';

class PersonalPortfolioPage extends StatelessWidget {

  static show(BuildContext context) {
    new Page(title: "Personal Porfolio", child: new PersonalPortfolioPage()).show(context);
  }

  Widget build(BuildContext context) {

    final User user = CurrentUser.of(context);

    List<Widget> slivers = [];

    List<Widget> basicInfo = [];
    basicInfo.add(
      new ListTile(
        leading: const Icon(Icons.person_outline),
        title: const Text("Profile Gallery", style: const TextStyle(fontWeight: FontWeight.bold))
      )
    );

    slivers.add(new SliverList( delegate: new SliverChildListDelegate(basicInfo)));


    slivers.addAll([
        new SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount( crossAxisCount: 3),
            delegate: new SliverChildListDelegate(
              user.gallery.where( (p) {
                return p.wasProfile || p.isProfile;
              }).map((p) {
              return new Padding(
                  child: new Image.asset(p.asset),
                  padding: const EdgeInsets.all(8.0));
            }).toList())),
        const SliverList(
            delegate: const SliverChildListDelegate(const [
              const ListTile(
                  leading: const Icon(Icons.people),
                  title: const Text("Client Gallery", style: const TextStyle(fontWeight: FontWeight.bold))
              )])),
        new SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount( crossAxisCount: 3),
            delegate: new SliverChildListDelegate(
                user.gallery.where( (p) {
                  return p.isClient;
                }).map((p) {
                  return new Padding(
                      child: new Image.asset(p.asset),
                      padding: const EdgeInsets.all(8.0));
                }).toList())),
    ]);

    return new Stack(
      children: [
        new CustomScrollView(slivers: slivers),
        const AddPortfolioSpeedDial()
      ]
    );
  }
}

class AddPortfolioSpeedDial extends StatelessWidget {

  const AddPortfolioSpeedDial();

  @override
  Widget build(BuildContext context) {
    return const FabDialer(const [
      const FabMiniMenuItem(
          text: "Add Profile Photo",
          elevation: 4.0
      ),
      const FabMiniMenuItem(
          text: "Add Client Photo",
          elevation: 4.0
      ),
    ], Colors.blue, const Icon(Icons.add));
  }
}