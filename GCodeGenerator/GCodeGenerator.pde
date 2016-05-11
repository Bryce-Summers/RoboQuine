PrintWriter output;

/*
 * This is a helpful program used to generate GCode for my 2D plotter.
 * We will be generating the GCode machine code implementation of my 
 * Bryce Summers Plotter Language.
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

void setup() {
  // Create a new file in the sketch directory.
  output = createWriter("Quine_GCode.txt");
  
  // Only run the program once.
  noLoop();
}

void draw()
{
  HEAD_UP();
  
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
  T("\"P:\"");
  T("\".\"");
  T("\"L:\"");
  T("\">\"\"");
  T("\"i\"");
  T("\">\"\"");
  T("\".\"");
  T("\"P[0]\"");
  T("\"L[P[0,10]]\"");
  T("\"P[1]\"");
  T("\"P[2,10]\"");
  T(".");
  
  T("L:");
  T(">\"");
  T("i");
  T(">\"");
  T(".");
  
  T("P[0]");
  T("L[P[0,10]]");
  T("P[1]");
  T("P[2,10]");
  
  // Very Important!
  HEAD_UP();
  
  output.flush();
  output.close();
}

// Maps an entire string to a list of GCode commands.
void T(String str)
{
  char[] letters = str.toCharArray();
  int len = letters.length;
  for(int i = 0; i < len; i++)
  {
    TYPE(letters[i]);
  }
}

// Maps characters to actual GCode commands.
void TYPE(char c)
{
  switch(c)
  {
    // Print (i.e. 'type') command.
    case 'P': TYPE(-180, 120); break;
    case ':': TYPE(-170, 80);  break;
    case '\'': // "
    case '"': TYPE(-130, 80);  break;
    case '.': TYPE(210, 0);    break;// NUMPAD.
    case 'L': TYPE(-210, 80);  break;
    case '>': TYPE(-180, 40);  break;
    case '[': TYPE(-150, 120); break;
    case ']': TYPE(-110, 120); break;
    case 'i': TYPE(-260, 120); break;
    case '0': TYPE(150, 0);  break;
    case '1': TYPE(120, 40); break;
    case '2': TYPE(160, 40); break;
    case '3': TYPE(200, 40); break;
    case '4': TYPE(110, 70); break;
    case '5': TYPE(150, 70); break;
    case '6': TYPE(190, 70); break;
    case '7': TYPE(110, 120); break;
    case '8': TYPE(150, 120); break;
    case '9': TYPE(190, 120); break;
    case '<'://,
    case ',': TYPE(-220, 40); break;
    default: throw new Error("Character : " + c + " is not supported!");
  }
  
  println("Typed the Character: " + c);
  return;
}

// Types the button at the given x and y coordinates.
void TYPE(int x, int y)
{
  // We first need to instruct the hand servo to go up to Z70.
  HEAD_UP();
  
  // We then use the GCode command for jogging the plotter to the given absolute coordiante values.
  output.println("G0 X" + x + " Y" + y);
  HEAD_DOWN();
}

void HEAD_UP()
{
  output.println("G1 Z70.0 F2500.0"); 
}

void HEAD_DOWN()
{
  output.println("G1 Z50.0 F2500.0");
}