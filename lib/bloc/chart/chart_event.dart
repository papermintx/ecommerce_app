part of 'chart_bloc.dart';

sealed class ChartEvent extends Equatable {
  const ChartEvent();

  @override
  List<Object> get props => [];
}

final class LoadChartFromDatabase extends ChartEvent {}

final class AddChart extends ChartEvent {
  final ProductModel product;

  const AddChart({
    required this.product,
  });

  @override
  List<Object> get props => [product];
}

final class RemoveChart extends ChartEvent {
  final ProductModel product;

  const RemoveChart({
    required this.product,
  });

  @override
  List<Object> get props => [product];
}

