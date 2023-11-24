import 'package:flutter/material.dart';

class PlacesPredictionTileDesign extends StatefulWidget {

  final PredictionPlaces? predictedPlaces;

  PlacePredicitonTileDesign({this.predictedPlaces}) ;

  @override
  State<PlacesPredictionTileDesign> createState() => _PlacesPredictionTileDesignState();
}

class _PlacesPredictionTileDesignState extends State<PlacesPredictionTileDesign> {

  bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.dark;

  @override
  Widget build(BuildContext context) {
    return const ElevatedButton(
      onPressed: (){
      },
      style: ElevatedButton.styleFrom(
        primary: darkTheme ? Color.black : Colors.white,
      ),
      child: Padding(
        padding: EdgeInsets.all(8.0),
         child: Row(
          children: [
            Icon(
              Icons.add_location,
              color: darkTheme ? Colors.amber.shade400 : Colors.blue,
         ),

         SizedBox(width: 10,),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.predictedPlaces!.main_text!,
                  overflow:TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                    color: darkTheme ? Colors.amber.shade400 : Colors.blue,
                  ),
                ),
              ],
            ),
          ),

          ],
    ),
    ),
    );
  }
}
