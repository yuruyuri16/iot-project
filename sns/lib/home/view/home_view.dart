import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sns/home/home.dart';
import 'package:sns/sns_data/sns_data.dart';
import 'package:sns/sns_graph/sns_graph.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedTab = context.select((HomeCubit cubit) => cubit.state.index);
    return Scaffold(
      appBar: AppBar(title: const Text('SNS')),
      body: IndexedStack(
        index: selectedTab,
        children: const [
          SnsDataView(),
          SnsGraphView(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedTab,
        onTap: (index) => context.read<HomeCubit>().setTab(index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.cloud),
            label: 'Real Time Climate',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Graph',
          ),
        ],
      ),
    );
  }
}
