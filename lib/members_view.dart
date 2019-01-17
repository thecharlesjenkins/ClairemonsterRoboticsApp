//Also includes all search functionality classes

import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
//import 'package:firebase_ml_vision/firebase_ml_vision.dart';

import 'dart:async';

import 'all_members.dart';
import 'category_tile.dart';
import 'category.dart';
import 'backdrop.dart';
import 'member.dart';
import 'stats_display.dart';
import 'uploadNewMember.dart';

final padding = EdgeInsets.all(16.0);

const _baseColors = <ColorSwatch>[
  ColorSwatch(0xFF6AB7A8, {
    'highlight': Color(0xFF6AB7A8),
    'splash': Color(0xFF0ABC9B),
  }),
  ColorSwatch(0xFFFFD28E, {
    'highlight': Color(0xFFFFD28E),
    'splash': Color(0xFFFFA41C),
  }),
  ColorSwatch(0xFFFFB7DE, {
    'highlight': Color(0xFFFFB7DE),
    'splash': Color(0xFFF94CBF),
  }),
  ColorSwatch(0xFF8899A8, {
    'highlight': Color(0xFF8899A8),
    'splash': Color(0xFFA9CAE8),
  }),
  ColorSwatch(0xFFff6666, {
    'highlight': Color(0xFFff6666),
    'splash': Color(0xFFff9393),
  }),
  ColorSwatch(0xFF81A56F, {
    'highlight': Color(0xFF81A56F),
    'splash': Color(0xFF7CC159),
  }),
  ColorSwatch(0xFFD7C0E2, {
    'highlight': Color(0xFFD7C0E2),
    'splash': Color(0xFFCA90E5),
  }),
  ColorSwatch(0xFFCE9A9A, {
    'highlight': Color(0xFFCE9A9A),
    'splash': Color(0xFFF94D56),
    'error': Color(0xFF912D2D),
  }),
];

class MembersView extends StatefulWidget {
  final GlobalKey backdropKey;
  const MembersView({this.backdropKey});

  @override
  _MembersViewState createState() => _MembersViewState();
}

class _MembersViewState extends State<MembersView> {
  Category _defaultCategory;
  Category _selectedCategory;
  StatsDisplay statsDisplay;
  String barcode = "";

  bool _showTable = false;
  final _MembersViewSearchDelegate _delegate = _MembersViewSearchDelegate();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  var _categories = <Category>[];
  var _members = <Member>[];

  @override
  void initState() {
    print('ran');
    super.initState();
  }

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();

