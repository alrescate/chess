package JChess;
import java.awt.*;
import java.awt.event.*;
import javax.swing.*;
import java.io.*;
import javax.swing.JPanel;

import java.util.ArrayList;

public class Mainframe {
    private Board board;            // not shared elsewhere, internal representation of board state
    private BoardSurface sr;        // does the actual drawing, don't worry about it being undefined right now
    private boolean displayFlipped; // is the display currently flipped? NOTE: this doesn't refer to if the internal board is flipped
                                    // also, this refers to absolute flippedness, false = white on the bottom.
    
    private boolean canPlay;
    
    // ALL internal values are done in terms of the true representation of the board!!!!!!!!!!!!
    private int currentTarget;
    private ArrayList<Integer> currentHighlights;
    
    private JFrame frame;
    private JPanel status;
    private JLabel flippedLabel;
    private JLabel plyCountLabel;
    private JLabel scoreLabel;
    
    public Mainframe() {
    	board = new Board(ChessHelpers.defaultFEN);
    	sr = new BoardSurface(this);
    	displayFlipped = false;
    	
    	currentTarget = ChessHelpers.noTarget;
    	currentHighlights = new ArrayList<Integer>();
    	canPlay = true;
    	
    	exportDisplayMetas(); // so that the board contents appear on the screen
    	
    	// some locals are created, like fonts and colors
    	Font menuFont = new Font("monospaced", Font.BOLD, 36);
    	Font labelFont = new Font("monospaced", Font.BOLD, 28);
    	Color red = new Color(255, 0, 0);
    	Color green = new Color(0, 130, 0);
    	Color blue = new Color(0, 0, 255);
    	UIManager.put("Menu.font", menuFont);
    	UIManager.put("MenuItem.font", menuFont);
    	
    	// configure the frame
    	frame = new JFrame("Chess");
    	frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
    	frame.getContentPane().setLayout(new BorderLayout()); // BorderLayout is used for all layouts in this program
    	
    	// create a temporary, local menu bar so that it can be set up and added
    	JMenuBar jmb = new JMenuBar();
    	
    	// create menus, not filled (mostly) right now
    	JMenu jmFile    = new JMenu("File");
    	JMenu jmPlay    = new JMenu("Play");
    	JMenu jmHelp    = new JMenu("Help");
    	
    	// create menu items, much more will appear here later
    	JMenuItem jmiSave = new JMenuItem("Save");
    	JMenuItem jmiLoad = new JMenuItem("Load");
    	JMenuItem jmiExit = new JMenuItem("Exit");
    	jmFile.add(jmiSave); jmFile.add(jmiLoad); jmFile.add(jmiExit);
    	
    	JMenuItem jmiReset = new JMenuItem("Reset Game");
    	JMenuItem jmiFlip = new JMenuItem("Flip Board");
    	jmPlay.add(jmiReset);
    	jmPlay.add(jmiFlip);
    	
    	JMenuItem jmiHPlay = new JMenuItem("Help with Playing the Game");
    	JMenuItem jmiHFlip = new JMenuItem("Help with Flipping the Display");
    	JMenuItem jmiHReset = new JMenuItem("Help with Reseting the Board");
    	JMenuItem jmiHSave = new JMenuItem("Help with Saving a Current State");
    	JMenuItem jmiHLoad = new JMenuItem("Help with Loading a Saved File");
    	JMenuItem jmiHExit = new JMenuItem("Help with Exiting the GUI");
    	jmHelp.add(jmiHPlay);
    	jmHelp.add(jmiHFlip);
    	jmHelp.add(jmiHReset);
    	jmHelp.add(jmiHSave);
    	jmHelp.add(jmiHLoad);
    	jmHelp.add(jmiHExit);
    	
    	// create KeyStrokes and set them to be accelerators for the items
    	KeyStroke ksAccelSave  = KeyStroke.getKeyStroke(KeyEvent.VK_S, KeyEvent.CTRL_DOWN_MASK);
    	KeyStroke ksAccelLoad  = KeyStroke.getKeyStroke(KeyEvent.VK_L, KeyEvent.CTRL_DOWN_MASK);
    	KeyStroke ksAccelExit  = KeyStroke.getKeyStroke(KeyEvent.VK_E, KeyEvent.CTRL_DOWN_MASK);
    	KeyStroke ksAccelReset = KeyStroke.getKeyStroke(KeyEvent.VK_R, KeyEvent.CTRL_DOWN_MASK);
    	KeyStroke ksAccelFlip  = KeyStroke.getKeyStroke(KeyEvent.VK_F, KeyEvent.CTRL_DOWN_MASK);
    	
    	jmiSave.setAccelerator (ksAccelSave);
    	jmiLoad.setAccelerator (ksAccelLoad);
    	jmiExit.setAccelerator (ksAccelExit);
    	jmiReset.setAccelerator(ksAccelReset);
    	jmiFlip.setAccelerator (ksAccelFlip);
    	
    	// bind method calls to the action listeners of the menu elements
    	jmiSave.addActionListener  (new ActionListener() { @Override public void actionPerformed(ActionEvent e) { save();        }});
    	jmiLoad.addActionListener  (new ActionListener() { @Override public void actionPerformed(ActionEvent e) { load();        }});
    	jmiExit.addActionListener  (new ActionListener() { @Override public void actionPerformed(ActionEvent e) { exit();        }});
    	jmiReset.addActionListener (new ActionListener() { @Override public void actionPerformed(ActionEvent e) { resetBoard();  }});
    	jmiFlip.addActionListener  (new ActionListener() { @Override public void actionPerformed(ActionEvent e) { flipDisplay(); }});
    	jmiHPlay.addActionListener (new ActionListener() { @Override public void actionPerformed(ActionEvent e) { helpPlay();    }});
    	jmiHFlip.addActionListener (new ActionListener() { @Override public void actionPerformed(ActionEvent e) { helpFlip();    }});
    	jmiHReset.addActionListener(new ActionListener() { @Override public void actionPerformed(ActionEvent e) { helpReset();   }});
    	jmiHSave.addActionListener (new ActionListener() { @Override public void actionPerformed(ActionEvent e) { helpSave();    }});
    	jmiHLoad.addActionListener (new ActionListener() { @Override public void actionPerformed(ActionEvent e) { helpLoad();    }});
    	jmiHExit.addActionListener (new ActionListener() { @Override public void actionPerformed(ActionEvent e) { helpExit();    }});
    	
    	// add menus to bar, add bar to frame
    	jmb.add(jmFile);
    	jmb.add(new JSeparator(SwingConstants.HORIZONTAL)); // Separators are used to improve visual display
    	jmb.add(jmPlay);
    	jmb.add(new JSeparator(SwingConstants.HORIZONTAL));
    	jmb.add(jmHelp);
    	
    	frame.setJMenuBar(jmb);
    	
    	// initialize status panel, labels
    	status = new JPanel(new BorderLayout(50, 0));
    	status.setPreferredSize(new Dimension(10000, 50)); // this is so that the status label will grow itself as necessary
    	
    	flippedLabel  = new JLabel("Flipped: false");
    	plyCountLabel = new JLabel("Current Plys: 0");
    	scoreLabel    = new JLabel("Current Material Score: 0");
    	flippedLabel.setFont(labelFont);
    	plyCountLabel.setFont(labelFont);
    	scoreLabel.setFont(labelFont);
    	flippedLabel.setForeground(red);
    	plyCountLabel.setForeground(green);
    	scoreLabel.setForeground(blue);
    	status.add(flippedLabel, BorderLayout.LINE_START);
    	status.add(plyCountLabel, BorderLayout.CENTER);
    	status.add(scoreLabel, BorderLayout.LINE_END);
    	
    	// put panel/surface into frame
    	frame.getContentPane().add(status, BorderLayout.PAGE_START);
    	frame.getContentPane().add(sr, BorderLayout.CENTER);
    	
    	// display frame
    	frame.setSize(1000, 600);
    	frame.setVisible(true);
    }
    
