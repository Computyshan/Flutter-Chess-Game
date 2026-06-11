import 'package:chess_sparcs/components/chess_pieces.dart';
import 'package:chess_sparcs/components/dead_pieces.dart';
import 'package:chess_sparcs/components/helper/color_values.dart';
import 'package:chess_sparcs/components/helper/helper_methods.dart';
import 'package:flutter/material.dart';
import 'components/squares_gb.dart';

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}




class _GameBoardState extends State<GameBoard> {
  // 2D list representing the ChessBoard
  late List<List<ChessPieces?>> board;
  
  //current piece being selected on board
  //if no piece then it is null
  ChessPieces? selectedPiece;
  //row index of selected piece
  // default value (-1) inidicates no pieces have been selected
  int selectedRow = -1;

  //col index of selected piece
  // default value (-1) inidicates no pieces have been selected
  int selectedCol = -1;

  //A list of valid moves  for the currently selected pieces
  //each move is represented as a list with 2 elements: row and col
  List<List<int>> validMoves = [];

  //a list of white pieces that have been killed by the black player
  List<ChessPieces> WhitePiecesKilled = [];

  //a list of black pieces klled by the white player
  List<ChessPieces> BlackPiecesKilled = []; 

  //a boolean to indicate turns
  bool isWhiteTurn = true;
  //inital position of kings
  List<int> whiteKingPosition = [7, 4];
  List<int> blackKingPosition = [0, 4];
  bool checkStatus = false;
  @override
  void initState() {
    super.initState();
    _initalizeBoard();
  }

  //Initialize Board
  void _initalizeBoard() {
    //initialize the board withe nulls, no pieces in those positions
    List<List<ChessPieces?>> Newboard = List.generate(
      8,
      (index) => List.generate(8, (index) => null),
    );

    //place pawns
    for (int i = 0; i < 8; i++) {
      Newboard[1][i] = ChessPieces(
        //black pawn
        type: ChessPieceType.pawn,
        isWhite: false,
        imagePath: 'lib/images/pawn_transparent.png',
      );
      Newboard[6][i] = ChessPieces(
        //white pawn
        type: ChessPieceType.pawn,
        isWhite: true,
        imagePath: 'lib/images/pawn_transparent.png',
      );
    }
    //place rooks
    Newboard[0][0] = ChessPieces(
      //black rook
      type: ChessPieceType.rook,
      isWhite: false,
      imagePath: 'lib/images/Rook_transparent.png',
    );
    Newboard[0][7] = ChessPieces(
      //black rook
      type: ChessPieceType.rook,
      isWhite: false,
      imagePath: 'lib/images/Rook_transparent.png',
    );
    Newboard[7][0] = ChessPieces(
      //black rook
      type: ChessPieceType.rook,
      isWhite: true,
      imagePath: 'lib/images/Rook_transparent.png',
    );
    Newboard[7][7] = ChessPieces(
      //black rook
      type: ChessPieceType.rook,
      isWhite: true,
      imagePath: 'lib/images/Rook_transparent.png',
    );
    //place knights
    Newboard[0][1] = ChessPieces(
      //black knight
      type: ChessPieceType.knight,
      isWhite: false,
      imagePath: 'lib/images/knight_transparent.png',
    );
    Newboard[0][6] = ChessPieces(
      //black knight
      type: ChessPieceType.knight,
      isWhite: false,
      imagePath: 'lib/images/knight_transparent.png',
    );
    Newboard[7][1] = ChessPieces(
      //white knight
      type: ChessPieceType.knight,
      isWhite: true,
      imagePath: 'lib/images/knight_transparent.png',
    );
    Newboard[7][6] = ChessPieces(
      //white knight
      type: ChessPieceType.knight,
      isWhite: true,
      imagePath: 'lib/images/knight_transparent.png',
    );

    //place bishops
    Newboard[0][2] = ChessPieces(
      type: ChessPieceType.bishop,
      isWhite: false,
      imagePath: 'lib/images/Bishop_transparent.png',
    );
    Newboard[0][5] = ChessPieces(
      type: ChessPieceType.bishop,
      isWhite: false,
      imagePath: 'lib/images/Bishop_transparent.png',
    );
    Newboard[7][2] = ChessPieces(
      type: ChessPieceType.bishop,
      isWhite: true,
      imagePath: 'lib/images/Bishop_transparent.png',
    );
    Newboard[7][5] = ChessPieces(
      type: ChessPieceType.bishop,
      isWhite: true,
      imagePath: 'lib/images/Bishop_transparent.png',
    );
    //place queens
    Newboard[0][3] = ChessPieces(
      type: ChessPieceType.queen,
      isWhite: false,
      imagePath: 'lib/images/queen_transparent.png',
    );
    Newboard[7][3] = ChessPieces(
      type: ChessPieceType.queen,
      isWhite: true,
      imagePath: 'lib/images/queen_transparent.png',
    );
    //place kings
    Newboard[0][4] = ChessPieces(
      type: ChessPieceType.king,
      isWhite: false,
      imagePath: 'lib/images/king_transparent.png',
    );
    Newboard[7][4] = ChessPieces(
      type: ChessPieceType.king,
      isWhite: true,
      imagePath: 'lib/images/king_transparent.png',
    );

    board = Newboard;
  }

