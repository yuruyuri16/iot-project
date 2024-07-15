import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sns/sns_data/sns_data.dart';

class SnsDataView extends StatelessWidget {
  const SnsDataView({super.key});

  @override
  Widget build(BuildContext context) {
    final temperature =
        context.select((SnsDataBloc bloc) => bloc.state.temperature);
    final humidity = context.select((SnsDataBloc bloc) => bloc.state.humidity);
    return Scaffold(
      body: BlocBuilder<SnsDataBloc, SnsDataState>(
        builder: (context, state) {
          if (state.status == SnsDataStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 140,
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(30)),
                        border: Border.all(width: 0.5),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Temperature:',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Text(
                            '$temperature °C',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      height: 140,
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(30)),
                        border: Border.all(width: 0.5),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Humidity:',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Text(
                            '$humidity %',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
      // body: BlocBuilder<SnsDataBloc, SnsDataState>(
      //   builder: (context, state) {
      //     return Center(
      //       child: Container(
      //         width: 200,
      //         height: 200,
      //         decoration: BoxDecoration(
      //           color: Colors.white,
      //           borderRadius: const BorderRadius.all(Radius.circular(30)),
      //           border: Border.all(width: 0.5),
      //         ),
      //         child: Column(
      //           mainAxisAlignment: MainAxisAlignment.center,
      //           mainAxisSize: MainAxisSize.min,
      //           children: [
      //             Text(
      //               'Temperature:',
      //               style: Theme.of(context).textTheme.titleLarge,
      //             ),
      //             Text(
      //               '${state.temperature} °C',
      //               style: Theme.of(context).textTheme.headlineLarge,
      //             ),
      //             const SizedBox(height: 16),
      //             Text(
      //               'Humidity:',
      //               style: Theme.of(context).textTheme.titleLarge,
      //             ),
      //             Text(
      //               '${state.humidity} %',
      //               style: Theme.of(context).textTheme.headlineLarge,
      //             ),
      //           ],
      //         ),
      //       ),
      //     );
      //   },
      // ),
    );
  }
}