    private void save() {
    	FileDialog fd = new FileDialog(frame, "SAVE FILE", FileDialog.SAVE);
        fd.setVisible(true);
        if ((fd.getDirectory() != null) && (fd.getFile() != null)) {
            try {
                String filename = fd.getDirectory()+fd.getFile();
                if (filename.contains(".")) {
                    BufferedWriter bw = new BufferedWriter(new FileWriter(filename));
                    bw.write(board.boardToFEN());
                    bw.close();
                }
                else {
                	BufferedWriter bw = new BufferedWriter(new FileWriter(fd.getDirectory()+fd.getFile()+".jchess"));
                    bw.write(board.boardToFEN());
                    bw.close();
                }
            }
            catch (IOException e) {
                System.out.println("Could not save to that name.");
            }
        }
    }
    private void load() {
    	FileDialog fd = new FileDialog(frame, "LOAD FILE", FileDialog.LOAD);
        fd.setVisible(true);
        if ((fd.getDirectory() != null) && (fd.getFile() != null)) {
            try {
                BufferedReader br = new BufferedReader(new FileReader(fd.getDirectory() + fd.getFile()));
                board.setFromFEN(br.readLine()); // this is an error-generator if anything goes wrong with the file
                br.close();
            } 
            catch (IOException e) {
                System.out.println("Could not load or interpret file.");
            }
        }
        exportDisplayMetas();
        redraw();
    }
    private void exit() {
    	frame.dispatchEvent(new WindowEvent(frame, WindowEvent.WINDOW_CLOSING)); // quits the game through acceptable means
    }
    private void resetBoard() {
    	board.setFromFEN(ChessHelpers.defaultFEN);
    	canPlay = true;
    	displayFlipped = false;
    	wipeDisplayMetas();
    	redraw();
    }
    private void flipDisplay() {
    	displayFlipped = !displayFlipped;
    	exportDisplayMetas();
    	redraw();
    }
    
