import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Страница не найдена'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FittedBox(
              fit: BoxFit.cover,
              child: Text(
                '404',
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height * 0.3,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.bodyText1.color,
                ),
              ),
            ),
            Text(
              'Ooops!!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).textTheme.bodyText1.color,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "THAT PAGE DOESN'T EXIST OR IS UNAVAILABLE.",
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).textTheme.bodyText1.color,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            RaisedButton(
              onPressed: () => Navigator.pop(context),
              color: Theme.of(context).accentColor,
              textColor: Theme.of(context).textTheme.headline5.color,
              child: Text('Go Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}