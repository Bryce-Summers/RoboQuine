// My program will use monospaced fonts, as in most programming text editors.

// These programming lines will encapsulate visual information about my plotter's progress typing the Quine.
class Program_Line
{
  char[] text;
  boolean code;// (true, false) --> (Bryce Plotter Language Intructions, Comments).
  int offset; // The number of monospaced offset units.
  int typed;
  int length;
  Program_Line next = null;

  // These animations will be used to display where the latest typing has occured.
  int[] animations;
  
  public Program_Line(String text, int offset, boolean code)
  {
    this.text = text.toCharArray();
    this.length = text.length();
    animations = new int[this.length];
    for(int i = 0; i < length; i++)
    {
      animations[i] = 0;
    }
    
    this.offset = offset + 1;// The +1 is for the line number.
    this.code = code;
        
    // All lines start out with 0 characters typed.
    // Program lines will be typed gradually over time.
    // Comment lines will ignore this and draw themselves in a gray manner.
    typed = 0;
  }
  
  // Draws this program line and following lines at the given x, y location.
  // The even value specifies whether we are drawing an even line or an odd line. 
  public void draw(int x, int y, boolean even, int line_number)
  {
    fill(even ? 255 : 220);

    
    rect(x + 32, y - 32, width/2 - 64, 64);
        
    int x0 = x;

    // Draw the important line number references for the P: function.
    if(code)
    {
   
      fill(255);
      text(line_number +".", x, y);
      
      line_number++;
    }
    
    x += 64*offset;

    for(int i = 0; i < text.length; i++) //<>//
    {
      if(!code)
      {
         fill(105, 188, 105);
      }
      else if(typed > i)
      {
        fill(0); //<>//
      } //<>//
      else
      {
        fill(150); //<>//
      }
      
      text("" + text[i], x, y);
      
      x += code ? 64 : 32;
    }
   
    // Draw the animations.
    for(int i = 0; i < length; i++)
    {
      float size = 20 + 32*sin(radians(animations[i]));
      animations[i] = max(0, animations[i] - 10);
      if(animations[i] > 0)
      {
        stroke(0, 0, 0);
        fill(0, 0, 0, 0);
        rect(x0 + (offset + i)*64 - size, y - size, size*2, size*2);
      }
    }
    
    y += 64;
      
    if(y > height - 64*2)
    {
       y = 32*3;
       x0 = width/2 + 32;
       even = !even;
    }
    
    if(I_AM_NOT_THE_END())
    {
       next.draw(x0, y, !even, line_number);
    }

  }
  
  // A key has been typed.
  // Returns the active line after this operation has completed.
  // If the user has typed this entire line, then the next line becomes active.
  Program_Line type()
  {
   
    int length = text.length;
    
    // Skip over comment lines.
    if(!code)
    {
      typed = length;
      return next == null ? null : next.type();
    }

    if(typed < length)
    {
      animations[typed] = 180;
    }
    
    typed++;
    
    if(typed >= length)
    {
      return next;
    }
    
    return this;
  }
  
  boolean I_AM_NOT_THE_END()
  {
   return next != null; 
  }
}