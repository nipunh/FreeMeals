import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypt/encrypt.dart' as encrpt;
import 'package:pointycastle/asymmetric/api.dart' as pntcastle;

class FetchKey {
  Future<String> fetchKeyforNotification(
      DocumentReference docref, String keyType) async {
        String pvk = getPrivateKey(keyType);
    try {
      DocumentSnapshot<Map<String, dynamic>> doc = await docref.get();
      String d = doc.data()[keyType].toString();
      d = d.replaceAll("(", "");
      d = d.replaceAll(")", "");
      d = d.replaceAll(" ", "");
      d = d.trim();
      final privatekey =
          encrpt.RSAKeyParser().parse(pvk) as pntcastle.RSAPrivateKey;
      final encrypter = encrpt.Encrypter(encrpt.RSA(privateKey: privatekey));
      final decryption = encrpt.Encrypted.fromBase64(d);
      final decryptedtext = encrypter.decrypt(decryption);
      print(decryptedtext);
      return decryptedtext.trim();
    } catch (err) {
      print('error fetchkey service - fetch key for notification method = ' +
          err.toString());
      throw Exception(err);
    }
  }

    String getPrivateKey(String keyType) {
    switch (keyType) {
      case "KEY_TEST":
        return "-----BEGIN RSA PRIVATE KEY-----\n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\n-----END RSA PRIVATE KEY-----";
        break;
      case "SECRET_TEST":
        return "-----BEGIN RSA PRIVATE KEY-----\nMIIG5gIBAAKCAYEA6BAiATcOArVXx/4tBiu+j+4F2g4HMW7A4neQIdsKK7AcTzfJ\nKqiHkCIRPQeMHVH+NCcrNouUZm84iYO3eb5boffop92z0j8lBzXsdxDCimxemaRD\n3fvtBvjh4t7AUn9VoquOYuoMFXK75msay6uK+ZRWmoYn7C4ggPj4Pcu9PoGzmWdN\nHQFvsolzYTKP26CkJ5msNbzq6im6zYD1+V3eVE0149uLS3VCaYQWk8htyYGY0jx3\nh1gF0Zp8d1eiDqOhQ410kc2mRzP3vMKuUDZ1yVQ245Yyhb2bfo7bsnueHEb/x3ls\nXqK6Di36lDUasT7VACiJkKx8j2VgZhH8QB4t8U9QuxgNrzUja7BGlR2PS2D/dmHF\n+Jwsd2cRgmIvlAyH5ofjX+FnEJXWCwhfHW3/S7IaWU2mH06wCuyzLt6a96LuE5Li\n0esHKXB0VuWUYQgwmQQNYCJM4UWeYpr5UHDt30RMAyZJ2JLmBA7Rbpcgo6MyCa4p\nqZzI4ROYEUcLJXuBAgMBAAECggGBALZj/6X+1GcyikSotFB2Tzcmd7jzb5ndl4In\nQMQrOSovJ4Dnspdxj+Krs+rIpMpiqC3rXx5mxANihQgn2yu3fqOlillteajUclDh\ng/Hs3UoYdJ3DKogtOhVRxZAfTP9KD09kEOwTUd4FqEMoiQ3szLTubsbSjEwn0Oot\nREalfB7FqBf4xfX3LAgh2epZ6BFRh9OMB3rQ+b2DgMuGAU22BkkxyhpFcoyjI8h0\nxZ3vWMKYtjj+x187wo8EIbFW0gs5dMVrZu0vZ9H6rFhVKcpYc1/6iV4lz7p1M0fb\nTTWzBjcWTPHOFymXBrrr1qpAkKX/ihQnmpTvBWeCECijj4SmFrdUWD1ZsoY5qb0j\nLtexfIA5TaPGzeGwwHboaLIvQY6KUoe69jsHDbWIyvlVg2iRa14laJJDTxVrQfny\nDe6eqp7CZrKnXh05nGcoue1bDFt+9Tl8cKkT3nEQeCycl39JGjslpr9wN4+55ada\ncdp7OEB/NtveKmg9SPmIRSULqJKbAQKBwQD/TJZU8zrotHy5X5vMTCCRrbGpoVU6\n5Y1bfrAUm5HJsqV8A9urP0zqb6Pn4v81Cs2BLypbdGgHQhtkoVm10XzqY1LtOpIf\n8nyDA2tUXdGkadowsZacKD97waDL/2duw/0joAyZXlm1/O/JrdYIzdBqPPE/iD4e\njpYzVK95Joz7gZmdA7DbA47YGAlVXuU04kdjNP59acMnvY4bac1qSazROogIVV+d\nhVj5bP89f9jlfmZYuieCaG4kuw3225nlGjECgcEA6LM3XerANc5bnNpvs0sQw2wg\nSD1Jt3a6mdBGkawzkztTKYszKCml/yqaLN+tr10Q9JdCpcbYzfqbS9y7VF87l/so\nNG0vnknp0OtCi4+TVspOkAhGa2T9ddMTq8Zvyjat8t+olZIkdN8GEAx837NzwJE4\n/Ic4Rv6oDEQJc6okc8DOIOp4cPBl4VNnH70oLe+LpIW3DZlz92TCrRA9W/lpxx8p\ndPWHbBrHekST6HQ18lJN4pQbFzKZVXctGldV7NJRAoHBAN4lBEKTCtVmB4k92lFg\nhI5+dzNFQOZozCGrEQg9fhPlsP1CViiiggkUb6jc6nh7F+qq4c6Gceau7SsZAvik\nem9xUb0+09ucoh9WIFRe9oZ73PG19XmXw/WpvIMFkDjfrSsMnyns4V7r4rK44p7y\nh8GJmdpQcM0iASxVKgLfOpm2YbYwefl5FRiPgb+ZPRRRORDoEfGKz9eKp1bPL4Cm\n7wt4RNoLf5GPcKZI46fd0RuQavoVsT9WI1Euuq3s0/J4YQKBwQCIZhyLKYI3R9l9\nbLDS6KpP0n5tubcPGkIwzNvAoa6tm7WYgWagISGTG1a5/Pbi9utsY4mGgLMusbn7\n0svfnd7hrC+Z43JpFyw98NjV03frBLTeSmt0ogLL4MkEBFIctsZpud4opjxGYUA9\nggRkX9z2wGkl5OEBBF5eqjbcHJw3WYm505Z7pP4jAO9OtGLr4iD5dAOjrhJCrkZK\niV1eHyl4tXRogU8698t7iN0mAZBplQLgUC48/8TPSwceDJlqMrECgcEA3fX3aN7H\nf6xuohiPwhEf+aQkypAFNhkN7x7N5EyW7+/GFoWv2l7HvyI8uH58fuQBBzTy6Xi/\nd+T2teMbVtHcGffx3WhyGGeDDluluAV/CQori5gh91CT5hMWgSs7E+dWJquYo0Gr\nZepHHMWnLr8QUrx7UQc8MboBqlLPrcyw6d4YHQu4Yho+vNJGAnwSMaMqB8KEK4yu\ncnUrmdm3ZftmYmbPeM6eqRSILlGex6CGMQj1sbY2k1eKXcL1aAoQzRYt\n-----END RSA PRIVATE KEY-----";
        break;
      case "KEY_LIVE":
        return "-----BEGIN RSA PRIVATE KEY-----\n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\n-----END RSA PRIVATE KEY-----";
        break;
      case "SECRET_LIVE":
        return "-----BEGIN RSA PRIVATE KEY-----\n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\n-----END RSA PRIVATE KEY-----";
        break;
      case "TOKEN_DEV":
        return "-----BEGIN RSA PRIVATE KEY-----\n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\n-----END RSA PRIVATE KEY-----";
        break;
      case "TOKEN_TEST":
        return "-----BEGIN RSA PRIVATE KEY-----\n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\n-----END RSA PRIVATE KEY-----";
        break;
      case "TOKEN_PROD":
        return "-----BEGIN RSA PRIVATE KEY-----\n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\n-----END RSA PRIVATE KEY-----";
        break;
      default:
        return "Invalid Key type";
    }
  }
}