    private void redraw() {
    	sr.revalidate();
    	sr.repaint();
    	refreshLabels();
    	status.revalidate();
    	status.repaint();
    }
    
    private void redrawLabels() {
    	status.revalidate();
    	status.repaint();
    }
    
    private void refreshLabels() {
    	// get content changes to labels
    	flippedLabel.setText("Flipped: " + ((displayFlipped)?"true":"false"));
    	plyCountLabel.setText("Plys So Far: " + Integer.toString(board.getPlyCount()));
    	double boardScore = board.getScore()/100.0;
    	if (board.getFlipped() && boardScore != 0.0) boardScore *= -1.0;
    	scoreLabel.setText("Current Material Score: " + Double.toString(boardScore));
    	
    	redrawLabels();
    }
    
    private int[] getTileContents() {
    	// postcondition: always returns the correct values to be handed off to the surface
    	int[] tc = new int[64];
    	Board temp = new Board(board);
    	if (board.getFlipped()) {
    		board.flipBoard(temp);
    	}
    	
    	// temp now contains the true state of the board - read this into tc
    	int[] squares = temp.getSquares();
    	for (int i = 0; i < 64; i++) {
    		tc[i] = squares[i];
    	}
    	
    	int t;
    	if (displayFlipped) {
    		// flip all of the positions on the board, but don't flip the colors
    		for (int i = 0; i < 32; i++) {
    			t = tc[i];
    			tc[i] = tc[ChessHelpers.rotateIndex(i)];
    			tc[ChessHelpers.rotateIndex(i)] = t;
    		}
    	}
    	
    	return tc;
    }
    
    private void exportDisplayMetas() {
    	if (displayFlipped) {
    		ArrayList<Integer> ch = new ArrayList<Integer>();
    		for (int i: currentHighlights) {
    			ch.add(ChessHelpers.rotateIndex(i));
    		}
    		sr.setHighlighted(ch);
        	sr.setTarget(ChessHelpers.rotateIndex(currentTarget));
    	}
    	else {
    		sr.setHighlighted(currentHighlights);
        	sr.setTarget(currentTarget);
    	}
    	
    	sr.setTileContents(getTileContents());
    }
    
    private void wipeDisplayMetas() {
    	currentTarget = ChessHelpers.noTarget;
    	currentHighlights = ChessHelpers.noHighlights;
    	exportDisplayMetas();
    }
    
