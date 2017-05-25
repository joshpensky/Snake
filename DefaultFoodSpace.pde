/**
 * Represents the default food on the grid, with the basic add effect.
 */
public class DefaultFoodSpace extends AFoodSpace {
  /**
   * Constructs a {@code DefaultFoodSpace}.
   *
   * @param hiX   the upper-bound of the x-position
   * @param hiY   the upper-bound of the y-position
   */
  public DefaultFoodSpace(int hiX, int hiY) {
    super(hiX, hiY);
  }
  
  /**
   * Mutates the list based on the effect of this {@code DefaultFoodSpace}.
   *
   * @param snake       a list of {@code SnakeSpace}s representing a snake
   * @throws IllegalArgumentException if given snake-list is null or size 0
   */
  public FoodType eatEffect(ArrayList<SnakeSpace> snake, ArrayList<AFoodSpace> foods, FoodType ate,
                        int hiX, int hiY) throws IllegalArgumentException {
    if (snake == null || snake.size() == 0) {
      throw new IllegalArgumentException("Invalid snake passed.");
    }
    for (SnakeSpace s : snake) {
      s.setHead(false);
    }
    SnakeSpace newHead = new SnakeSpace(snake.get(0).x, snake.get(0).y, snake.get(0).direction);
    newHead.setHead(true);
    newHead.move(ate, hiX, hiY);
    snake.add(0, newHead);
    if (!ate.equals(FoodType.EXPLODER)) {
      foods.add(0, new DefaultFoodSpace(hiX, hiY));
    }
    return FoodType.DEFAULT;
  }
}