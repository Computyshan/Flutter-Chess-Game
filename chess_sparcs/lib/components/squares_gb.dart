import 'package:chess_sparcs/components/chess_pieces.dart';
import 'package:chess_sparcs/components/helper/color_values.dart';
import 'package:flutter/material.dart';

class SquaresGb extends StatelessWidget {
  final bool isWhite;
  final ChessPieces? pieces;
  final bool isSelected;
  final bool isValidmove;
  final void Function()? onTap;

  const SquaresGb({
    super.key, 
    required this.isWhite, 
    required this.pieces, 
    required this.isSelected,
    required this.onTap,
    required this.isValidmove,
    });

  
  @override
  Widget build(BuildContext context) {

    Color? squareColor;
    //if selected square is amber
    if(isSelected){
        squareColor = Colors.amberAccent;
    }

    else if(isValidmove){
      squareColor = Colors.blueAccent;
    }
    //if not, green or light green
    else{
      squareColor = isWhite ? foregroundClr : backgroundClr;
    }

    return GestureDetector(
      onTap:  onTap,
      child: Container(
        color: squareColor,
        margin: EdgeInsets.all(isValidmove ?  6 : 0),
        child: pieces != null ? 
        Image.asset(
        pieces!.imagePath, 
        color: pieces!.isWhite ? Colors.white : const Color.fromARGB(255, 105, 1, 1),
        ) : null,
        
      ),
    );
  }
} 