  //User selected A piece
  void piecesSelected(int row, int col) {
    setState(() {
      //No piece has been selected yet, this is the first selection
      if (selectedPiece == null && board[row][col] != null) {
        if (board[row][col]!.isWhite == isWhiteTurn) {
          selectedPiece = board[row][col];
          selectedRow = row;
          selectedCol = col;
        }
      }
      //There is a piece already selected,but user can select another one of their pieces
      else if (board[row][col] != null &&
          board[row][col]!.isWhite == selectedPiece!.isWhite) {
        selectedPiece = board[row][col];
        selectedRow = row;
        selectedCol = col;
      }
      //if there is a piece selected and user taps on vallid square that is a valid move, then move there
      else if (selectedPiece != null &&
          validMoves.any((element) => element[0] == row && element[1] == col)) {
        movePieces(row, col);
      }

      // Only calculate valid moves if a piece is actually selected
      if (selectedPiece != null) {
        validMoves = calculatedRealValidMoves(
          selectedRow,
          selectedCol,
          selectedPiece, true
        );
      } else {
        validMoves = [];
      }
    });
  }

//MOVE PIECES
  void movePieces(int newRow, int newCol) {
    //if the new spot has an enemy piece
    if (board[newRow][newCol] != null) {
      //add the killed piece to the appropriate list
      var killedpiece = board[newRow][newCol];
      if (killedpiece!.isWhite) {
        WhitePiecesKilled.add(killedpiece);
      } else {
        BlackPiecesKilled.add(killedpiece);
      }
    }

    //check if the piece is being moved in a king
    if (selectedPiece!.type == ChessPieceType.king) {
      //update the appropriate king positon
      if (selectedPiece!.isWhite) {
        whiteKingPosition = [newRow, newCol];
      } else {
        blackKingPosition = [newRow, newCol];
      }
    }

    //move the pieces around and clear old spot of piece
    board[newRow][newCol] = selectedPiece;
    board[selectedRow][selectedCol] = null;

    //clear selection
    setState(() {
      selectedPiece = null;
      selectedRow = -1;
      selectedCol = -1;
      validMoves = [];
    });

    // Determine game state: check checkmate first, then check
    bool mated = isCheckmate(!isWhiteTurn);
    bool checked = isKingischeck(!isWhiteTurn);

    if (mated) {
      // It's checkmate — don't show "CHECK!", show the dialog instead
      checkStatus = false;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('CHECK MATE!'),
          actions: [
            TextButton(onPressed: resetGame, child: const Text('Play Again?'))
          ],
        ),
      );
    } else if (checked) {
      // King is in check but not checkmate
      checkStatus = true;
    } else {
      checkStatus = false;
    }

    //Change turns
    isWhiteTurn = !isWhiteTurn;
  }

  //Is king in check?
  bool isKingischeck(bool iswhiteKng) {
    //get position of king
      List<int> kingPosition = iswhiteKng
          ? whiteKingPosition
          : blackKingPosition;

      //Check if enemy pieces can attack the king
      for (int i = 0; i < 8; i++) {
        for (int j = 0; j < 8; j++) {
          //skip empty square and pieces of  the same color of king
          if (board[i][j] == null || board[i][j]!.isWhite == iswhiteKng) {
            continue;
          }
          List<List<int>> pieceValidmoves = calculatedRealValidMoves(
            i,
            j,
            board[i][j],false
          );
          //check if the king's position is in this piece's valid moves
          if (pieceValidmoves.any(
            (move) => move[0] == kingPosition[0] && move[1] == kingPosition[1],
          )) {
            return true;
          }
        }
      }
      return false;
    }

  //Calculate Raw Valid Moves
  List<List<int>> calculatedRawValidMoves(
    int row,
    int col,
    ChessPieces? pieces,
  ) {
    List<List<int>> candidateMoves = [];

    //different directions based on their color
    int direction = pieces!.isWhite ? -1 : 1; //up or down moves
    switch (pieces.type) {
      case ChessPieceType.pawn:
        //pawns can move forward if the square is not occupied with another piece
        if (isInBoard(row + direction, col) &&
            board[row + direction][col] == null) {
          candidateMoves.add([row + direction, col]);
        }
        //pawns can move 2 squares forward if they are at their initial position
        if ((row == 1 && !pieces.isWhite) || (row == 6 && pieces.isWhite)) {
          if (isInBoard(row + 2 * direction, col) &&
              board[row + 2 * direction][col] == null &&
              board[row + direction][col] == null) {
            candidateMoves.add([row + 2 * direction, col]);
          }
        }
        //pawns can kill diagonally
        if (isInBoard(row + direction, col - 1) &&
            board[row + direction][col - 1] != null &&
            board[row + direction][col - 1]!.isWhite != pieces.isWhite) {
          candidateMoves.add([row + direction, col - 1]);
        }
        if (isInBoard(row + direction, col + 1) &&
            board[row + direction][col + 1] != null &&
            board[row + direction][col + 1]!.isWhite != pieces.isWhite) {
          candidateMoves.add([row + direction, col + 1]);
        }
        break;
      case ChessPieceType.rook:
        //rooks move vertically and horizontally
        var directions = [
          [-1, 0], //up
          [1, 0], //down
          [0, -1], //left
          [0, 1], //right
        ];
        for (var direction in directions) {
          var i = 1;
          while (true) {
            var newRow = row + i * direction[0];
            var newCol = col + i * direction[1];
            if (!isInBoard(newRow, newCol)) {
              break;
            }
            if (board[newRow][newCol] != null) {
              if (board[newRow][newCol]!.isWhite != pieces.isWhite) {
                candidateMoves.add([newRow, newCol]); //kill as rook
              }
              break; //blocked
            }
            candidateMoves.add([newRow, newCol]);
            i++;
          }
        }
        break;
      case ChessPieceType.knight:
        //knights move in Ls and have 8 different types
        var knightMoves = [
          [-2, -1], //up 2 left 1
          [-2, 1], //up 2 right 1
          [-1, -2], //up 1 left 2
          [-1, 2], //up 1 right 2
          [1, -2], //down 1 left 2
          [1, 2], //down 1 right 2
          [2, -1], //down 2 left 1
          [2, 1], //down 2 right 1
        ];
        for (var move in knightMoves) {
          var newRow = row + move[0];
          var newCol = col + move[1];
          if (!isInBoard(newRow, newCol)) {
            continue;
          }
          if (board[newRow][newCol] != null) {
            if (board[newRow][newCol]!.isWhite != pieces.isWhite) {
              candidateMoves.add([newRow, newCol]); //kill as knight
            }
            continue; //blocked
          }
          candidateMoves.add([newRow, newCol]);
        }
        break;
      case ChessPieceType.bishop:
        //bishops move in diagonal lanes
        var directions = [
          [-1, -1], //up left
          [-1, 1], //up right
          [1, -1], // down left
          [1, 1], // down right
        ];

        for (var direction in directions) {
          var i = 1;
          while (true) {
            var newRow = row + i * direction[0];
            var newCol = col + i * direction[1];
            if (!isInBoard(newRow, newCol)) {
              break;
            }
            if (board[newRow][newCol] != null) {
              if (board[newRow][newCol]!.isWhite != pieces.isWhite) {
                candidateMoves.add([newRow, newCol]); //kill as bishop
              }
              break;
            }
            candidateMoves.add([newRow, newCol]);
            i++;
          }
        }
        break;
      case ChessPieceType.queen:
        //Queens can move in all eight Directions: up, down, left, right and all 4 diagonals
        var directions = [
          [-1, 0], //up
          [1, 0], // down
          [0, -1], // left
          [0, 1], //right
          [-1, -1], // up left
          [-1, 1], //up right
          [1, -1], //down left
          [1, 1], //down right
        ];
        for (var direction in directions) {
          var i = 1;
          while (true) {
            var newRow = row + i * direction[0];
            var newCol = col + i * direction[1];
            if (!isInBoard(newRow, newCol)) {
              break;
            }
            if (board[newRow][newCol] != null) {
              if (board[newRow][newCol]!.isWhite != pieces.isWhite) {
                candidateMoves.add([newRow, newCol]);
              }
              break; //blocked
            }
            candidateMoves.add([newRow, newCol]);
            i++;
          }
        }
        break;
      case ChessPieceType.king:
        //the King can move in all 8 directions
        var directions = [
          [-1, 0], //up
          [1, 0], // down
          [0, -1], // left
          [0, 1], //right
          [-1, -1], // up left
          [-1, 1], //up right
          [1, -1], //down left
          [1, 1], //down right
        ];
        for (var direction in directions) {
          var newRow = row + direction[0];
          var newCol = col + direction[1];
          if (!isInBoard(newRow, newCol)) {
            continue;
          }
          if (board[newRow][newCol] != null) {
            if (board[newRow][newCol]!.isWhite != pieces.isWhite) {
              candidateMoves.add([newRow, newCol]); //Kill as King
            }
            continue; //blocked
          }
          candidateMoves.add([newRow, newCol]);
        }
        break;
    }
    return candidateMoves;
  }

  //Calculate REAL Valid MOves
  List<List<int>> calculatedRealValidMoves(
    int row,
    int col,
    ChessPieces? pieces,
    bool checkSimulation,
  ) {
    List<List<int>> realValidmoves = [];
    List<List<int>> candidateMoves = calculatedRawValidMoves(row, col, pieces);

    //after all candindating moves, filter out any that would result to a king check
    if (checkSimulation) {
      for (var move in candidateMoves) {
        int endRow = move[0];
        int endCol = move[1];
        //simulates a future move to see its safe
        if (safeSimulatedMove(pieces!,row, col, endRow, endCol)) {
          realValidmoves.add(move);
        }
      }
    }else {
      realValidmoves = candidateMoves;
    }
    return realValidmoves;
  }

   //Simulate a future move to see if it checks the king
  bool safeSimulatedMove(ChessPieces pieces, int startRow, int startCol, int endRow, int endCol){
          //save current board state
          ChessPieces? originalDestinationPiece = board[endRow][endCol];

          //if the piece is the king, save its current position and update
          List<int>?originalKingPosition;
          if(pieces.type == ChessPieceType.king){
            originalKingPosition = pieces.isWhite ? whiteKingPosition : blackKingPosition;

             //update the king position
             if(pieces.isWhite){
              whiteKingPosition = [endRow, endCol];
             }else{
              blackKingPosition = [endRow, endCol];
             }

          }
          //simulate the move
            board[endRow][endCol] =pieces;
            board[startRow][startCol] = null;

          //check if own king is under attack
          bool kinginCheck = isKingischeck(pieces.isWhite);
          //restore board to original place
            board[startRow][startCol] =pieces;
            board[endRow][endCol] = originalDestinationPiece;
          //if the piece is the king, restore its original position
          if (pieces.type == ChessPieceType.king){
            if (pieces.isWhite){
              whiteKingPosition = originalKingPosition!;
            }else{
            blackKingPosition = originalKingPosition!;
            }
          }
              //if king    
          return !kinginCheck;
      }

