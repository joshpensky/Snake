/**
 * Represents a screen in the program.
 */
public class Screen {
  private ScreenText header;
  private ArrayList<ScreenText> body;
  private ArrayList<ScreenButton> buttons;
  private static final int SECTION_PADDING = ScreenText.PADDING * 2;
  
  private final color white = color(255);
  private final color ground = color(#2d0e05);
  private final color blue = color(#3a7cef);
  private final color red = color(#ff3b4a);
  private final color green = color(#0edd48);
  private final color gray = color(#afafaf);
  private PShape cursor;
  
  /**
   * Constructs a {@code Screen} object.
   *
   * @param hText       the text for the header
   * @param bText       the text for each of the body texts
   * @param btns        the text for each of the buttons
   * @param actions     the {@code GameState}s that the buttons return when clicked,
   *                    must be same size list as btns
   * @throws IllegalArgumentException if any of the parameters are null, contain null, or
   *                                  if the actions and btns lists are not the same size
   */
  public Screen(String hText, ArrayList<String> bText, ArrayList<String> btns,
                ArrayList<GameState> actions) throws IllegalArgumentException {
    if (hText == null
        || bText == null || bText.contains(null)
        || btns == null || btns.contains(null)
        || actions == null || actions.contains(null) || actions.size() != btns.size()) {
      throw new IllegalArgumentException("Invalid list.");
    }
    initHeader(hText);
    initBody(bText);
    initButtons(btns, actions);
    cursor = loadShape("snake.svg");
  }
  
  /**
   * Helper to the constructor. Initializes the header with the given header text.
   *
   * @param hText       the text for the header
   */
  private void initHeader(String hText) {
    this.header = new ScreenText(width/2, height/2, hText, white, 80);
  }
  
  /**
   * Helper to the constructor. Initializes the body texts with the given list of body text.
   *
   * @param bText       the text for each of the body texts
   */
  private void initBody(ArrayList<String> bText) {
    this.body = new ArrayList<ScreenText>();
    int top = int(height/2) + int(this.header.getHeight()/2) + SECTION_PADDING;
    int x = width/2;
    for (String t : bText) {
      ScreenText next = new ScreenText(0, 0, t, blue, 30);
      next = new ScreenText(x, top + (next.getHeight() / 2) + ScreenText.PADDING, t, blue, 30);
      top += next.getHeight();
      this.body.add(next);
    }
  }
  
  /**
   * Helper to the constructor. Initializes the buttons texts with the given
   * list of button text and actions.
   *
   * @param btns        the text for each of the buttons
   * @param actions     the {@code GameState}s that the buttons return when clicked
   */
  private void initButtons(ArrayList<String> btns, ArrayList<GameState> actions) {
    this.buttons = new ArrayList<ScreenButton>();
    int x = width/2;
    int top = int(height/2) + int(this.header.getHeight()/2) + SECTION_PADDING;
    for (ScreenText t : this.body) {
      top += t.getHeight();
    }
    top += SECTION_PADDING;
    for (String s : btns) {
      boolean inFocus = (btns.indexOf(s) == 0);
      ScreenButton next = new ScreenButton(x, top + ScreenText.PADDING, s, gray, 30,
          inFocus, green, actions.get(btns.indexOf(s)));
      top += next.getHeight();
      this.buttons.add(next);
    }
  }
  
  /**
   * Draws all elements on this screen.
   */
  public void display() {
    header.display();
    for (ScreenText t : this.body) {
      t.display();
    }
    for (ScreenButton b : this.buttons) {
      b.display();
    }
    shape(cursor, mouseX, mouseY);
  }
  
  /**
   * Updates focus of the buttons on this screen, based on keyboard input.
   *
   * @param up      true if the up arrow was pressed, false if down
   */
  public void update(boolean up) {
    int which = -1;
    for (int i = 0; i < buttons.size(); i++) {
      if (buttons.get(i).getFocus()) {
        which = i;
      }
      buttons.get(i).setFocus(false);
    }
    if (which >= 0) {
      which += ((up) ? -1 : 1);
      if (which > buttons.size() - 1) {
        buttons.get(0).setFocus(true);
      } else if (which < 0) {
        buttons.get(buttons.size() - 1).setFocus(true);
      } else {
        buttons.get(which).setFocus(true);
      }
    } else {
      buttons.get(0).setFocus(true);
    }
  }
  
  /**
   * Updates focus of the buttons on this screen, based on mouse position.
   *
   * @param mX      the current x-position of the mouse
   * @param mY      the current y-position of the mouse
   */
  public void update(int mX, int mY) {
    int newFocus = -1;
    int oldFocus = -1;
    for (int i = 0; i < buttons.size(); i++) {
      if (buttons.get(i).getFocus()) {
        oldFocus = i;
      }
      buttons.get(i).setFocus(false);
      if (buttons.get(i).hover(mX, mY)) {
        newFocus = i;
      }
    }
    if (newFocus >= 0) {
      buttons.get(newFocus).setFocus(true);
    } else {
      buttons.get(oldFocus).setFocus(true);
    }
  }
  
  /**
   * Returns the action of the focused button (or pressed button, if using mouse).
   *
   * @return which GameState the button takes the user to
   */
  public GameState useButton() {
    for (ScreenButton b : this.buttons) {
      if (b.getFocus() && (!mousePressed || (mousePressed && b.hover(mouseX, mouseY)))) {
        resetFocus();
        return b.getAction();
      }
    }
    return null;
  }
  
  /**
   * Resets the focus of all buttons on the screen, so only the first is focused.
   */
  private void resetFocus() {
    for (ScreenButton b : buttons) {
      boolean inFocus = (buttons.indexOf(b) == 0);
      b.setFocus(inFocus);
    }
  }
  
  /**
   * Resets the body texts with the new given list of body text.
   *
   * @param bText       the text for each of the body texts
   * @throws IllegalArgumentException if the given list is or contains null
   */
  public void setBody(ArrayList<String> bText) {
    if (bText == null || bText.contains(null)) {
      throw new IllegalArgumentException("Invalid list.");
    }
    this.initBody(bText);
  }
}