import 'package:graphql_flutter/graphql_flutter.dart';

class ApiClient {
  static GraphQLClient create() {
    final httpLink =
        HttpLink('https://uncommon-maggot-51.hasura.app/v1/graphql');
    print("TOKEN");
    print(const String.fromEnvironment('HASURA_TOKEN'));
    final authLink = AuthLink(
      getToken: () => const String.fromEnvironment('HASURA_TOKEN'),
      headerKey: 'x-hasura-admin-secret',
    );

    final link = authLink.concat(httpLink);
    final cache = GraphQLCache();
    final client = GraphQLClient(link: link, cache: cache);
    return client;
  }
}
