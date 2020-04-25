import 'package:flutter/material.dart';

class PostTile extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.cyan[200],
      padding: const EdgeInsets.only(top: 12.0),
      margin: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 15.0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:<Widget>[
            Container(
              padding: EdgeInsets.only(left: 8.0),
              child: Text("Titlu",
              style: TextStyle(fontSize: 25)),
            ),
            Image.asset(
                'assets/images/Homepage-Design.jpg'
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text("10 Likes",
                      style: TextStyle(fontSize: 18)),
                ),
                ButtonBar(
                  children: <Widget>[
                    FlatButton(
                        onPressed: (){},
                        color: Colors.amber,
                        child: Text('Like',
                            style: TextStyle(fontSize: 18))
                    ),
                    FlatButton(
                        onPressed: (){},
                        color: Colors.amber,
                        child: Text('Comment',
                            style: TextStyle(fontSize: 18))
                    )
                  ],
                ),
              ],
            )
          ]
      ),
    );
  }
}