import 'package:flutter/material.dart';

class CircularProgressIndicatorCard extends StatelessWidget {
  final String name;
  final int rating;
  const CircularProgressIndicatorCard(
    this.name,
    this.rating,
  );
  @override
  Widget build(BuildContext context) {
    return Center(
      child: AspectRatio(
        aspectRatio: 1.0,
        child: Stack(
          children: <Widget>[
            Container(
              height: double.maxFinite,
              width: double.maxFinite,
              child: CircularProgressIndicator(
                value: rating / 100,
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Spacer(flex: 3),
                  Expanded(
                    flex: 4,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Text(
                        "$rating%",
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Source Sans Pro',
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Text(
                        name,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Source Sans Pro',
                            color: Colors.white,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                  Spacer(
                    flex: 4,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
