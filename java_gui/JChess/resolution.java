package JChess;

public enum resolution {
    CHECKMATE,        // whiteish has lost
    STALEMATE,        // draw-type
    DRAWBY50,         // 50 plies without pawn move or capture
    DRAWBYREPEAT,     // 3-fold repetition
    DRAWINSUFFICIENT, // draw by insufficient material
    NOEND             // game not over
}
