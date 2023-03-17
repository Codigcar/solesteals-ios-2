import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:solesteals/presentation/blocs/notifications/notifications_bloc.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HomeScreen extends StatelessWidget {
  final String path;
  const HomeScreen({super.key, required this.path});

  @override
  Widget build(BuildContext context) {
    context.select((NotificationsBloc bloc) => bloc.state.status);

    return Scaffold(
      body: Container(
        color: Colors.black,
        child: SafeArea(
          child: WebView(
            initialUrl: 'https://www.solesteals.com${path}',
            javascriptMode: JavascriptMode.unrestricted,
          ),
        ),
      ),
    );
  }
}
