import 'package:flutter/material.dart';

typedef AnimatedIndexedWidgetBuilder = Widget Function(
  BuildContext context,
  AnimationController controller,
  Animation<double> animation,
  int index,
);

class RxAnimatedList extends StatefulWidget {
  const RxAnimatedList({
    required this.header,
    required this.pinnedHeader,
    required this.itemCount,
    required this.itemBuilder,
    this.listColor,
    this.listPadding,
    Key? key,
  }) : super(key: key);

  @override
  _RxAnimatedListState createState() => _RxAnimatedListState();

  final Widget header;
  final SliverPersistentHeaderDelegate pinnedHeader;
  final int itemCount;
  final AnimatedIndexedWidgetBuilder itemBuilder;
  final Color? listColor;
  final EdgeInsetsGeometry? listPadding;
}

class _RxAnimatedListState extends State<RxAnimatedList>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) => NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverList(
              delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) => widget.header,
                  childCount: 1),
            ),
            SliverPersistentHeader(
              pinned: true,
              floating: true,
              delegate: widget.pinnedHeader,
            ),
          ];
        },
        body: Container(
          color: widget.listColor,
          child: ListView.builder(
            itemCount: widget.itemCount,
            padding: widget.listPadding,
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
              final int count = widget.itemCount > 10 ? 10 : widget.itemCount;
              final Animation<double> animation =
                  Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                      parent: animationController,
                      curve: Interval((1 / count) * index, 1.0,
                          curve: Curves.fastOutSlowIn)));
              animationController.forward();

              return widget.itemBuilder(
                context,
                animationController,
                animation,
                index,
              );
            },
          ),
        ),
      );
}

class RxAnimatedListItem extends StatelessWidget {
  const RxAnimatedListItem({
    required this.animationController,
    required this.animation,
    this.onTap,
    required this.child,
    Key? key,
  }) : super(key: key);

  final VoidCallback? onTap;
  final AnimationController animationController;
  final Animation<double> animation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 50 * (1.0 - animation.value), 0.0),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 24, right: 24, top: 8, bottom: 16),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.6),
                      offset: const Offset(4, 4),
                      blurRadius: 16,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                  child: this.child,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
