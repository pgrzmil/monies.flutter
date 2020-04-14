import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

typedef ListItemCallback<T> = void Function(T item);
typedef ListCellCreateCallback<T> = Widget Function(T item);

class ItemsList<T> extends StatelessWidget {
  final String title;
  final List<T> items;
  final Widget emptyState;
  final Widget header;
  final AppBar appBar;
  final VoidCallback onAdd;
  final ListItemCallback<T> onEdit;
  final ListItemCallback<T> onRemove;
  final ListItemCallback<T> onCellTap;
  final ListCellCreateCallback<T> onCellCreate;
  final RefreshCallback onRefresh;
  final Widget footer;

  const ItemsList({
    Key key,
    this.title,
    this.items,
    this.onAdd,
    this.onEdit,
    this.onRemove,
    this.onCellCreate,
    this.onCellTap,
    this.emptyState,
    this.header,
    this.appBar,
    this.onRefresh,
    this.footer,
  })  : assert(onCellCreate != null),
        assert(items != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final slidableController = SlidableController();
    return Scaffold(
      appBar: appBar ?? AppBar(title: Text(title)),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        children: [
          if (header != null) header,
          if (emptyState != null && items.isEmpty) emptyState,
          Expanded(
            child: RefreshIndicator(
              key: GlobalKey<RefreshIndicatorState>(),
              onRefresh: onRefresh,
              child: ListView.separated(
                itemCount: items.length,
                separatorBuilder: (context, index) => Divider(height: 0),
                itemBuilder: (context, index) {
                  final item = items.elementAt(index);
                  final content = Slidable(
                    actionPane: SlidableBehindActionPane(),
                    actionExtentRatio: 0.25,
                    controller: slidableController,
                    child: InkWell(
                      child: onCellCreate(item),
                      onTap: () {
                        if (onCellTap != null) onCellTap(item);
                      },
                    ),
                    secondaryActions: <Widget>[
                      if (onRemove != null)
                        IconSlideAction(
                          caption: 'Remove',
                          color: Colors.redAccent,
                          icon: Icons.delete,
                          onTap: () {
                            if (onCellTap != null) onRemove(item);
                          },
                        ),
                      if (onEdit != null)
                        IconSlideAction(
                          caption: 'Edit',
                          color: Colors.greenAccent,
                          icon: Icons.edit,
                          onTap: () {
                            if (onCellTap != null) onEdit(item);
                          },
                        ),
                    ],
                  );

                  if (footer != null && index == items.length - 1) {
                    return Column(children: <Widget>[content, footer]);
                  } else {
                    return content;
                  }
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: onAdd,
      ),
    );
  }
}
