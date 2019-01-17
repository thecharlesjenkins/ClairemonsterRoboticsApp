import 'package:flutter/material.dart';
import 'all_members.dart';
import 'member.dart';

final padding = EdgeInsets.all(16.0);

class UploadNewMember extends StatefulWidget {
  final String name;
  final String title;
  final String email;
  final String id;
  final String gradYear;
  final bool route;
  final Function onSubmit;

  const UploadNewMember({
    @required this.route,
    this.onSubmit,
    this.name = "",
    this.title = "",
    this.email = "",
    this.id = "",
    this.gradYear = "",
  }) : assert(route != null);

  @override
  _UploadNewMemberState createState() => _UploadNewMemberState();
}

class _UploadNewMemberState extends State<UploadNewMember> {
  final _inputNameKey = GlobalKey(debugLabel: 'inputNameText');
  final _inputTitleKey = GlobalKey(debugLabel: 'inputTitleText');
  final _inputEmailKey = GlobalKey(debugLabel: 'inputEmailText');
  final _inputIDKey = GlobalKey(debugLabel: 'inputIDText');
  final _inputGradKey = GlobalKey(debugLabel: 'inputGradText');

  final _nameController = TextEditingController();
  final _titleController = TextEditingController();
  final _emailController = TextEditingController();
  final _idController = TextEditingController();
  final _gradYearController = TextEditingController();

  bool init = true;

  bool _nameInvalid = false;
  String _name;
  bool _titleInvalid = false;
  String _title;
  bool _emailInvalid = false;
  String _email;
  bool _gradInvalid = false;
  int _gradYear;
  bool _idInvalid = false;
  String _id;

  void _updateNameInputValue(String input) {
    if (input == null || input.isEmpty) {
      _name = '';
    } else {
      _name = input;
    }
  }

  void _updateTitleInputValue(String input) {
    if (input == null || input.isEmpty) {
      _title = '';
    } else {
      _title = input;
    }
  }

  void _updateIdInputValue(String input) {
    if (input == null || input.isEmpty) {
      _name = '';
    } else {
      _id = input;
    }
  }

  void _updateGradInputValue(String input) {
    if (input == null || input.isEmpty) {
      _gradYear = -1;
    } else {
      try {
        final inputInt = int.parse(input);
        _gradInvalid = false;
        _gradYear = inputInt;
      } on Exception catch (e) {
        print('Error: $e');
        _gradInvalid = true;
      }
    }
  }

  void _updateEmailInputValue(String input) {
    if (input == null || input.isEmpty) {
      _email = '';
    } else {
      if (input.contains('@')) {
        _emailInvalid = false;
        _email = input;
      } else {
        _emailInvalid = true;
      }
    }
  }

  void createMember() {
    if (_nameController.text != "" &&
        _titleController.text != "" &&
        _emailController.text != "" &&
        _gradYear != -1 && //Todo: implement checks for controllers
        _idController.text != "") {
      AllMembers().writeMember(
          member: Member(
        name: _nameController.text,
        title: _titleController.text,
        email: _emailController.text,
        gradYear: _gradYear,
        id: _idController.text,
      ));

      widget.onSubmit == null ? Navigator.pop(context) : widget.onSubmit();
    }
  }

  @override
  void initState() {
    setFields();
    super.initState();
  }

  void setFields() {
    //Set text fields to query

    //Set _name
    _nameController.text = widget.name;
    _updateNameInputValue(widget.name);

    //Set _title
    _titleController.text = widget.title;
    _updateTitleInputValue(widget.title);

    //Set _email
    _emailController.text = widget.email;
    _updateEmailInputValue(widget.email);

    //set _gradYear
    _gradYearController.text = widget.gradYear;
    _updateGradInputValue(widget.gradYear);

    //set _id
    _idController.text = widget.id;
    _updateIdInputValue(widget.id);
  }

  Widget buildSearches() {
//    if(!widget.route && init){
//      setFields();
//      init = false;
//      print("name: $_name");
//    }
    return Padding(
      padding: EdgeInsets.all(18.0),
      child: ListView(
        //Text
        children: [
          Text(
            '${widget.name != ""
                ? '${widget.name} is'
                : 'You are'}\n awesome. \n However, not in the system.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20.0),
          ),

          //TextField for NAME of member
          Padding(
            padding: padding,
            child: TextField(
              controller: _nameController,
              key: _inputNameKey,
              style: Theme.of(context).textTheme.display1,
              decoration: InputDecoration(
                labelStyle: Theme.of(context).textTheme.display1,
                errorText: _nameInvalid ? 'Invalid name entered' : null,
                labelText: 'Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              keyboardType: TextInputType.text,
              onChanged: _updateNameInputValue,
            ),
          ),

          //TextField for TITLE of member
          Padding(
            padding: padding,
            child: TextField(
              controller: _titleController,
              key: _inputTitleKey,
              style: Theme.of(context).textTheme.display1,
              decoration: InputDecoration(
                labelStyle: Theme.of(context).textTheme.display1,
                errorText: _titleInvalid ? 'Invalid title entered' : null,
                labelText: 'Title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              keyboardType: TextInputType.text,
              onChanged: _updateTitleInputValue,
            ),
          ),

          //TextField for EMAIL of member
          Padding(
            padding: padding,
            child: TextField(
              controller: _emailController,
              key: _inputEmailKey,
              style: Theme.of(context).textTheme.display1,
              decoration: InputDecoration(
                labelStyle: Theme.of(context).textTheme.display1,
                errorText: _emailInvalid ? 'Invalid email entered' : null,
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
              onChanged: _updateEmailInputValue,
            ),
          ),

          //TextField for GRADUATION YEAR of member
          Padding(
            padding: padding,
            child: TextField(
              controller: _gradYearController,
              key: _inputGradKey,
              style: Theme.of(context).textTheme.display1,
              decoration: InputDecoration(
                labelStyle: Theme.of(context).textTheme.display1,
                errorText: _gradInvalid ? 'Invalid year entered' : null,
                labelText: 'Year of Graduation',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              keyboardType: TextInputType.number,
              onChanged: _updateGradInputValue,
            ),
          ),

          //TextField for ID NUMBER of member
          Padding(
            padding: padding,
            child: TextField(
              controller: _idController,
              key: _inputIDKey,
              style: Theme.of(context).textTheme.display1,
              decoration: InputDecoration(
                labelStyle: Theme.of(context).textTheme.display1,
                errorText: _idInvalid ? 'Invalid name entered' : null,
                labelText: 'ID Number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              keyboardType: TextInputType.number,
              onChanged: _updateIdInputValue,
            ),
          ),

          Padding(
              padding: padding,
              child: MaterialButton(
                child: Text(
                  "Submit",
                  style: Theme.of(context).textTheme.title,
                ),
                onPressed: createMember,
                color: Theme.of(context).primaryColor,
              ))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
    );

    if (widget.route) {
      return Scaffold(
        appBar: appBar,
        body: buildSearches(),
      );
    } else {
      print(_nameController.text);
      return Container(
        child: buildSearches(),
      );
    }
  }
}
