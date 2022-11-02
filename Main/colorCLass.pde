public class myColor {
  //RED (168, 50, 50),
  //GREEN (16, 156, 20),
  //BLUE (16, 18, 156),
  //BLACK (0, 0, 0),
  //WHITE (255, 255, 255),
  //PURPLE (122, 15, 184),
  //GRAY(149, 146, 150),
  //YELLOW (230, 226, 23),
  //ORANGE (252, 173, 25), 
  //BROWN (130, 86, 4);
    
  public myColor() {}
  
  public color RED() {
      return color(168, 50, 50);
  }
  
  public color GREEN() {
      return color(16, 156, 20);
  }
  
  public color BLUE() {
      return color(16, 18, 156);
  }
  
  public color BLACK() {
      return color(0, 0, 0);
  }
  
  public color WHITE() {
      return color(255, 255, 255);
  }
  
  public color PURPLE() {
      return color(122, 15, 184);
  }
  
  public color GRAY() {
      return color(149, 146, 150);
  }
  
  public color YELLOW() {
      return color(230, 226, 23);
  }
  
  public color ORANGE() {
      return color(252, 173, 25);
  }
  
  public color BROWN() {
      return color(130, 86, 4);
  }
  
  public color complementaryColor(color givenColor) {
      return color(255 - red(givenColor), 255 - green(givenColor), 255 - blue(givenColor));
  }
}
