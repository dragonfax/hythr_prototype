import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'content/user.dart';
import 'tags_selection_page.dart';
import 'package:map_view/map_view.dart';
import 'package:map_view/camera_position.dart';
import 'package:map_view/location.dart';
import 'package:map_view/toolbar_action.dart';
import 'package:map_view/map_options.dart';
import 'package:map_view/marker.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'content/root.dart';
import 'page.dart';


class ProfileWidget extends StatelessWidget {
  final canEdit = true;

  static show(BuildContext context) {
    new Page(title: "Stylist Profile", child: new ProfileWidget()).show(context);
  }

  showSalonMap() async {

    User user = root.currentUser;

    var httpClient = createHttpClient();

    String address = Uri.encodeQueryComponent(user.salon.address);
    String url = "https://maps.googleapis.com/maps/api/geocode/json?key=AIzaSyD3dwHECky9YbAwgGik_bU_VjXipsSpgr8&address=$address";

    var response = await httpClient.read(url);
    Map data = JSON.decode(response);
    Map longlat = data["results"][0]["geometry"]["location"];
    double long = longlat["lng"];
    double lat = longlat["lat"];


    MapView mapView = new MapView();
    mapView.onToolbarAction.listen((id) {
      if (id == 1) {
        mapView.dismiss();
      }
    });

    mapView.onMapReady.listen((_) {
      mapView.addMarker(new Marker("1",user.salon.name,lat,long));
    });

    mapView.show(
        new MapOptions(
            showUserLocation: true,
            initialCameraPosition: new CameraPosition(
                new Location(lat,long),
                14.0
            ),
            title: user.salon.name
        ),
        toolbarActions: [new ToolbarAction("Close", 1)]
    );
  }

  @override
  Widget build(BuildContext context) {
    User user = root.currentUser;

    List<Widget> slivers = [];

    // initial tiles with basic user info for the first sliver.
    List<Widget> basicInfo = [
      new ListTile(
        leading: user.getProfilePicture(),
        title: new Text(user.realName),
        subtitle: new Column(children: [
          new Text(user.username),
          new Text(user.isStylist ? "(stylist)" : "", style: new TextStyle(fontStyle: FontStyle.italic))
        ]),
      ),
      new Divider(),
      new ListTile(
        leading: new Text("Bio"),
        title: new Text("I want to scream and shout and let it all out. Scream and shout and let it out. We sing oh we oh.")
      ),
      new Divider(),
      new ListTile(
        leading: new Icon(Icons.phone),
        title: new Text(user.phone ?? "XXX-XXX-XXXX"),
      ),
      new Divider(),
    ];


    if ( user.isStylist && user.salon != null ) {
      basicInfo.addAll([
          new ListTile(
            leading: new Column(children: [
              new Icon(Icons.content_cut),
            ]),
            title: new Text(user.salon.name ?? ""),
            subtitle: new Text(user.salon.address +
              "\n" +
              user.salon.hours +
              "\n" +
              user.salon.phone
            ),
            onTap: showSalonMap
          ),
          new Divider()
      ]);
    }


    basicInfo.addAll([
      new ListTile(
        leading: new Icon(Icons.beach_access),
        title: new Text("Interests",
          style: new TextStyle(fontWeight: FontWeight.bold)
        ),
        subtitle: new Text(user.interests.join(", ")),
        onTap: () {
          InterestsSelectionPage.show(context, user, root.interests);
        }
      ),
      new Divider(),
      new ListTile(
        leading: new Icon(Icons.content_cut),
        title: new Text("Skills",
          style: new TextStyle(fontWeight: FontWeight.bold)
        ),
        subtitle: new Text(user.skills.join(", ")),
        onTap: () {
          SkillsSelectionPage.show(context, user, root.skills);
        }
      ),
      new Divider(),
    ]);

    if (user.isStylist ) {
      basicInfo.addAll([
        new ListTile(
            leading: new Icon(Icons.school),
            title: new Text("Certifications",
                style: new TextStyle(fontWeight: FontWeight.bold)),
            subtitle: new Text((user.certifications ?? []).join(", "))),
        new Divider()
      ]);
    }

    slivers.add(new SliverList( delegate: new SliverChildListDelegate(basicInfo)));

    return new CustomScrollView(slivers: slivers);
  }
}
