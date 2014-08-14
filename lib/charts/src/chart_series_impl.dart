
part of charted.charts;

class _ChartSeries extends ChangeNotifier implements ChartSeries {
  final String name;

  Iterable<String> _measureAxisIds;
  Iterable<int> _measures;
  ChartRenderer _renderer;

  SubscriptionsDisposer _disposer = new SubscriptionsDisposer();

  _ChartSeries(this.name, Iterable<int> measures, this._renderer,
      Iterable<String> measureAxisIds) {
    this.measures = measures;
    this.measureAxisIds = measureAxisIds;
  }

  set renderer(ChartRenderer value) {
    if (value != null && value == _renderer) return;
    _renderer.clear();
    _renderer = value;
    notifyChange(new ChartSeriesChangeRecord(this));
  }

  ChartRenderer get renderer => _renderer;

  set measures(Iterable<int> value) {
    _measures = value;

    if (_measures is ObservableList) {
      _disposer.add(
          (_measures as ObservableList).listChanges.listen(_measuresChanged));
    }
  }

  Iterable<int> get measures => _measures;

  set measureAxisIds(Iterable<String> value) => _measureAxisIds = value;
  Iterable<String> get measureAxisIds => _measureAxisIds;

  _measuresChanged(_) {
    if (_measures is! ObservableList) return;
    notifyChange(new ChartSeriesChangeRecord(this));
  }
}