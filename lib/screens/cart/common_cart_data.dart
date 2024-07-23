// import 'dart:developer';
//
// import 'package:graphql_flutter/graphql_flutter.dart';
//
// import '../../models/CartDataLocalModel.dart';
//
// class CartService {
//   late final GraphQLClient client;
//
//   CartService(String graphqlEndpoint) {
//     final HttpLink httpLink = HttpLink(graphqlEndpoint);
//
//     client = GraphQLClient(
//       cache: GraphQLCache(),
//       link: httpLink,
//     );
//   }
//
//    Future<void> getCartData(String addressId) async {
//     const String fetchCartData = r'''
//       query Address {
//         address(id: 21) {
//         id
//         users_id
//         address1
//         city
//         postcode
//         fname
//         lname
//     }
//   }
//     ''';
//
//     final QueryOptions options = QueryOptions(
//       document: gql(fetchCartData),
//       variables: <String, dynamic>{
//         'address_Id': addressId,
//       },
//     );
//
//     final QueryResult result = await client.query(options);
//
//     if (result.hasException) {
//       throw Exception(result.exception.toString());
//     }
//
//     final List<dynamic> getAddress = result.data?['address'] ?? [];
//
//     log("GET ADDRESS FROM ID $getAddress");
//
//   }
// }
