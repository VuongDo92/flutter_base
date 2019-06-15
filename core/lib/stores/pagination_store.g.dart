// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pagination_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars

mixin _$PaginationStore<T> on _PaginationStore<T>, Store {
  final _$itemsAtom = Atom(name: '_PaginationStore.items');

  @override
  ObservableList<T> get items {
    _$itemsAtom.reportObserved();
    return super.items;
  }

  @override
  set items(ObservableList<T> value) {
    _$itemsAtom.context.checkIfStateModificationsAreAllowed(_$itemsAtom);
    super.items = value;
    _$itemsAtom.reportChanged();
  }

  final _$canLoadMoreAtom = Atom(name: '_PaginationStore.canLoadMore');

  @override
  bool get canLoadMore {
    _$canLoadMoreAtom.reportObserved();
    return super.canLoadMore;
  }

  @override
  set canLoadMore(bool value) {
    _$canLoadMoreAtom.context
        .checkIfStateModificationsAreAllowed(_$canLoadMoreAtom);
    super.canLoadMore = value;
    _$canLoadMoreAtom.reportChanged();
  }

  final _$isRefreshingAtom = Atom(name: '_PaginationStore.isRefreshing');

  @override
  bool get isRefreshing {
    _$isRefreshingAtom.reportObserved();
    return super.isRefreshing;
  }

  @override
  set isRefreshing(bool value) {
    _$isRefreshingAtom.context
        .checkIfStateModificationsAreAllowed(_$isRefreshingAtom);
    super.isRefreshing = value;
    _$isRefreshingAtom.reportChanged();
  }

  final _$isLoadingMoreAtom = Atom(name: '_PaginationStore.isLoadingMore');

  @override
  bool get isLoadingMore {
    _$isLoadingMoreAtom.reportObserved();
    return super.isLoadingMore;
  }

  @override
  set isLoadingMore(bool value) {
    _$isLoadingMoreAtom.context
        .checkIfStateModificationsAreAllowed(_$isLoadingMoreAtom);
    super.isLoadingMore = value;
    _$isLoadingMoreAtom.reportChanged();
  }

  final _$paginationErrorAtom = Atom(name: '_PaginationStore.paginationError');

  @override
  Error get paginationError {
    _$paginationErrorAtom.reportObserved();
    return super.paginationError;
  }

  @override
  set paginationError(Error value) {
    _$paginationErrorAtom.context
        .checkIfStateModificationsAreAllowed(_$paginationErrorAtom);
    super.paginationError = value;
    _$paginationErrorAtom.reportChanged();
  }

  final _$refreshedAtAtom = Atom(name: '_PaginationStore.refreshedAt');

  @override
  DateTime get refreshedAt {
    _$refreshedAtAtom.reportObserved();
    return super.refreshedAt;
  }

  @override
  set refreshedAt(DateTime value) {
    _$refreshedAtAtom.context
        .checkIfStateModificationsAreAllowed(_$refreshedAtAtom);
    super.refreshedAt = value;
    _$refreshedAtAtom.reportChanged();
  }

  final _$refreshAsyncAction = AsyncAction('refresh');

  @override
  Future<dynamic> refresh(
      {Duration refreshedAtBefore = null, bool forced = false}) {
    return _$refreshAsyncAction.run(() =>
        super.refresh(refreshedAtBefore: refreshedAtBefore, forced: forced));
  }

  final _$loadMoreAsyncAction = AsyncAction('loadMore');

  @override
  Future<dynamic> loadMore() {
    return _$loadMoreAsyncAction.run(() => super.loadMore());
  }

  final _$_PaginationStoreActionController =
      ActionController(name: '_PaginationStore');

  @override
  void clear() {
    final _$actionInfo = _$_PaginationStoreActionController.startAction();
    try {
      return super.clear();
    } finally {
      _$_PaginationStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setStartRefreshing() {
    final _$actionInfo = _$_PaginationStoreActionController.startAction();
    try {
      return super.setStartRefreshing();
    } finally {
      _$_PaginationStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setStartLoadingMore() {
    final _$actionInfo = _$_PaginationStoreActionController.startAction();
    try {
      return super.setStartLoadingMore();
    } finally {
      _$_PaginationStoreActionController.endAction(_$actionInfo);
    }
  }
}
