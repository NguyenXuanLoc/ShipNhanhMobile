// @dart = 2.9
import 'dart:core';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:popup_menu/triangle_painter.dart';
import 'package:smartship_partner/config/color/color.dart';

abstract class MenuItemProvider {
  String get menuTitle;

  Widget get menuImage;

  TextStyle get menuTextStyle;

  Widget get menuCheckSymbol;
}

class MenuItem extends MenuItemProvider {
  Widget image;
  String title;
  Widget checkSymbol;
  TextStyle textStyle;

  MenuItem({this.title, this.image, this.checkSymbol, this.textStyle});

  @override
  Widget get menuImage => image;

  @override
  String get menuTitle => title;

  @override
  TextStyle get menuTextStyle =>
      textStyle ?? TextStyle(color: Color(0xffc5c5c5), fontSize: 10.0);

  @override
  Widget get menuCheckSymbol => checkSymbol ?? Text('');
}

enum MenuType { block, oneLine }

typedef MenuClickCallback = Function(MenuItemProvider item);
typedef PopupMenuStateChanged = Function(bool isShow);

class PopupMenu {
  static var itemWidth = 72.0;
  static var itemHeight = 65.0;
  static var arrowHeight = 10.0;
  OverlayEntry _entry;
  List<MenuItemProvider> items;

  /// row count
  int _row;

  /// col count
  int _col;

  /// The left top point of this menu.
  Offset _offset;

  /// Menu will show at above or under this rect
  Rect _showRect;

  /// if false menu is show above of the widget, otherwise menu is show under the widget
  bool _isDown = true;

  /// The max column count, default is 4.
  int _maxColumn;

  /// callback
  VoidCallback dismissCallback;
  MenuClickCallback onClickMenu;
  PopupMenuStateChanged stateChanged;

  Size _screenSize; // 屏幕的尺寸

  /// Cannot be null
  static BuildContext context;

  /// style
  Color _backgroundColor;
  Color _highlightColor;
  Color _lineColor;

  /// It's showing or not.
  bool _isShow = false;

  bool get isShow => _isShow;

  MenuType _menuType;
  double _paddingVertical;
  double _paddingLeft;
  double _paddingRight;
  double _panelLeft;

  PopupMenu({MenuClickCallback onClickMenu,
    BuildContext context,
    VoidCallback onDismiss,
    int maxColumn,
    Color backgroundColor,
    Color highlightColor,
    Color lineColor,
    PopupMenuStateChanged stateChanged,
    List<MenuItemProvider> items,
    MenuType menuType,
    double paddingVertical,
    double paddingLeft,
    double paddingRight,
    double panelLeft}) {
    this.onClickMenu = onClickMenu;
    this.dismissCallback = onDismiss;
    this.stateChanged = stateChanged;
    this.items = items;
    this._maxColumn = maxColumn ?? 4;
    this._backgroundColor = backgroundColor ?? Color(0xff232323);
    this._lineColor = lineColor ?? Color(0xff353535);
    this._highlightColor = highlightColor ?? Color(0x55000000);
    this._menuType = menuType;
    this._paddingVertical = paddingVertical ?? 5.0;
    this._paddingLeft = paddingLeft ?? 8.0;
    this._paddingRight = paddingRight ?? 8.0;
    this._panelLeft = panelLeft;
    if (context != null) {
      PopupMenu.context = context;
    }
  }

  void show({Rect rect, GlobalKey widgetKey, List<MenuItemProvider> items}) {
    if (rect == null && widgetKey == null) {
      print("'rect' and 'key' can't be both null");
      return;
    }

    this.items = items ?? this.items;
    this._showRect = rect ?? PopupMenu.getWidgetGlobalRect(widgetKey);
    this._screenSize = window.physicalSize / window.devicePixelRatio;
    this.dismissCallback = dismissCallback;

    _calculatePosition(PopupMenu.context);

    _entry = OverlayEntry(builder: (context) {
      return buildPopupMenuLayout(_offset);
    });

    Overlay.of(PopupMenu.context).insert(_entry);
    _isShow = true;
    if (this.stateChanged != null) {
      this.stateChanged(true);
    }
  }

  static Rect getWidgetGlobalRect(GlobalKey key) {
    RenderBox renderBox = key.currentContext.findRenderObject();
    var offset = renderBox.localToGlobal(Offset.zero);
    return Rect.fromLTWH(
        offset.dx, offset.dy, renderBox.size.width, renderBox.size.height);
  }

