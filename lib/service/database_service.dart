import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");
  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection("groups");

  //saving userdata
  Future savingUserData(String fullname, String email) async {
    return await userCollection.doc(uid).set({
      "fullname": fullname,
      "email": email,
      "groups": [],
      "profilePic": "",
      "uid": uid,
    });
  }

  //getting userdata
  Future gettingUserData(String email) async {
    QuerySnapshot snapshot =
        await userCollection.where("email", isEqualTo: email).get();
    return snapshot;
  }

  //get user groups
  getUserGroups() async {
    return userCollection.doc(uid).snapshots();
  }

  //Creating a group
  Future createGroup(String userName, String id, String groupName) async {
    DocumentReference documentReference = await groupCollection.add({
      "groupName": groupName,
      "groupIcon": "",
      "admin": "${id}_$userName",
      "members": [],
      "groupId": "",
      "recentMessage": "",
      "recentMessageSender": "",
    });

    //update the members
    await documentReference.update({
      "members": FieldValue.arrayUnion(["${uid}_$userName"]),
      "groupId": documentReference.id,
    });

    DocumentReference userDocumentReference = userCollection.doc(uid);
    return await userDocumentReference.update({
      "groups": FieldValue.arrayUnion(["${documentReference.id}_$groupName"])
    });
  }
}
