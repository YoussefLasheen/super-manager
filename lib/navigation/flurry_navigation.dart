import 'package:flutter/material.dart';

class FlurryNavigation extends StatefulWidget {
  final Widget contentScreen;
  final Function menuState;

  FlurryNavigation({
    this.contentScreen, this.menuState,
  });

  @override
  _FlurryNavigationState createState() => new _FlurryNavigationState();
}

class _FlurryNavigationState extends State<FlurryNavigation>
    with TickerProviderStateMixin {
  MenuController menuController;
  Curve scaleDownCurve = new Interval(0.0, 1.0, curve: Curves.linear);
  Curve scaleUpCurve = new Interval(0.0, 1.0, curve: Curves.linear);
  Curve slideOutCurve = new Interval(0.0, 1.0, curve: Curves.elasticOut);
  Curve slideInCurve = new Interval(0.0, 1.0, curve: Curves.ease);

  @override
  void initState() {
    super.initState();
    menuController = new MenuController(
      vsync: this,
    )..addListener(() => setState(() {}));
    menuController.open();
  }

  createContentDisplay() {
    return zoomAndSlideContent(
      new Material(
        child: Stack(
          children: <Widget>[
            widget.contentScreen,
            Align(
                alignment: Alignment.bottomLeft,
                child: IconButton(
                  icon: Image.asset("assets/expan1.png"),
                  onPressed: () {
                    menuController.toggle();
                  },
                  padding: EdgeInsets.all(0),
                  iconSize: ((MediaQuery.of(context).size.width *
                          MediaQuery.of(context).size.height) /
                      15420),
                )),
          ],
        ),
      ),
    );
  }

  zoomAndSlideContent(Widget content) {
    //slidePercent is not used right now but it may be used in future versions
    var /*slidePercent, */ scalePercent;
    switch (menuController.state) {
      case MenuState.closed:
        //slidePercent = 0.0;
        scalePercent = 0.0;
        widget.menuState(false);
        break;
      case MenuState.open:
        //slidePercent = 1.0;
        scalePercent = 1.0;
        widget.menuState(true);
        break;
      case MenuState.opening:
        //slidePercent = slideOutCurve.transform(menuController.percentOpen);
        scalePercent = scaleDownCurve.transform(menuController.percentOpen);
        widget.menuState(true);
        break;
      case MenuState.closing:
        //slidePercent = slideInCurve.transform(menuController.percentOpen);
        scalePercent = scaleUpCurve.transform(menuController.percentOpen);
        widget.menuState(false);
        break;
    }
    var contentScale;
    var contentTranslation;
    double cornerRadius = 0;
    return OrientationBuilder(builder: (context, orientation) {
      contentScale = 1.0 - (0.05 * scalePercent);
      contentTranslation = menuController.state == MenuState.open ||
              menuController.state == MenuState.opening ||
              menuController.state == MenuState.closing
          ? MediaQuery.of(context).viewInsets.bottom == 0
              ? -MediaQuery.of(context).size.height * 0.265 * scalePercent
              : (-MediaQuery.of(context).viewInsets.bottom) +
                  MediaQuery.of(context).size.height * 1 / 20 * scalePercent
          : 0.0;
      cornerRadius = 50 * menuController.percentOpen;

      return new Transform(
        transform: new Matrix4.translationValues(0.0, contentTranslation, 0.0)
          ..scale(contentScale, contentScale),
        alignment: orientation == Orientation.portrait
            ? Alignment.topCenter
            : Alignment.topRight,
        child: new ClipRRect(
            borderRadius: new BorderRadius.only(
                bottomRight: Radius.circular(cornerRadius),
                bottomLeft: Radius.circular(cornerRadius)),
            child: content),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return createContentDisplay();
  }
}

class FlurryNavigationMenuController extends StatefulWidget {
  final FlurryNavigationBuilder builder;

  FlurryNavigationMenuController({
    this.builder,
  });

  @override
  FlurryNavigationMenuControllerState createState() {
    return new FlurryNavigationMenuControllerState();
  }
}

class FlurryNavigationMenuControllerState
    extends State<FlurryNavigationMenuController> {
  MenuController menuController;

  @override
  void initState() {
    super.initState();

    menuController = getMenuController(context);
    menuController.addListener(_onMenuControllerChange);
  }

  getMenuController(BuildContext context) {
    final navigationState =
        context.ancestorStateOfType(new TypeMatcher<_FlurryNavigationState>())
            as _FlurryNavigationState;
    return navigationState.menuController;
  }

  _onMenuControllerChange() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, getMenuController(context));
  }
}

typedef Widget FlurryNavigationBuilder(
    BuildContext context, MenuController menuController);

class MenuController extends ChangeNotifier {
  final TickerProvider vsync;
  final AnimationController _animationController;
  MenuState state = MenuState.closed;

  MenuController({
    this.vsync,
  }) : _animationController = new AnimationController(vsync: vsync) {
    _animationController
      ..duration = const Duration(milliseconds: 300)
      ..addListener(() {
        notifyListeners();
      })
      ..addStatusListener((AnimationStatus status) {
        switch (status) {
          case AnimationStatus.forward:
            state = MenuState.opening;
            break;
          case AnimationStatus.reverse:
            state = MenuState.closing;
            break;
          case AnimationStatus.completed:
            state = MenuState.open;
            break;
          case AnimationStatus.dismissed:
            state = MenuState.closed;
            break;
        }
        notifyListeners();
      });
  }

  get percentOpen {
    return _animationController.value;
  }

  open() {
    _animationController.forward();
  }

  close() {
    _animationController.reverse();
  }

  toggle() {
    if (state == MenuState.open) {
      close();
    } else if (state == MenuState.closed) {
      open();
    }
  }
}

enum MenuState {
  closed,
  opening,
  open,
  closing,
}