    private void loadDisplayMetas(int square) {
    	// precondition: square is in the sense of the true state of the board
    	if (board.getFlipped()) { 
    		int index = ChessHelpers.mirrorIndex(square);
            board.enumerateMoves(index, currentHighlights);
    	    
            // current highglights is flipped right now, reverse them all.
            for (int i = 0; i < currentHighlights.size(); i++) {
            	currentHighlights.set(i, ChessHelpers.mirrorIndex(currentHighlights.get(i)));
            }
    	}
    	else {
    		board.enumerateMoves(square, currentHighlights);
    	}
    	currentTarget = square;
    	
    	exportDisplayMetas();
    }
    
    public void click(int square) {
    	if (canPlay) {
    	    if (displayFlipped) {
    	    	// if the display is mirrored, the true index clicked on was the mirror
    	    	square = ChessHelpers.rotateIndex(square);
    	    }
    	
            if (currentTarget != ChessHelpers.noTarget) {
    	    	// if there is a target, check both for clicking on it and for clicking on highlights
    	    	for (int i: currentHighlights) {
    		    	if (square == i) {
    			    		// if we clicked on a highlight, make that move
    		    		if (board.getFlipped()) {
    		    			// the board is expecting mirrored indices from what's actually stored
    		    			board.makeMove(ChessHelpers.mirrorIndex(currentTarget), ChessHelpers.mirrorIndex(square), ChessHelpers.wQueen);
    			    	}
        				else {
        					board.makeMove(currentTarget, square, ChessHelpers.wQueen);
        				}
        				
        				// update the various flags and states
    		    		
    				    board.flipBoard(board);
    				    wipeDisplayMetas();
    			    }
    		    }
    	    	
        		if (square == currentTarget) {
        			// deselect the current square, highlights
    			    wipeDisplayMetas();
    		    }
    	    }
    	    else {
        	    // if there wasn't a target
    		    int index = board.getFlipped()?ChessHelpers.mirrorIndex(square):square;
                if (board.getSquare(index) != ChessHelpers.empty && board.isWhite(index)) {
        	    	// the square wasn't empty and it was one of ours, set the target and highlights
    		   	    loadDisplayMetas(square);
        	    }
    	    }
        	
    	    redraw();
    	    
    	    resolution r = board.getGameResolution();
    		switch(r) {
    		    case DRAWBY50:
    		    	JOptionPane.showMessageDialog(null, "Game ended by 50 move rule draw!");
    		    	canPlay = false;
    		    	break;
    		    case DRAWBYREPEAT:
    		    	JOptionPane.showMessageDialog(null, "Game ended by threefold repetition draw!");
    		    	canPlay = false;
    		    	break;
    		    case STALEMATE:
    		    	JOptionPane.showMessageDialog(null, "Game ended by stalemate!");
    		    	canPlay = false;
    		    	break;
    		    case CHECKMATE:
    		    	JOptionPane.showMessageDialog(null, "Game ended by checkmate, " + (board.getFlipped()?"white":"black") + " wins!");
    		    	canPlay = false;
    		    	break;
    		    case DRAWINSUFFICIENT:
    		    	JOptionPane.showMessageDialog(null, "Game ended by insufficient material draw!");
    		    	canPlay = false;
    		    	break;
			default:
				break;
    		}
        }
    }
    
    private void helpPlay() {
    	JOptionPane.showMessageDialog(null, "Click on a piece to target it, and then click on a highlighted square to move it there!\n" + 
                                            "Click on a targeted piece to de-select it! Remember, you have to make a legal move!"); 
    }
    private void helpFlip() {
    	JOptionPane.showMessageDialog(null, "Flip the board to see it from black's perspective!" + 
                                            "KEYBIND: Ctrl+F"); 
    }
    private void helpReset() {
    	JOptionPane.showMessageDialog(null, "Reset the board to the starting position!\n" + 
                                            "KEYBIND: Ctrl+R");
    }
    private void helpSave() {
    	JOptionPane.showMessageDialog(null, "Save a current position to a file, with the extension .jchess!\n" + 
                                            "KEYBIND: Ctrl+S");
    }
    private void helpLoad() {
    	JOptionPane.showMessageDialog(null, "Load a position from a file with the extension .jchess!\n" + 
                                            "KEYBIND: Ctrl+L");
    }
    private void helpExit() {
    	JOptionPane.showMessageDialog(null, "Exit from the program!\n" + 
                                            "KEYBIND: Ctrl+E");
    }
    
    public static void main(String[] args) {
    	new Mainframe();
    }
}