    await _retrieveCategories();
  }

  Future<void> _retrieveCategories() async {
    final data = AllMembers();
    final gatheredMembers = await data.getFutureMembers();

    setState(() {
      _members = gatheredMembers;
      _categories = (_members.map((member) => Category(
                name: member.name,
                color:
                    _baseColors[_members.indexOf(member) % _baseColors.length],
                icon: Icons.person,
                member: member,
              )))
          .toList();
      _defaultCategory = _categories[0];
    });
  }

  Widget _buildCategoryWidgets(Orientation deviceOrientation) {
    if (deviceOrientation == Orientation.portrait) {
      return Scrollbar(
        child: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return CategoryTile(
              category: _categories[index],
              onTap: _onCategoryTap,
            );
          },
          itemCount: _categories.length,
        ),
      );
    } else {
      return Scrollbar(
        child: GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 3.0,
          children: _categories.map((Category c) {
            return CategoryTile(category: c, onTap: _onCategoryTap);
          }).toList(),
        ),
      );
    }
  }

  /// Function to call when a [Category] is tapped.
  void _onCategoryTap(Category category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  Future<Null> _handleRefresh() async {
    await _retrieveCategories();
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(value)));
  }

  Future<void> showMenuSelection(String item) async {
//    print(item)
    switch (item) {
      case "1":
        _handleRefresh();
        break;

      case "2":
        _signOutAll();
        break;

      case "3":
        _viewMembersTable();
        break;

      default:
        showInSnackBar('You selected: $item');
        break;
    }
  }

  void _viewMembersTable() {
    setState(() {
      _showTable = true;
    });
  }

  void _signOutAll() async {
    AllMembers allMembers = AllMembers();
    int numMembers = await allMembers.signOutAll();
    showInSnackBar(
        'Signed out $numMembers ${numMembers == 1 ? 'person' : 'people'}');
  }

  Future _scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() {
        this.barcode = barcode;
      });
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'The user did not grant the camera permission!';
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException {
      setState(() => this.barcode =
          'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
    setState(() {
      //Reset backdrop
      widget.backdropKey.currentState.deactivate();
      List<Category> queryList = _categories
          .where((category) => category.member.toList().contains(barcode))
          .toList();
      if (queryList.length != 0) {
        //Check to see if search matches anything in the member and grab the first one with parameter
        _selectedCategory = queryList[0];
        //Pull up correct category widget
        widget.backdropKey.currentState.didUpdateWidget(this.widget);
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => UploadNewMember(route: true, id: barcode)),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String _searchResult = '';

    final appBar = AppBar(
      elevation: 1.0,
      title: Text(
        'Clairemonster',
        style: TextStyle(
          color: Colors.black,
          fontSize: 30.0,
        ),
      ),
      centerTitle: false,
      backgroundColor: Theme.of(context).primaryColor,
      actions: <Widget>[
        IconButton(
          tooltip: 'Search',
          icon: const Icon(Icons.search),
          onPressed: () async {
            final String selected = await showSearch<String>(
              context: context,
              delegate: _delegate,
            );
            if (selected != null && selected != _searchResult) {
              setState(() {
                _searchResult = selected.toString();
                _selectedCategory = _categories
                    .where((Category category) =>
                        category.name.contains(_searchResult))
                    .toList()[0];
              });
            }
          },
        ),
        PopupMenuButton<String>(
          onSelected: showMenuSelection,
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                    value: "Toolbar menu", child: Text('Toolbar menu')),
                PopupMenuItem<String>(
                    value: 'Right here', child: Text('Right here')),
                PopupMenuItem<String>(value: 'Hooray!', child: Text('Hooray!')),
                PopupMenuItem<String>(
                    value: '3', child: Text('View Members Table')),
                PopupMenuDivider(),
                PopupMenuItem<String>(
                    value: "1", child: Text('Clear Local Storage')),
                PopupMenuItem<String>(value: '2', child: Text('Sign Out All')),
              ],
        ),
      ],
    );

    if (_categories.isEmpty) {
      return Center(
        child: Container(
          height: 180.0,
          width: 180.0,
          child: CircularProgressIndicator(),
        ),
      );
    }

    assert(debugCheckHasMediaQuery(context));
    final listView = RefreshIndicator(
      onRefresh: _handleRefresh,
      key: _refreshIndicatorKey,
      child: Container(
        padding: EdgeInsets.only(
          left: 8.0,
          right: 8.0,
          bottom: 48.0,
        ),
        child: _buildCategoryWidgets(MediaQuery.of(context).orientation),
      ),
    );
    return Scaffold(
      appBar: appBar,
      key: _scaffoldKey,
      body: Backdrop(
        key: widget.backdropKey,
        currentCategory:
            _selectedCategory == null ? _defaultCategory : _selectedCategory,
        backPanel: listView,
        frontPanel: StatsDisplay(
          member: _selectedCategory == null
              ? _defaultCategory.member
              : _selectedCategory.member,
          color: _selectedCategory == null
              ? _defaultCategory.color
              : _selectedCategory.color,
        ),
        frontTitle: Text(
            'Statistics on ${_selectedCategory == null ? _defaultCategory.name : _selectedCategory.name}'),
        backTitle: Text('Select a Person'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _scan,
        child: Center(
          child: Image.asset(
            "assets/icons/qrcode.png",
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class _MembersViewSearchDelegate extends SearchDelegate<String> {
  final List<String> _history = <String>['Charlie Jenkins', 'Chris Middleton'];
  final _categories = <Category>[];
  var _searchedCategories = <Category>[];
  var _context;

  String _name;
  String _title;
  String _email;
  int _gradYear;
  String _id;

  Future<void> _retrieveCategories() async {
    final data = AllMembers();
    final gatheredMembers = await data.getFutureMembers();

    if (_categories.isEmpty) {
      _categories.addAll(gatheredMembers.map((Member member) => Category(
          name: member.name,
          color:
              _baseColors[gatheredMembers.indexOf(member) % _baseColors.length],
          icon: Icons.person,
          member: member)));
    }
  }

  @override
  Widget buildLeading(BuildContext context) {
    _context = context;
    _retrieveCategories();
    return IconButton(
      tooltip: 'Back',
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final Iterable<String> suggestions = query.isEmpty
        ? _history
        : (_categories.where((Category c) => '${c.name}'.startsWith(
                query))) //Finds all categories that start with query text
            .map((Category c) => c.name)
            .toList(); //Returns only the name of each category

    return _SuggestionList(
      query: query,
      suggestions: suggestions.toList(),
      onSelected: (String suggestion) {
        query = suggestion;
        showResults(context);
      },
    );
  }

  void _onCategoryTap(Category category) {
    this.close(_context, category.name);
  }

  Widget _buildCategoryWidgets(Orientation orientation, String query) {
    //Make sure to make category lowercase!!!
    _searchedCategories = (_categories.where(
            (Category category) => category.name.toLowerCase().contains(query)))
        .toList();

    if (orientation == Orientation.portrait) {
      return ListView.builder(
        itemCount: _searchedCategories.length,
        itemBuilder: (BuildContext context, int index) {
          return CategoryTile(
            category: _searchedCategories[index],
            onTap: _onCategoryTap,
          );
        },
      );
    } else {
      return GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 3.0,
        children: _searchedCategories.map((Category c) {
          return CategoryTile(category: c, onTap: _onCategoryTap);
        }).toList(),
      );
    }
  }

  void createMember() {
    if (_name != null && _title != null && _gradYear != null && _id != null) {
      AllMembers().writeMember(
          member: Member(
              name: _name,
              title: _title,
              email: _email,
              gradYear: _gradYear,
              id: _id));
    }
    this.close(_context, null);
  }

  @override
  Widget buildResults(BuildContext context) {
    //Set query and also name of category(4 lines down) to lowercase to avoid case sensitivity
    final String searched = query.toLowerCase();
    if (searched == null ||
        !(_categories
            .map((Category category) => category.name.toLowerCase())
            .toString()
            .contains(searched))) {
      return UploadNewMember(
          route: false,
          name: query,
          onSubmit: () => this.close(_context, null));
    }

    assert(debugCheckHasMediaQuery(context));
    final listView = Container(
      padding: EdgeInsets.only(
        left: 8.0,
        right: 8.0,
        bottom: 48.0,
      ),
      child:
          _buildCategoryWidgets(MediaQuery.of(context).orientation, searched),
    );
    return listView;
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    if (query.isNotEmpty) {
      return <Widget>[
        IconButton(
          tooltip: 'Clear',
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
            showSuggestions(context);
          },
        )
      ];
    }
    return null;
  }
}

class _SuggestionList extends StatelessWidget {
  const _SuggestionList({this.suggestions, this.query, this.onSelected});

  final List<String> suggestions;
  final String query;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (BuildContext context, int i) {
        final String suggestion = suggestions[i];
        return ListTile(
          leading: query.isEmpty ? const Icon(Icons.history) : const Icon(null),
          title: RichText(
            text: TextSpan(
              text: suggestion.substring(0, query.length),
              style:
                  theme.textTheme.subhead.copyWith(fontWeight: FontWeight.bold),
              children: <TextSpan>[
                TextSpan(
                  text: suggestion.substring(query.length),
                  style: theme.textTheme.subhead,
                ),
              ],
            ),
          ),
          onTap: () {
            onSelected(suggestion);
          },
        );
      },
    );
  }
}