//Is it Checkmate?
bool isCheckmate(bool iswhiteKng){
  //if the king is not in check, then its not checkmate;
  if (!isKingischeck(iswhiteKng)){
    return false;
  }

  //if there is at least one legal move for any of the player's pieces, then its not checkmate
  for(int i=0; i<8; i++){
    for (int j=0; j<8; j++){
      //skip empty squares and piecces of opposite color
      if(board[i][j] == null ||board[i][j]!.isWhite != iswhiteKng){
        continue;
      }
      List<List<int>> piecesValidmoves = calculatedRealValidMoves(i, j, board[i][j], true);

      //if this piece has any valid moves, then its not checkmate
      if(piecesValidmoves.isNotEmpty){
        return false;
      } 
    }
  }
  //if no conditions were met, then no legal moves left to make
  //checkmate!
  return true;
}
  
//Reset to new Game
void resetGame(){

  Navigator.pop(context);
  _initalizeBoard();
  checkStatus = false;
  WhitePiecesKilled.clear();
  BlackPiecesKilled.clear();
  whiteKingPosition = [7, 4];
  blackKingPosition = [0, 4];
  setState(() {});
  isWhiteTurn = true;
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundClr,
      body: Column(
        children: [
          //white pieces taken
          Expanded(
            child: GridView.builder(
              itemCount: WhitePiecesKilled.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
              ),
              itemBuilder: (context, index) => DeadPieces(
                imagePath: WhitePiecesKilled[index].imagePath,
                isWhite: true,
              ),
            ),
          ),

          //GAME STATUS
          Text(checkStatus ? "CHECK!" : ""),

          //CHESS BROAD
          Expanded(
            flex: 3,
            child: 
            
            GridView.builder(
              itemCount: 8 * 8,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 8,
              ),
              itemBuilder: (context, index) {
                //gets row and col position from square
                int row = index ~/ 8;
                int col = index % 8;

                //checker if seleceted or not
                bool isSelected = selectedRow == row && selectedCol == col;

                //CHECck if valid move
                bool isValidmove = false;
                for (var position in validMoves) {
                  //compare row and columns
                  if (position[0] == row && position[1] == col) {
                    isValidmove = true;
                  }
                }

                return SquaresGb(
                  isWhite: isWhite(index),
                  pieces: board[row][col],
                  isSelected: isSelected,
                  onTap: () => piecesSelected(row, col),
                  isValidmove: isValidmove,
                );
              },
            ),
          ),

          //Black pieces taken
          Expanded(
            child: GridView.builder(
              itemCount: BlackPiecesKilled.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
              ),
              itemBuilder: (context, index) => DeadPieces(
                imagePath: BlackPiecesKilled[index].imagePath,
                isWhite: false,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


