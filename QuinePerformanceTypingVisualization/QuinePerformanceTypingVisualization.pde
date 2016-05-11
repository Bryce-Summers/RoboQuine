PImage img;

/*
 * This program visualizes a text 'non' editor that allows my robot to type out its program in the Bryce Plotter Language.
 *
 * Please refer to the 'plan_and_notes.txt' for information about operating the plotter,
 * orientation, alginment, the coordinate system, etc.
 *
 * Please refer to the 'Program.txt' file for theoreoretical and linguistic information about the Quine program.
 *
 * ASSUMPTIONS:
 * 1. The plotter needs to start zeroed out to the location of the left arrow key on the keyboard
 * 2. The keyboard needs to be properly aligned with the plotter and be of the correct type.
 * 3. All commands are in absolute coordinates.
 */
 
// These programming lines function like linked lists.
Program_Line start, current, last;
PFont myFont;

void setup() {
  fullScreen();
  
  // Prepare the Program for drawing Monospaced, programming styled letters.
  myFont = createFont("consolas", 32);
  textFont(myFont);
  textAlign(CENTER, CENTER);
  
  initialize_program_text();
  img = loadImage("logo.png");

}

void initialize_program_text()
{

  start   = new Program_Line("//Self-referential typings.", 0, false);
  current = start;
  last = start;
  
  /* Here is the well commented and explained version of the QUINE code, written in the Bryce Summers plotter language.
  
  # P represents a text repository function that provids strings that may 
    be printed through the contrived syntex of the Bryce Summers plotter language.
    | P:
   0|   "P:"
   1|   "."
   2|   "L:" # Lambda Function.
   3|   ">""
   4|   "i"
   5|   ">""
   6|   "."
   7|   "P[0]"
   8|   "L[P[0,10]]"
   9|   "P[1]"
  10|   "P[2,10]"
    | .

  # L represents a simple lambda function for mapping inputs to their enclosed quotation.
  # Perhaps L stands for Lambda?
  # >X means type X.
  
    | L:
   0|   >"
   1|   i
   2|   >"
   3| .
  
  P[0]       # Opening code of P function.
  L[P[0, 10]]# Print the strings in quotations, using the L lambda expression.
  P[1]       # Print the closing '.' at the end of P.
  P[2, 10]   # Print L and these final operation commands.
  */
  
  /* Here is the condensed real version of the quine code, without comments and line numberings.
  P:
    "P:"
    "."
    "L:"
    ">""
    "i"
    ">""
    "."
    "P[0]"
    "L[P[0,10]]"
    "P[1]"
    "P[2,10]"
  .
  L:
    >"
    i
    >"
  .
  P[0]
  L[P[0, 10]]
  P[1]
  P[2, 10]
  */
  
  T("P:");
  T(2,"\"P:\"");
  T(2,"\".\"");
  T(2,"\"L:\"");
  T(2,"\">\"\"");
  T(2,"\"i\"");
  T(2,"\">\"\"");
  T(2,"\".\"");
  T(2,"\"P[0]\"");
  T(2,"\"L[P[0,10]]\"");
  T(2,"\"P[1]\"");
  T(2,"\"P[2,10]\"");
  T(".");

  C("//Quotation mark typing.");
  T("L:");
  T(2,">\"");
  T(2,"i");
  T(2,">\"");
  T(".");
  C("");
  C("//Type this program.");
  T("P[0]");
  T("L[P[0,10]]");
  T("P[1]");
  T("P[2,10]");

}

public void draw()
{
  background(0);
  start.draw(32, 32*3, true, -1);
  
  fill(137, 180, 248);
  rect(8, 8, width - 32, 48);
  fill(0);
  text("Robotic Quine, by Bryce Summers", width/2, 32);

  
  image(img, 1500, 850);
  
  fill(247, 138, 138);
  int y = height - 32*3;
  int offset = 64*8;
  rect(offset, y + 8, width - offset*2, 48);
  fill(0);
  text("Frank-Ratchye Fund for Art @ the Frontier", width/2, y + 32);

  time++;
  
  // Handle type strokes only once, per potential batch of them.
  if(type && current != null)
  {   
    current = current.type();
    type = false;
    release = true;
    last_time = time;
  }
}

int last_time = 0;
int time = 0;
int keyPressed_time = 0;
boolean type = false;
boolean release = true;

void keyPressed()
{
  if(release)
  {
    keyPressed_time = time;
    release = false;
  }
}

void keyReleased()
{

  
  // The processing will be handled in the draw function to avoid race conditions.
  if(current != null && time > keyPressed_time + 15 && !release && !type)
  {
    type = true;
  }
  
}

void T(String str)
{
 T(0, str);
}

// Adds a programming line to the visualization.
void T(int offset, String str)
{
  addLine(str, offset, true);
}

void C(String str)
{
  addLine(str, 0, false);
}

void addLine(String str, int offset, boolean code)
{
  last.next = new Program_Line(str, offset, code);
  last = last.next;
}