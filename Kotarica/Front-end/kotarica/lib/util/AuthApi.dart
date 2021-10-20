import 'dart:convert';
import 'package:flutter_keychain/flutter_keychain.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:wallet_core/wallet_core.dart';

class AuthApi {
  final _secret =
      "bb98b9a57ac4091c21f90e5d45acb45cecc346dfb285acc3c0ff59166d5c3329";

  AuthApi();

  // funkcija za kreiranje tokena (poziva se pri registraciji)
  String signToken(String username, int id) {
    final jwt = JWT(
      payload: {'id': id, 'username': username},
    );

    return jwt.sign(SecretKey(_secret), expiresIn: Duration(days: 60));
  }

  // funkcija za kreiranje tokena
  String signTokenWithPayload(Map<String, dynamic> payload) {
    final jwt = JWT(
      payload: payload,
    );

    return jwt.sign(SecretKey(_secret), expiresIn: Duration(days: 60));
  }

  // funkcija za validaciju tokena (poziva se pri loginu)
  Future<void> verifyToken(String token) async {
    try {
      // Verify a token
      final jwt = JWT.verify(token, SecretKey(_secret));

      print('Payload: ${jwt.payload}');
    } on JWTExpiredError {
      print('jwt expired');
    } on JWTError catch (ex) {
      print(ex.message); // ex: invalid signature
    }
  }

  // funkcija za proveru tokena
  Future<String> checkToken(
      String username,
      DeployedContract contract,
      Web3Client client,
      ContractFunction getJson,
      ContractFunction getUserByUsername,
      EthereumAddress ownAddress) async {
    List answerList = await client.call(
      sender: ownAddress, contract: contract, function: getJson, params: [username]);
    String payload = answerList[0];

    if (payload != "") {
      List idList = await client.call(
          sender: ownAddress, contract: contract, function: getUserByUsername, params: [username]);

      if (idList[1] == true) {
        Map<String, dynamic> payloadJson =
            json.decode(payload); // string to map

        String returnedToken = signTokenWithPayload(payloadJson);
        String token =
            signToken(username, idList[0].toInt()); // calculate my token
        verifyToken(returnedToken);

        if (token.compareTo(returnedToken) == 0) return token; // returns token
      }
    }
    return null;
  }
}