//   Future<List<String>> fetchKeyForRazorpay(
//       DocumentReference docref, List<String> keyType) async {
//     List<String> keys = [];
//     String pvk1 = getPrivateKey(keyType[0]);
//     String pvk2 = getPrivateKey(keyType[1]);
//     try {
//       DocumentSnapshot<Map<String, dynamic>> doc = await docref.get();
//       if (keyType[0] != null) {
//         String d1 = doc.data()[keyType[0]].toString();
//         d1 = d1.replaceAll("(", "");
//         d1 = d1.replaceAll(")", "");
//         d1 = d1.replaceAll(" ", "");
//         d1 = d1.trim();
//         final privatekey1 =
//             encrpt.RSAKeyParser().parse(pvk1) as pntcastle.RSAPrivateKey;
//         final encrypter1 =
//             encrpt.Encrypter(encrpt.RSA(privateKey: privatekey1));
//         final decryption1 = encrpt.Encrypted.fromBase64(d1);
//         final decryptedtext1 = encrypter1.decrypt(decryption1);
//         print(decryptedtext1);
//         keys.add(decryptedtext1.trim());
//       } else {
//         print(
//             'fetchkey service - keyType[0] passed as null to fetch key for razorpay method');
//       }
//       if (keyType[1] != null) {
//         String d2 = doc.data()[keyType[1]].toString();
//         d2 = d2.replaceAll("(", "");
//         d2 = d2.replaceAll(")", "");
//         d2 = d2.replaceAll(" ", "");
//         d2 = d2.trim();
//         final privatekey2 =
//             encrpt.RSAKeyParser().parse(pvk2) as pntcastle.RSAPrivateKey;
//         final encrypter2 =
//             encrpt.Encrypter(encrpt.RSA(privateKey: privatekey2));
//         final decryption2 = encrpt.Encrypted.fromBase64(d2);
//         final decryptedtext2 = encrypter2.decrypt(decryption2);
//         print(decryptedtext2);
//         keys.add(decryptedtext2.trim());
//       } else {
//         print(
//             'fetchkey service - keyType[1] passed as null to fetch key for razorpay method');
//       }
//       return keys;
//     } catch (err) {
//       print('error fetchkey service - fetch key for razorpay method = ' +
//           err.toString());
//       throw Exception(err);
//     }
//   }

