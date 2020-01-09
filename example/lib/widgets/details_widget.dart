import 'package:example/bloc/details_bloc.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/provider/rx_bloc_provider.dart';

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
                child: StreamBuilder<String>(
                  stream: RxBlocProvider.of<DetailsBlocType>(context)
                      .states
                      .details,
                  builder: (context, snapshot) => Text(
                    snapshot.data ?? '',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 26),
                  ),
                ),
              ),
            ),
            StreamBuilder<bool>(
                stream: RxBlocProvider.of<DetailsBlocType>(context)
                    .states
                    .isLoading,
                builder: (context, snapshot) {
                  return RaisedButton(
                    child: Text(snapshot.isLoaded ? 'Reload' : 'Loading...'),
                    onPressed: snapshot.isLoaded
                        ? RxBlocProvider.of<DetailsBlocType>(context)
                            .events
                            .fetch
                        : null,
                  );
                })
          ],
        ),
      ),
    );
  }
}

extension _IsLoading on AsyncSnapshot {
  bool get isLoaded => hasData && data == false;
}
