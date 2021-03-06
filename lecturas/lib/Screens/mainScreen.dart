//import 'package:flutter_html/flutter_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lecturas/Screens/commentScreen.dart';
import 'package:lecturas/Widgets/ScriptTextWidget.dart';
//import 'package:url_launcher/url_launcher.dart';

import '../Model/Settings.dart';
import 'package:provider/provider.dart';
import '../Model/TextsSet.dart';

import '../Widgets/LoadingWidget.dart';
import '../Widgets/PsalmWidget.dart';
import '../Widgets/ScriptWidget.dart';
import '../Widgets/LecturasDrawer.dart';
import 'package:flutter/material.dart';

import '../Util.dart';

class MainScreen extends StatelessWidget {
  Settings _settings;

  Widget _buildMainLayout(
      BuildContext context, TextsSet textsSet, Settings _settings) {
    double spaceForCopyRight = 10;
    TextStyle copyRightStyle = TextStyle(fontSize: 10, color: Colors.grey);
    return Theme(
      data: Theme.of(context).copyWith(
          textTheme: Util.getScaledTextTheme(context, _settings.scaleFactor)),
      child: ListView(
        children: _settings.currentTexts
            .getTextsAsObjects()
            .map((e) => ScriptTextWidget(scriptText: e))
            .toList(),
      ),
    );
  }

  Future<DateTime> _selectDate(BuildContext context, Settings _settings) async {
    final DateTime picked = await showDatePicker(
        locale: Locale('es', 'ES'),
        context: context,
        initialDate: _settings.currentTime,
        firstDate: DateTime(2018),
        lastDate: DateTime(2100));
    return picked == null ? _settings.currentTime : picked;
  }

  @override
  Widget build(BuildContext context) {
    _settings = Provider.of<Settings>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: title(context),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              FontAwesomeIcons.calendarAlt,
            ),
            onPressed: () async {
              _settings.currentTime = await _selectDate(context, _settings);
              _settings.update();
            },
          )
        ],
      ),
      body: FutureBuilder<TextsSet>(
        future: _settings.retrieveText(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (!snapshot.hasData)
            return LoadingWidget("Cargando...");
          else
            return _buildMainLayout(context, snapshot.data, _settings);
        },
      ),
      drawer: LecturasDrawer(),
      floatingActionButton:
          (_settings.getProvider().hasExtras(_settings.currentTime))
              ? FloatingActionButton(
                  child: Icon(Icons.comment),
                  onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CommentScreen()),
                    );
                  })
              : Container(),
    );
  }

/*
  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }


  void _commentBottomSheet(context, String text, Settings _settings) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            //color: Theme.of(context).scaffoldBackgroundColor,
            child: new ListView(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                      left: 16.0, right: 16.0, top: 8.0, bottom: 0.0),
                  child: Text(
                    "Comentario",
                    //textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize:
                            Theme.of(context).textTheme.bodyText1.fontSize *
                                _settings.scaleFactor),
                  ),
                ),
                Divider(),
                Html(
                  padding: EdgeInsets.only(
                      left: 16.0, right: 16.0, top: 8.0, bottom: 0.0),
                  data: text,
                  defaultTextStyle: TextStyle(
                      fontSize: Theme.of(context).textTheme.bodyText1.fontSize *
                          _settings.scaleFactor),
                ),
                Container(
                  height: 50,
                )
              ],
            ),
          );
        });
  }
  */
  Widget title(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Util.getDateSpanish(_settings.currentTime),
          maxLines: 1,
          style: TextStyle(
            color: (_settings.darkTheme)
                ? Theme.of(context).textTheme.bodyText1.color
                : Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
            //fontSize: 24
          ),
        ),
        Text(
          Util.getDayOfWeekSpanish(_settings.currentTime),
          maxLines: 1,
          style: TextStyle(
              color: (_settings.darkTheme)
                  ? Theme.of(context).textTheme.bodyText1.color
                  : Theme.of(context).primaryColor,
              fontStyle: FontStyle.italic,
              fontSize: Theme.of(context).textTheme.bodyText1.fontSize
              //fontSize: 24
              ),
        )
      ],
    );
  }
}
