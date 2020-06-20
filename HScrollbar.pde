class HScrollbar {
  int swidth, sheight;    // width and height of bar
  float xpos, ypos;       // x and y position of bar
  float spos, newspos;    // x position of slider
  float sposMin, sposMax; // max and min values of slider
  float normalPos;        // normalized position
  int loose;              // how loose/heavy
  boolean over;           // is the mouse over the slider?
  boolean locked;
  float ratio;
  boolean looping;
  boolean rollingUp = false;
  boolean rollingDown = false;
  float rollingSpeed = 0;

  HScrollbar (float xp, float yp, int sw, int sh, int l, boolean loop) {
    swidth = sw;
    sheight = sh;
    int widthtoheight = sw - sh;
    ratio = (float)sw / (float)widthtoheight;
    xpos = xp;
    ypos = yp-sheight/2;
    spos = xpos + swidth/2 - sheight/2;
    newspos = spos;
    sposMin = xpos;
    sposMax = xpos + swidth - sheight;
    loose = l;
    normalPos = (spos - sposMin) / (sposMax - sposMin);
    looping = loop;
  }

  void update() {
    if (overEvent()) {
      over = true;
    } else {
      over = false;
    }
    if (mousePressed && over) {
      locked = true;
    }
    if (!mousePressed) {
      locked = false;
    }
    if (locked) {
      newspos = constrain(mouseX-sheight/2, sposMin, sposMax);
      if (looping) {
        if (newspos > spos) {
          rollingUp = true;
          rollingDown = false;
          rollingSpeed = (newspos - spos)/5f;
        }
        else if (newspos < spos) {
          rollingDown = true;
          rollingUp = false;
          rollingSpeed = (spos - newspos)/5f;
        }
        if (rollingSpeed < 0.5) {
          rollingDown = false;
          rollingUp = false;
        }
      }
    }
    if (rollingUp) {
      newspos += rollingSpeed;
      if (newspos > sposMax) {
        spos = sposMin + (newspos % sposMax);
        newspos = spos + rollingSpeed;
      }
    }
    else if (rollingDown) {
      newspos -= rollingSpeed;
      if (newspos < sposMin) {
        spos = sposMax - (sposMin % newspos);
        newspos = spos - rollingSpeed;
      }
    }
    if (abs(newspos - spos) > 1) {
      spos = spos + (newspos-spos)/loose;
      normalPos = (spos - sposMin) / (sposMax - sposMin);
    }
  }

  float constrain(float val, float minv, float maxv) {
    return min(max(val, minv), maxv);
  }

  boolean overEvent() {
    if (mouseX > xpos && mouseX < xpos+swidth &&
       mouseY > ypos && mouseY < ypos+sheight) {
      return true;
    } else {
      return false;
    }
  }

  void display() {
    noStroke();
    fill(255);
    rect(xpos, ypos, swidth, sheight);
    if (over || locked) {
      fill(0, 0, 0);
    } else {
      fill(102, 102, 102);
    }
    rect(spos, ypos, sheight, sheight);
  }

  float getPos() {
    // Convert spos to be values between
    // 0 and the total width of the scrollbar
    return spos * ratio;
  }
  
  void setPos(float value) {
    spos = value;
    newspos = value;
    normalPos = (value - sposMin) / (sposMax - sposMin);
  }
  
  void setNormalPos(float value) {
    normalPos = value;
    spos = value * (sposMax - sposMin) + sposMin;
    newspos = spos;
  }
}
