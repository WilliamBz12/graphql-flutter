import 'package:graphql_flutter/graphql_flutter.dart';

class ApiClient {
  static GraphQLClient create() {
    final httpLink =
        HttpLink('https://uncommon-maggot-51.hasura.app/v1/graphql');

    final websocketLink = WebSocketLink(
      'wss://uncommon-maggot-51.hasura.app/v1/graphql',
      config: SocketClientConfig(
          autoReconnect: true,
          inactivityTimeout: const Duration(seconds: 60),
          initialPayload: () async {
            return {
              "headers": {
                "x-hasura-admin-secret":
                    const String.fromEnvironment('HASURA_TOKEN'),
              }
            };
          }),
    );

    final authLink = AuthLink(
      getToken: () => const String.fromEnvironment('HASURA_TOKEN'),
      headerKey: 'x-hasura-admin-secret',
    );

    final defaultlink = authLink.concat(httpLink);

    final link = Link.split(
      (request) => request.isSubscription,
      websocketLink,
      defaultlink,
    );
    final cache = GraphQLCache(
      store: HiveStore(),
    );
    final client = GraphQLClient(link: link, cache: cache);
    return client;
  }
}