  void _calculatePosition(BuildContext context) {
    _col = _calculateColCount();
    _row = _calculateRowCount();
    _offset = _calculateOffset(PopupMenu.context);
  }

  Offset _calculateOffset(BuildContext context) {
    double dx = _showRect.left + _showRect.width / 2.0 - menuWidth() / 2.0;
    if (dx < 10.0) {
      dx = 10.0;
    }

    if (dx + menuWidth() > _screenSize.width && dx > 10.0) {
      double tempDx = _screenSize.width - menuWidth() - 10;
      if (tempDx > 10) dx = tempDx;
    }

    double dy = _showRect.top - menuHeight();
    if (dy <= MediaQuery
        .of(context)
        .padding
        .top + 10) {
      // The have not enough space above, show menu under the widget.
      dy = arrowHeight + _showRect.height + _showRect.top;
      _isDown = false;
    } else {
      dy -= arrowHeight;
      _isDown = true;
    }

    return Offset(dx, dy);
  }

  double menuWidth() {
    return itemWidth * _col + _paddingLeft + _paddingRight;
  }

  // This height exclude the arrow
  double menuHeight() {
    return itemHeight * _row + _paddingVertical * 2;
  }

  LayoutBuilder buildPopupMenuLayout(Offset offset) {
    return LayoutBuilder(builder: (context, constraints) {
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          dismiss();
        },
//        onTapDown: (TapDownDetails details) {
//          dismiss();
//        },
        // onPanStart: (DragStartDetails details) {
        //   dismiss();
        // },
        onVerticalDragStart: (DragStartDetails details) {
          dismiss();
        },
        onHorizontalDragStart: (DragStartDetails details) {
          dismiss();
        },
        child: Container(
          child: Stack(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    color: AppColors.colorPopupMenuShadow,
                  ),
                  // triangle arrow
                  Positioned(
                    left: _showRect.left + _showRect.width / 2.0 - 7.5,
                    top: _isDown
                        ? offset.dy + menuHeight()
                        : offset.dy - arrowHeight,
                    child: CustomPaint(
                      size: Size(15.0, arrowHeight),
                      painter: TrianglePainter(
                          isDown: _isDown, color: _backgroundColor),
                    ),
                  ),
                  // menu content
                  Positioned(
                    left: _panelLeft ?? offset.dx,
                    top: offset.dy,
                    child: Container(
                      width: menuWidth(),
                      height: menuHeight(),
                      child: Column(
                        children: <Widget>[
                          ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Container(
                                padding: EdgeInsets.only(
                                    top: _paddingVertical,
                                    bottom: _paddingVertical,
                                    left: _paddingLeft,
                                    right: _paddingRight),
                                width: menuWidth(),
                                height: menuHeight(),
                                decoration: BoxDecoration(
                                    color: _backgroundColor,
                                    borderRadius: BorderRadius.circular(10.0)),
                                child: Column(
                                  children: _createRows(),
                                ),
                              )),
                        ],
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      );
    });
  }

  // 创建行
  List<Widget> _createRows() {
    List<Widget> rows = [];
    for (int i = 0; i < _row; i++) {
      Color color =
      (i < _row - 1 && _row != 1) ? _lineColor : Colors.transparent;
      Widget rowWidget = Container(
        decoration:
        BoxDecoration(border: Border(bottom: BorderSide(color: color))),
        height: itemHeight,
        child: Row(
          children: _createRowItems(i),
        ),
      );

      rows.add(rowWidget);
    }

    return rows;
  }

  // 创建一行的item,  row 从0开始算
  List<Widget> _createRowItems(int row) {
    List<MenuItemProvider> subItems =
    items.sublist(row * _col, min(row * _col + _col, items.length));
    List<Widget> itemWidgets = [];
    int i = 0;
    for (var item in subItems) {
      itemWidgets.add(_createMenuItem(
        item,
        i < (_col - 1),
      ));
      i++;
    }

    return itemWidgets;
  }

  // calculate row count
  int _calculateRowCount() {
    if (items == null || items.isEmpty) {
      debugPrint('error menu items can not be null');
      return 0;
    }

    var itemCount = items.length;

    if (_calculateColCount() == 1) {
      return itemCount;
    }

    var row = (itemCount - 1) ~/ _calculateColCount() + 1;

    return row;
  }

  // calculate col count
  int _calculateColCount() {
    if (items == null || items.isEmpty) {
      debugPrint('error menu items can not be null');
      return 0;
    }

    var itemCount = items.length;
    if (_maxColumn != 4 && _maxColumn > 0) {
      return _maxColumn;
    }

    if (itemCount == 4) {
      // 4个显示成两行
      return 2;
    }

    if (itemCount <= _maxColumn) {
      return itemCount;
    }

    if (itemCount == 5) {
      return 3;
    }

    if (itemCount == 6) {
      return 3;
    }

    return _maxColumn;
  }

  double get screenWidth {
    double width = window.physicalSize.width;
    double ratio = window.devicePixelRatio;
    return width / ratio;
  }

  Widget _createMenuItem(MenuItemProvider item, bool showLine) {
    return _MenuItemWidget(
      item: item,
      showLine: showLine,
      clickCallback: itemClicked,
      lineColor: _lineColor,
      backgroundColor: _backgroundColor,
      highlightColor: _highlightColor,
      menuType: _menuType,
    );
  }

  void itemClicked(MenuItemProvider item) {
    if (onClickMenu != null) {
      onClickMenu(item);
    }

    dismiss();
  }

  void dismiss() {
    if (!_isShow) {
      // Remove method should only be called once
      return;
    }

    _entry.remove();
    _isShow = false;
    if (dismissCallback != null) {
      dismissCallback();
    }

    if (stateChanged != null) {
      stateChanged(false);
    }
  }
}

class _MenuItemWidget extends StatefulWidget {
  final MenuItemProvider item;

