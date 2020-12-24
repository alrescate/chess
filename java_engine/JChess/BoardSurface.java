package JChess;
import java.awt.Graphics;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.awt.image.BufferedImage;

import javax.imageio.ImageIO;
import javax.swing.JPanel;
import java.io.*;

import java.util.ArrayList;

public class BoardSurface  extends JPanel {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private final Mainframe m;
	
	private final String path = "/JavaChessImages/";
	
	private ArrayList<Integer> highlightedTiles; // array of indices at which tiles are highlighted, should be fed by enumerateMoves
	private int targetTile;                      // index at which a tile is targeted, should be fed directly by a click
	private int[] tileContents;                  // array of piece values (including empties) indicating what tiles have what pieces on them
	
	private BufferedImage lightSquareNE;
	private BufferedImage  darkSquareNE;
	private BufferedImage lightSquareTarget;
	private BufferedImage  darkSquareTarget;
	private BufferedImage lightSquareHighlighted;
	private BufferedImage  darkSquareHighlighted;
	
    private BufferedImage wPawnSprite;
    private BufferedImage wRookSprite;
    private BufferedImage wKnightSprite;
    private BufferedImage wBishopSprite;
    private BufferedImage wQueenSprite;
    private BufferedImage wKingSprite;
    
    private BufferedImage bPawnSprite;
    private BufferedImage bRookSprite;
    private BufferedImage bKnightSprite;
    private BufferedImage bBishopSprite;
    private BufferedImage bQueenSprite;
    private BufferedImage bKingSprite;
    
    private final int gbs = 76;
    
    public BoardSurface(Mainframe _m) {
    	super();
    	m = _m;
    	addMouseListener(new MouseAdapter() { 
    		public void mousePressed(MouseEvent me) {
    			int r, c;
    			r = me.getY()/gbs;
    			c = me.getX()/gbs;
    			if (ChessHelpers.rcOnBoard(r, c)) { 
    				m.click(ChessHelpers.rctoi(r, c)); 
    			}
    			else {
    				System.out.println("click not on board, at: " + me.getX()/gbs + " " + me.getY()/gbs);
    			}
    		}
    	});
    	buildImages();
    	
    	highlightedTiles = new ArrayList<Integer>();
    	targetTile = ChessHelpers.noTarget;
    	tileContents = new int[64];
    }
    
    private void buildImages() {
    	// get input streams off out of the .jar (file names may need to be adjusted!)
    	InputStream isAllSprites           = this.getClass().getResourceAsStream(path + "allsprites.png");
    	InputStream isDarkSquare           = this.getClass().getResourceAsStream(path + "darkSquare.png");
    	InputStream isDarkSquareHighlight  = this.getClass().getResourceAsStream(path + "darkSquareHighlight.png");
    	InputStream isDarkSquareTarget     = this.getClass().getResourceAsStream(path + "darkSquareTarget.png");
    	InputStream isLightSquare          = this.getClass().getResourceAsStream(path + "lightSquare.png");
    	InputStream isLightSquareHighlight = this.getClass().getResourceAsStream(path + "lightSquareHighlight.png");
    	InputStream isLightSquareTarget    = this.getClass().getResourceAsStream(path + "lightSquareTarget.png");
    	
    	BufferedImage allSprites;
    	
    	// fill in BufferedImage members
    	try {
    	    lightSquareNE          = ImageIO.read(isLightSquare);
            darkSquareNE           = ImageIO.read(isDarkSquare);
            lightSquareTarget      = ImageIO.read(isLightSquareTarget);
            darkSquareTarget       = ImageIO.read(isDarkSquareTarget);
            lightSquareHighlighted = ImageIO.read(isLightSquareHighlight);
    	    darkSquareHighlighted  = ImageIO.read(isDarkSquareHighlight);
    	    allSprites             = ImageIO.read(isAllSprites);
    	    
    	    int spritesize = 64;
    	    
    	    // split up allSprites into smaller images
    	    wKingSprite   = allSprites.getSubimage(spritesize*0, 0, spritesize, spritesize);  
    	    wQueenSprite  = allSprites.getSubimage(spritesize*1, 0, spritesize, spritesize);  
    	    wBishopSprite = allSprites.getSubimage(spritesize*2, 0, spritesize, spritesize);
    	    wKnightSprite = allSprites.getSubimage(spritesize*3, 0, spritesize, spritesize);
    	    wRookSprite   = allSprites.getSubimage(spritesize*4, 0, spritesize, spritesize);
    	    wPawnSprite   = allSprites.getSubimage(spritesize*5, 0, spritesize, spritesize);
    	    
    	    bKingSprite   = allSprites.getSubimage(spritesize*0, spritesize, spritesize, spritesize);  
    	    bQueenSprite  = allSprites.getSubimage(spritesize*1, spritesize, spritesize, spritesize);  
    	    bBishopSprite = allSprites.getSubimage(spritesize*2, spritesize, spritesize, spritesize);
    	    bKnightSprite = allSprites.getSubimage(spritesize*3, spritesize, spritesize, spritesize);
    	    bRookSprite   = allSprites.getSubimage(spritesize*4, spritesize, spritesize, spritesize);
    	    bPawnSprite   = allSprites.getSubimage(spritesize*5, spritesize, spritesize, spritesize);
    	}
    	catch (IOException e) {
    		e.printStackTrace();
    	}
    	
    } 
    
