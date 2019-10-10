import 'package:evangelios/Model/TextsSet.dart';
import 'package:evangelios/Widgets/LoadingWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EditScreen extends StatefulWidget {
  static final String PAGE_NAME = "EDIT_PAGE";

  EditScreen(this.texts, {Key key}) : super(key: key);

  final TextsSet texts;

  @override
  _EditScreenState createState() => _EditScreenState(texts);
}

class _EditScreenState extends State<EditScreen> {
  TextsSet _selectedTextsSet;

  _EditScreenState(this._selectedTextsSet);

  final _textFieldController = TextEditingController();

  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _textFieldController.dispose();
    super.dispose();
  }

  void _appendText(String tag) {
    setState(() {
      _textFieldController.text += tag;
      _textFieldController.selection = TextSelection.fromPosition(
          TextPosition(offset: _textFieldController.text.length));
      setState(() {});
    });
  }

  Widget _buildMainLayout(BuildContext context, TextsSet textsSet) {
    return Container(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: TextField(
            controller: this._textFieldController,
            maxLines: 99,
            decoration: InputDecoration(
              border: InputBorder.none,
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    /*
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        //statusBarColor: Theme.of(context).scaffoldBackgroundColor));
        statusBarColor: Colors.transparent));
        */
    Color buttonBarFg = Theme.of(context).primaryColorDark;
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        //centerTitle: true,
        //elevation: 0,
        iconTheme: IconThemeData(color: buttonBarFg),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showDialog(
                  //barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(
                        "Vista Previa",
                      ),
                      content: MarkdownBody(data: _textFieldController.text),
                      actions: <Widget>[
                        FlatButton(
                          child: Text("Cerrar"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    );
                  });
            },
          ),
          IconButton(
            icon: Icon(
              Icons.title,
              color: buttonBarFg,
            ),
            onPressed: () {
              if (_textFieldController.text.length == 0) {
                _appendText("# ");
              } else {
                String lastChar = _textFieldController
                    .text[_textFieldController.text.length - 1];
                _appendText(lastChar == "\n" ? "# " : "\n# ");
              }
            },
          ),
          IconButton(
            icon: Icon(
              Icons.format_bold,
              color: buttonBarFg,
            ),
            onPressed: () {
              _appendText("**");
            },
          ),
          IconButton(
            icon: Icon(
              Icons.format_italic,
              color: buttonBarFg,
            ),
            onPressed: () {
              _appendText("_");
            },
          )
        ],
      ),
      body: _selectedTextsSet != null
          ? _buildMainLayout(context, _selectedTextsSet)
          : LoadingWidget("cargando..."),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.save),
      ),
    );
  }
}