bool isWhite(int index){
int x = index ~/ 8;// for Row
       int y = index % 8; // for Column

       bool isWhite =(x + y) % 2 == 0;//Alternates colors
       return isWhite;
} 

bool isInBoard(int row, int col){
  return row >= 0 && row < 8 && col >= 0 && col < 8;
}