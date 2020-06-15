import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final PanelController _panelController = PanelController();
  final FocusNode _searchFocusNode = FocusNode();
  final FocusNode _fromFocusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _fromController = TextEditingController();
  bool panelIsOpen = false;
  bool programmaticallyOpeningOrClosing = false;

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(_handleSearchFocus);
  }

  _handleSearchFocus() {
    if (_searchFocusNode.hasFocus) {
      setState(() {
        programmaticallyOpeningOrClosing = true;
      });
      this._openPanel();
      _searchFocusNode.unfocus();
      _fromFocusNode.requestFocus();
    }
  }

  _openPanel() {
    _panelController.open().then((value) => setState(() {
          programmaticallyOpeningOrClosing = false;
        }));
    setState(() {
      panelIsOpen = true;
    });
  }

  _closePanel() {
    _panelController.close().then((value) => setState(() {
          programmaticallyOpeningOrClosing = false;
        }));
    setState(() {
      panelIsOpen = false;
    });
  }

  Widget _getFormDependingPanelOpen() {
    if (panelIsOpen) {
      return Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              RaisedButton(
                child: Text('Cancel'),
                onPressed: () {
                  setState(() {
                    programmaticallyOpeningOrClosing = true;
                  });
                  this._closePanel();
                },
              )
            ],
          ),
          TextFormField(
            focusNode: _fromFocusNode,
            controller: _fromController,
            decoration: InputDecoration(hintText: 'From'),
          ),
          SizedBox(
            height: 20,
          ),
          TextFormField(
            decoration: InputDecoration(hintText: 'Destination'),
          )
        ],
      );
    } else {
      return Column(
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: _searchController,
            focusNode: _searchFocusNode,
            decoration: InputDecoration(hintText: 'Search'),
          )
        ],
      );
    }
  }

  _handlePanelSlide(double percentage) {
    if (programmaticallyOpeningOrClosing) {
      print('Here');
      return;
    }
    if (!panelIsOpen && percentage >= 0.7) {
      print('Opening');
      this._openPanel();
    } else if (panelIsOpen && percentage <= 0.5) {
      print('Closing');
      this._closePanel();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Widget form = _getFormDependingPanelOpen();

    return Scaffold(
      body: SlidingUpPanel(
        onPanelSlide: this._handlePanelSlide,
        minHeight: MediaQuery.of(context).size.height / 4,
        maxHeight: MediaQuery.of(context).size.height - 40,
        controller: _panelController,
        panel: Form(
          child: Container(
            padding: EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
            child: form,
          ),
        ),
        body: Center(
          child: Text('Sliding up panel demo'),
        ),
      ),
    );
  }
}
