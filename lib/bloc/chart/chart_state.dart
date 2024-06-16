part of 'chart_bloc.dart';

sealed class ChartState extends Equatable {
  const ChartState();
  
  @override
  List<Object> get props => [];
}

final class ChartInitial extends ChartState {}
