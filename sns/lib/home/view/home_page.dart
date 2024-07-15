import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sns/home/home.dart';
import 'package:sns/sns_data/sns_data.dart';
import 'package:sns/sns_graph/sns_graph.dart';
import 'package:sns_repository/sns_repository.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => HomeCubit()),
        BlocProvider(
          create: (_) => SnsDataBloc(
            snsRepository: context.read<SnsRepository>(),
          )..add(const SnsDataSubscriptionRequested()),
        ),
        BlocProvider(
          create: (context) => SnsGraphBloc(
            snsRepository: context.read<SnsRepository>(),
          )
            ..add(const SnsGraphFetchData())
            ..add(const SnsGraphSubscriptionRequested()),
        ),
      ],
      child: const HomeView(),
    );
  }
}
