String keyAnalyzer(char c)
{
  if (c >= '0' && c <= '9') 
  {
    return "NUMBER";
  }
  else if (c >= 'a' && c <= 'z' || c >= 'A' && c <= 'Z') 
  {
    return "LETTER";
  }
  else
  {
    return "OTHER";
  }
}

class Console
{
  float x;
  float y;
  String chars;
  int numChars;
  boolean active;
  int font;
  
  Console(float x, float y, int font)
  {
    this.x = x;
    this.y = y;
    active = false;
    this.font = font;
    chars = "";
    numChars = 0;
  }
  
  void display()
  {
    line(x - 5, y - font/1.3, x - 5, y + font/2.5);
    textSize(font);
    text(chars, x, y);
  }
  
  void addChar(char c)
  {
    chars += c;
    numChars++;
    changedText = true;
  }
  
  boolean isActive()
  {
    return active;
  }
  
  void activate()
  {
    active = true;
  }
  
  void deactivate()
  {
    active = false;
  }
  
  void reset()
  {
    chars = "";
  }
  
  void deleteChar()
  {
    if (numChars > 0)
    {        
      chars = chars.substring(0,chars.length()-1);
      numChars -= 1;
    }
    changedText = true;
  }
}