    public void setHighlighted(ArrayList<Integer> hg) {
    	highlightedTiles = hg;
    }
    
    public void setTarget(int t) {
    	targetTile = t;
    }
    
    public void setTileContents(int[] tc) {
    	tileContents = tc;
    }
    
    private void drawTileContents(int i, int r, int c, Graphics g) {
    	int piece = tileContents[i];
    	switch(piece) {
    	    case ChessHelpers.wPawn:
    	    	g.drawImage(wPawnSprite, c*gbs+4, r*gbs+4, this);
    	    	break;
    	    case ChessHelpers.wRook:
    	    	g.drawImage(wRookSprite, c*gbs+4, r*gbs+4, this);
    	    	break;
    	    case ChessHelpers.wKnight:
    	    	g.drawImage(wKnightSprite, c*gbs+4, r*gbs+4, this);
    	    	break;
    	    case ChessHelpers.wBishop:
    	    	g.drawImage(wBishopSprite, c*gbs+4, r*gbs+4, this);
    	    	break;
    	    case ChessHelpers.wQueen:
    	    	g.drawImage(wQueenSprite, c*gbs+4, r*gbs+4, this);
    	    	break;
    	    case ChessHelpers.wKing:
    	    	g.drawImage(wKingSprite, c*gbs+4, r*gbs+4, this);
    	    	break;
    	    
    	    	
    	    case ChessHelpers.bPawn:
    	    	g.drawImage(bPawnSprite, c*gbs+4, r*gbs+4, this);
    	    	break;
    	    case ChessHelpers.bRook:
    	    	g.drawImage(bRookSprite, c*gbs+4, r*gbs+4, this);
    	    	break;
    	    case ChessHelpers.bKnight:
    	    	g.drawImage(bKnightSprite, c*gbs+4, r*gbs+4, this);
    	    	break;
    	    case ChessHelpers.bBishop:
    	    	g.drawImage(bBishopSprite, c*gbs+4, r*gbs+4, this);
    	    	break;
    	    case ChessHelpers.bQueen:
    	    	g.drawImage(bQueenSprite, c*gbs+4, r*gbs+4, this);
    	    	break;
    	    case ChessHelpers.bKing:
    	    	g.drawImage(bKingSprite, c*gbs+4, r*gbs+4, this);
    	    	break;
    	    	
    	    default:
    	    	// if it's empty, don't worry about drawing a new sprite
    	    	break;
    	}
    }
    
    public void doDrawing(Graphics g) {
    	// NOTE: the Graphics object comes from above us in Panel, don't worry about how it gets in here
    	// use arrays to draw tiles, placing sprites on top of tiles
    	boolean highlighted;
    	for (int r = 0; r < 8; r++) {
    		for (int c = 0; c < 8; c++) {
    			highlighted = false;
    			int i = ChessHelpers.rctoi(r, c);
    			// check if this square is highlighted
    			for (int v: highlightedTiles) {
    			    if (i == v) { // if the current index is a highlighted tile, mark that flag
    			    	highlighted = true;
    			    	if ((((ChessHelpers.itor(i))^(ChessHelpers.itoc(i)))&1) == 0) {
    			    		// a8 is white, therefore even indices are all white
    			    		g.drawImage(lightSquareHighlighted, c*gbs, r*gbs, this);
    			    		drawTileContents(i, r, c, g);
    			    	}
    			    	else {
    			    		// all other squares are black
    			    		g.drawImage(darkSquareHighlighted, c*gbs, r*gbs, this);
    			    		drawTileContents(i, r, c, g);
    			    	}
    			    }
    			}
    			
    			// check if this square is targeted - NOTE: should be exclusive with highlighting
    			if (i == targetTile) {
    				if ((((ChessHelpers.itor(i))^(ChessHelpers.itoc(i)))&1) == 0) {
			    		// a8 is white, therefore even indices are all white
			    		g.drawImage(lightSquareTarget, c*gbs, r*gbs, this);
			    		drawTileContents(i, r, c, g);
			    	}
			    	else {
			    		// all other squares are black
			    		g.drawImage(darkSquareTarget, c*gbs, r*gbs, this);
			    		drawTileContents(i, r, c, g);
			    	}
    			}
    			
    			else if (!highlighted) {
    				// if we aren't targeted and didn't find a highlighted index, this is a normal tile
    				if ((((ChessHelpers.itor(i))^(ChessHelpers.itoc(i)))&1) == 0) {
			    		// a8 is white, therefore even indices are all white
			    		g.drawImage(lightSquareNE, c*gbs, r*gbs, this);
			    		drawTileContents(i, r, c, g);
			    	}
			    	else {
			    		// all other squares are black
			    		g.drawImage(darkSquareNE, c*gbs, r*gbs, this);
			    		drawTileContents(i, r, c, g);
			    	}
    			}
    		}
    	}
    }
    
    @Override
    public void paintComponent(Graphics g) {
    	super.paintComponent(g);
    	doDrawing(g);
    }
}
