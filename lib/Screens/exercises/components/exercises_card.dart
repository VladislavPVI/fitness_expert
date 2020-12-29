import 'package:fit_master/domain/ExerciseTime.dart';
import 'package:flutter/material.dart';

class ExerciseCard extends StatelessWidget {
  const ExerciseCard({
    Key key,
    this.itemIndex,
    this.exercise,
    this.press,
    this.token,
  }) : super(key: key);

  final int itemIndex;
  final ExerciseTime exercise;
  final Function press;
  final String token;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 20.0 / 2,
      ),
      height: 360,
      child: InkWell(
        onTap: press,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            Container(
              height: 350,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
              ),
              child: Container(
                margin: EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                ),
              ),
            ),
            Positioned(
              top: 200,
              right: 0,
              child: Hero(
                tag: '${exercise.id}',
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  height: 150,
                  width: 220,
                  child: exercise.imageURL != null
                      ? Image.network(
                          'http://192.168.31.119:3000/app/rest/v2/files/' +
                              exercise.imageURL,
                          fit: BoxFit.cover,
                          headers: {"Authorization": 'Bearer ' + token})
                      : Image.asset(
                          exercise.image,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            ),
            Positioned(
              top: 25,
              left: 0,
              child: SizedBox(
                height: 350,
                width: size.width - 40,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        exercise.title,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 5.0),
                      child: Text(
                        exercise.description,
                        style: Theme.of(context).textTheme.button,
                      ),
                    ),
                    // it use the available space
                    // Spacer(),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.0, // 30 padding
                        vertical: 20.0 / 4, // 5 top and bottom
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(22),
                          topRight: Radius.circular(22),
                        ),
                      ),
                      child: Text(
                        exercise.type == 0
                            ? '00:' + exercise.time.toString()
                            : 'x' + exercise.time.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
