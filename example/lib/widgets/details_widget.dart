import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/provider/rx_bloc_builder.dart';

import '../bloc/details_bloc.dart';

class DetailsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Center(
                child: RxBlocBuilder<DetailsBlocType, String>(
                  state: (bloc) => bloc.states.details,
                  builder: (context, snapshot, bloc) => Text(
                    snapshot.data ?? '',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 26),
                    key: ValueKey('reload_text'),
                  ),
                ),
              ),
            ),
            RxBlocBuilder<DetailsBlocType, bool>(
              state: (bloc) => bloc.states.isLoading,
              builder: (context, snapshot, bloc) => RaisedButton(
                color: Colors.deepOrange,
                textColor: Colors.white,
                key: ValueKey('reload'),
                child: Text(snapshot.isLoaded ? 'Reload' : 'Loading...'),
                onPressed: snapshot.isLoaded ? bloc.events.fetch : null,
              ),
            )
          ],
        ),
      ),
    );
  }
}

extension _IsLoading on AsyncSnapshot {
  bool get isLoaded => hasData && data == false;
}