  final bool showLine;
  final Color lineColor;
  final Color backgroundColor;
  final Color highlightColor;
  final MenuType menuType;

  final Function(MenuItemProvider item) clickCallback;

  _MenuItemWidget({this.item,
    this.showLine = false,
    this.clickCallback,
    this.lineColor,
    this.backgroundColor,
    this.highlightColor,
    this.menuType});

  @override
  State<StatefulWidget> createState() {
    return _MenuItemWidgetState();
  }
}

class _MenuItemWidgetState extends State<_MenuItemWidget> {
  var highlightColor = Color(0x55000000);
  var color = Color(0xff232323);
  var menuType;

  @override
  void initState() {
    color = widget.backgroundColor;
    highlightColor = widget.highlightColor;
    menuType = widget.menuType;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        color = highlightColor;
        setState(() {});
      },
      onTapUp: (details) {
        color = widget.backgroundColor;
        setState(() {});
      },
      onLongPressEnd: (details) {
        color = widget.backgroundColor;
        setState(() {});
      },
      onTap: () {
        if (widget.clickCallback != null) {
          widget.clickCallback(widget.item);
        }
      },
      child: Container(
          width: PopupMenu.itemWidth,
          height: PopupMenu.itemHeight,
          decoration: BoxDecoration(
              color: color,
              border: Border(
                  right: BorderSide(
                      color: widget.showLine
                          ? widget.lineColor
                          : Colors.transparent))),
          child: _createContent()),
    );
  }

  Widget _createContent() {
    switch (menuType) {
      case MenuType.block:
        return _blockMenuItem();
      case MenuType.oneLine:
        return _oneLineMenuItem();
      default:
        return _blockMenuItem();
    }
  }

  Widget _blockMenuItem() {
    if (widget.item.menuImage != null) {
      // image and text
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 30.0,
            height: 30.0,
            child: widget.item.menuImage,
          ),
          Container(
            height: 30.0,
            child: Material(
              color: Colors.transparent,
              child: Text(
                widget.item.menuTitle,
                maxLines: 2,
                style: widget.item.menuTextStyle,
              ),
            ),
          )
        ],
      );
    } else {
      // only text
      return Container(
        child: Center(
          child: Material(
            color: Colors.transparent,
            child: Text(
              widget.item.menuTitle,
              style: widget.item.menuTextStyle,
            ),
          ),
        ),
      );
    }
  }

  Widget _oneLineMenuItem() {
    if (widget.item.menuImage != null) {
      // image and text
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 22,
            alignment: Alignment.centerLeft,
            child: widget.item.menuImage,
          ),
          Expanded(
            child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    widget.item.menuTitle,
                    style: widget.item.menuTextStyle,
                  ),
                )),
          ),
          widget.item.menuCheckSymbol
        ],
      );
    } else {
      // only text
      return Row(
        children: <Widget>[
          Container(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                widget.item.menuTitle,
                style: widget.item.menuTextStyle,
              ),
          ),
          widget.item.menuCheckSymbol
        ],
      );
    }
  }
}
