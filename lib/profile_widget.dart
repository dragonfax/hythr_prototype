import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'content/user.dart';
import 'content/tag.dart';
import 'tags_selection_page.dart';
import 'package:map_view/map_view.dart';
import 'package:map_view/camera_position.dart';
import 'package:map_view/location.dart';
import 'package:map_view/toolbar_action.dart';
import 'package:map_view/map_options.dart';
import 'package:map_view/marker.dart';
import 'package:flutter/services.dart';
import 'dart:convert';


class ProfileWidget extends StatelessWidget {
  final User user;
  final canEdit;
  final List<Tag> skills;
  final List<Tag> interests;

  ProfileWidget(this.user, this.canEdit, this.skills, this.interests);

  showSalonMap() async {

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
          InterestsSelectionPage.show(context, user, canEdit, interests);
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
          SkillsSelectionPage.show(context, user, canEdit, skills);
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

    basicInfo.add(
      new ListTile(
        leading: new Icon(Icons.person_outline),
        title: new Text("Profile Gallery", style: new TextStyle(fontWeight: FontWeight.bold))
      )
    );

    slivers.add(new SliverList( delegate: new SliverChildListDelegate(basicInfo)));


    slivers.addAll([
        new SliverGrid(
            gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount( crossAxisCount: 3),
            delegate: new SliverChildListDelegate(
              user.gallery.where( (p) {
                return p.wasProfile || p.isProfile;
              }).map((p) {
              return new Padding(
                  child: new Image.asset(p.asset),
                  padding: new EdgeInsets.all(8.0));
            }).toList())),
        new SliverList(
            delegate: new SliverChildListDelegate([
              new ListTile(
                  leading: new Icon(Icons.people),
                  title: new Text("Client Gallery", style: new TextStyle(fontWeight: FontWeight.bold))
              )])),
        new SliverGrid(
            gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount( crossAxisCount: 3),
            delegate: new SliverChildListDelegate(
                user.gallery.where( (p) {
                  return p.isClient;
                }).map((p) {
                  return new Padding(
                      child: new Image.asset(p.asset),
                      padding: new EdgeInsets.all(8.0));
                }).toList())),
        new SliverList(
          delegate: new SliverChildListDelegate([
          new ListTile(
            leading: new Icon(Icons.brush),
            title: new Text("Style Gallery", style: new TextStyle(fontWeight: FontWeight.bold))
          )])),
        new SliverGrid(
            gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount( crossAxisCount: 3),
            delegate: new SliverChildListDelegate(
              user.gallery.where( (p) {
                return !p.isClient && !p.wasProfile && !p.isProfile;
              }).map((p) {
              return new Padding(
                  child: new Image.asset(p.asset),
                  padding: new EdgeInsets.all(8.0));
            }).toList())),
    ]);

    return new CustomScrollView(slivers: slivers);
  }
}
