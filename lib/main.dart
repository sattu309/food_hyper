import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shop_app/screens/splash/splash_new_screen.dart';
import 'package:shop_app/screens/splash/splash_screen.dart';
import 'controllers/session_controller.dart';
import 'routes.dart';
import 'theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  final sessionController = Get.put(SessionController());
  @override
  Widget build(BuildContext context) {
    final HttpLink httpLink = HttpLink(
      'https://wpdemo.bitlogiq.co.za/graphql',
    );

    final AuthLink authLink = AuthLink(
      getToken: () async => 'Bearer ${sessionController.sessionId.value}',

    );

    final Link link = authLink.concat(httpLink,);

    final ValueNotifier<GraphQLClient> client = ValueNotifier<GraphQLClient>(
      GraphQLClient(
        link: link,
        cache: GraphQLCache(),

      ),
    );
    return GraphQLProvider(
      client: client,
      child: CacheProvider(
        child: GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'FoodHyper',
          theme: AppTheme.lightTheme(context),
          initialRoute: FoodSplash.routeName,
          routes: routes,
        ),
      ),
    );
  }
}