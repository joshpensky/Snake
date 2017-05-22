/**
 * The main tab for the snake game.
 *
 * @author       Joshua Pensky
 * @title        Snake
 * @description  A game where users play as a snake, maneuvering around the map and themselves to get food and become larger.
 * @version      1.0.2
 */
 
public static final int BOARD = 50;
public int spaceSize;

public ArrayList<SnakeSpace> snake;
public FoodSpace food;
public ArrayList<TurnSpace> turns;

public boolean snakeAte;
public boolean gameOver;
public int highScore;
public int maxScore;
public int levelIncrease;

/**
 * Sets up the program.
 */
void setup() {
  size(1000, 1000);
  frameRate(15);
  spaceSize = width / BOARD;
  highScore = 0;
  levelIncrease = 10;
  maxScore = levelIncrease;
  init();
}

/**
 * Initializes/Resets the world back to its original state.
 */
void init() {
  snake = new ArrayList<SnakeSpace>();
  SnakeSpace head = new SnakeSpace(1, 1);
  head.setHead(true);
  snake.add(head);
  food = new FoodSpace(BOARD, BOARD);
  turns = new ArrayList<TurnSpace>();
  snakeAte = false;
  gameOver = false;
}

/**
 * Draws the current state of the game.
 */
void draw() {
  background(color(#2d0e05));
  gameOver = isGameOver();
  if (gameOver) {
    endScreen();
  } else {
    update();
  }
}

/**
 * Helper to the draw() function. Draws the end screen state.
 */
void endScreen() {
  fill(255);
  textAlign(CENTER);
  textSize(100);
  if (winCondition()) {
    text("you win!", width/2, height/2);
  } else {
    text("game over :(", width/2, height/2);
  }
  int padding = 0;
  fill(#5ddaff);
  textSize(20);
  padding = 40;
  if (snake.size() > highScore) {
    text("NEW HIGH SCORE: " + snake.size(), width/2, height/2 + padding);
  } else {
    text("HIGH SCORE: " + highScore, width/2, height/2 + padding);
  }
  fill(255);
  textSize(20);
  padding += 30;
  text("score: " + snake.size(), width/2, height/2 + padding);
  textSize(20);
  padding += 30;
  text("press R to restart", width/2, height/2 + padding);
}

/**
 * Helper to the draw() function. Updates and draws the current game state.
 */
void update() {
  fill(255);
  textAlign(CENTER);
  textSize(100);
  if (snake.get(0).direction == Direction.STILL) {
    text("LEVEL " + maxScore/levelIncrease, width/2, height/2);
  }
  ArrayList<TurnSpace> removeTurns = new ArrayList<TurnSpace>();
  food.drawSpace();
  for (SnakeSpace s : snake) {
    s.drawSpace();
    for (TurnSpace t : turns) {
      if (s.turn(t) && snake.indexOf(s) == snake.size() - 1) {
        removeTurns.add(t);
      }
    }
    if (s.samePosition(food)) {
      food = new FoodSpace(BOARD, BOARD);
      snakeAte = true;
    }
    if (!snakeAte) {
      s.move();
    }
  }
  for (TurnSpace t : removeTurns) {
    turns.remove(t);
  }
  if (snakeAte) {
    for (SnakeSpace s : snake) {
      s.setHead(false);
    }
    SnakeSpace head = new SnakeSpace(snake.get(0).x, snake.get(0).y, snake.get(0).direction);
    head.setHead(true);
    head.move();
    snake.add(0, head);
    snakeAte = false;
  }
  textAlign(RIGHT);
  fill(255);
  textSize(20);
  text("Length: " + snake.size(), width - 20, 40);
}

/**
 * Adds a new turning space if a directional key is pressed, or
 * resets the world if R is pressed and game is over.
 */
void keyPressed() {
  SnakeSpace head = snake.get(0);
  if (key == CODED) {
    switch (keyCode) {
      case UP:
        addNewTurn(new TurnSpace(head.x, head.y, Direction.DIR_UP));
        break;
      case DOWN:
        addNewTurn(new TurnSpace(head.x, head.y, Direction.DIR_DOWN));
        break;
      case LEFT:
        addNewTurn(new TurnSpace(head.x, head.y, Direction.DIR_LEFT));
        break;
      case RIGHT:
        addNewTurn(new TurnSpace(head.x, head.y, Direction.DIR_RIGHT));
        break;
      default:
        break;
    }
  } else if (gameOver && (key == 'r' || key == 'R')) {
    if (snake.size() > highScore) {
      highScore = snake.size();
    }
    if (winCondition()) {
      maxScore += levelIncrease;
    }
    init();
  }
}

/**
 * Adds a new turn to the turns list, if not the same direction of the snake head
 * or position of the last turn.
 *
 * @throws IllegalArgumentException if the given {@code TurnSpace} is null
 */
void addNewTurn(TurnSpace t) {
  if (t == null) {
    throw new IllegalArgumentException("Can't add null.");
  }
  if (!t.direction.equals(snake.get(0).direction)) {
    if (turns.size() == 0) {
      turns.add(t);
    } else {
      if (!turns.get(turns.size() - 1).samePosition(t)) {
        turns.add(t);
      }
    }
  }
}

/**
 * Decides whether the game is over or not.
 *
 * @return true if the game is over, false otherwise
 */
boolean isGameOver() {
  for (int i = 1; i < snake.size(); i++) {
    if (snake.get(i).equals(snake.get(0))) {
      return true;
    }
  }
  return snake.get(0).outOfBounds(BOARD - 1, BOARD - 1) || winCondition();
}

/**
 * Decides whether the player has beat the level.
 *
 * @return true if the player won, false otherwise
 */
boolean winCondition() {
  return snake.size() == maxScore;
}