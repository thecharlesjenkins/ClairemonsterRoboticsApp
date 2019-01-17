import 'member.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _members = [
  Member(
    name: 'Charlie Jenkins',
    title: 'Captain',
    email: 'sandiegocharlie@gmail.com',
    id: "51558",
    gradYear: 2019,
  ),
  Member(
    name: 'Chris Middleton',
    title: 'Programmer and Builder',
    email: 'middletonchris22@gmail.com',
    id: "12345",
    gradYear: 2019,
  )
];

class AllMembers {
//  Future<List<Member>> getMembers(BuildContext context) async {
////    await clear();
//    var allMembers;
//
//    String fileString = await readFile();
//    Map<String, dynamic> map = await jsonFile(fileString);
//
//    if (fileString == "error") {
//      //Convert data from file into individual members
//      return null;
//    } else if (fileString == "empty") {
//      //Need to write to file
//      File file = await writeMember(membersList: _members);
//      map = json.decode(await (file).readAsString());
//    }
//    allMembers = map["Members"]
//        .map<Member>((dynamic data) => Member.fromJson(data))
//        .toList();
//
//    return allMembers;
//  }

//  Stream<List<Member>> getFireMembers(BuildContext context) {
//    Firestore.instance.collection('members').snapshots().map(
//            (snapshot) => snapshot.documents
//            .map((document) => Member.fromJson(document.data))).listen((members) => members.map((member) => print(member.toString())));
//
//    return Firestore.instance.collection('members').snapshots().map(
//        (snapshot) => snapshot.documents
//            .map((document) => Member.fromJson(document.data)));
//  }

  Future<List<Member>> getFutureMembers() async {
    List<Member> members = await Firestore.instance
        .collection('members')
        .getDocuments()
        .then((snapshot) => snapshot.documents
            .map((document) => Member.fromJson(document.data))
            .toList());
    if (members != null) {
      return members;
    } else {
      return members;
    }
  }

  Future<int> signOutAll() async {
    List<Member> currentMembers = await getFutureMembers();
    int number = 0;
    for (var member in currentMembers) {
      if (member.signOut()) number++;
    }
    writeMember(membersList: currentMembers);
    return number;
  }

//  Future<String> get _localPath async {
//    final directory = await getApplicationDocumentsDirectory();
//    return directory.path;
//  }

//  Future<File> get _localFile async {
//    final path = await _localPath;
//    return File('$path/members.txt');
//  }

  //Initialize with member OR membersList but not both
//  Future<File> writeMember({Member member, List<Member> membersList}) async {
//    final file = await _localFile;
//    Map<String, dynamic> data = await jsonFile(await readFile());
//    String writeData = "";
//    var append;
//    if (data == null) {
//      //If the data from file is null, write the backups
//      Map newData = createStructure();
//      List<Map<String, dynamic>> dataList =
//      _members.map((member) => member.toJson()).toList();
//      newData["Members"].addAll(dataList);
//      writeData = json.encode(newData);
//    } else if (member != null) {
//      //If the member variable is populated, append it to the file
//      append = member.toJson();
//      data["Members"].add(append);
//      writeData = json.encode(data);
//    } else if (membersList != null) {
//      //If the membersList variable is populated, append it to the file
//      List<Map<String, dynamic>> dataList = data['Members'] as List;
//      dataList.addAll(membersList.map((member) => member.toJson()).toList());
//      writeData = json.encode(dataList);
//    }
//      print("Wrote $writeData");
//    // Write the file
//    return await file.writeAsString(writeData);
//  }

  //Initialize with member OR membersList but not both
  Future<bool> writeMember({Member member, List<Member> membersList}) async {
    List<Member> allMembers = await getFutureMembers();

    if (allMembers.contains(member)) {
      Firestore.instance.settings(timestampsInSnapshotsEnabled: true);
      Firestore.instance.runTransaction((transaction) async {
        DocumentSnapshot freshSnap = await transaction.get(
            Firestore.instance.collection('members').document('${member.id}'));
        await transaction.update(freshSnap.reference, member.toJson());
      });
    } else if (member != null) {
      Firestore.instance
          .collection('members')
          .document('${member.id}')
          .setData(member.toJson());
    } else if (membersList != null) {
      membersList.forEach((m) => Firestore.instance
          .collection('members')
          .document('${m.id}')
          .setData(m.toJson()));
    } else {
      return false;
    }
    return true;
  }

//  Future<File> updateMember(Member member) async {
//    final file = await _localFile;
//    Map<String, dynamic> data = await jsonFile(await readFile());
//
//    Map<String, dynamic> item =
//        data["Members"].singleWhere((map) => map["name"] == member.name);
//    int index = data["Members"].indexOf(item);
//    if (data != null && item != null) {
//      item = member.toJson();
//      data["Members"][index] = item;
//    }
//
//    return await file.writeAsString(json.encode(data));
//  }

//  Future<String> readFile() async {
//    try {
//      final file = await _localFile;
//      // Read the file
//      String contents = await file.readAsString();
//      if (contents == "[]" || contents.isEmpty) {
//        return "empty";
//      } else {
//        return contents;
//      }
//    } catch (e) {
//      // If we encounter an error, return "error"
//      print("error");
//      return "error";
//    }
//  }

//  Future<Map> jsonFile(String string) async {
//    var data;
//    try {
//      data = json.decode(string);
//      if (data is! Map) {
//        throw ('Data retrieved from JSON is not a Map');
//      }
//    } catch (e) {
//      return null;
//    }
//    return data;
//  }

//  Future<void> clear() async {
//    final file = await _localFile;
//    file.writeAsString('');
//  }

//  Map<String, dynamic> createStructure([String initial]) {
//    return json.decode('{ "Members": [] }');
//  }
}
