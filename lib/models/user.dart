import './statement.dart';

class User {
  String uid, firstName, lastName;
  String email, phoneNumber, photo;
  String referredBy, myReferral;
  int mpoints, mpointsUsed, mpointsReceived;
  List<Statement> statementList;

  User(
      {this.uid,
      this.firstName,
      this.lastName,
      this.email,
      this.phoneNumber,
      this.photo,
      this.referredBy,
      this.myReferral,
      this.mpoints,
      this.mpointsUsed,
      this.mpointsReceived,
      this.statementList});
}
