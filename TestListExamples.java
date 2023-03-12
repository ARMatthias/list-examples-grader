import static org.junit.Assert.*;
import org.junit.*;
import java.util.Arrays;
import java.util.List;

class IsMoon implements StringChecker {
  public boolean checkString(String s) {
    return s.equalsIgnoreCase("moon");
  }
}

class IsA implements StringChecker {
  public boolean checkString(String s) {
    return s.equalsIgnoreCase("a");
  }
}

public class TestListExamples {

  List<String> threeStrF = Arrays.asList("a", "b", "c");
  List<String> fiveStr = Arrays.asList("b", "c", "d", "e", "f");
  List<String> threeStrB = Arrays.asList("e", "f", "g");
  List<String> partial = Arrays.asList("a","moon","b","a","moon","moon");
  List<String> empty = Arrays.asList();

  StringChecker moon = new IsMoon();
  StringChecker isA = new IsA();

  List<String> test;
  List<String> expected;

  @Before
  public void setUp() {

  }

  @Test(timeout = 500)
  public void testMergeFront() {
    test = ListExamples.merge(threeStrF, fiveStr);
    expected = Arrays.asList("a", "b", "b", "c", "c", "d", "e", "f");
    assertEquals(test, expected);
  }

  @Test(timeout = 500) 
  public void testMergeBack() {
    test = ListExamples.merge(threeStrB, fiveStr);
    expected = Arrays.asList("b","c","d","e","e","f","f","g");
    assertEquals(test, expected);
  }

  @Test(timeout = 500)
  public void testMergeEmpty() {
    test = ListExamples.merge(threeStrF, empty);
    assertEquals(test,threeStrF);
  }

  @Test(timeout = 500)
  public void testFilterNotMoon() {

    test = ListExamples.filter(threeStrF, moon);

    assertEquals(Arrays.asList(), test);
  }

  @Test(timeout = 500)
  public void testFilterPartialMoon() {

    test = ListExamples.filter(partial,moon);

    assertEquals(test, Arrays.asList("moon","moon","moon"));
  }

  @Test(timeout = 500)
  public void testFilterFullMoon() {

    test = ListExamples.filter(Arrays.asList("moon","moon"),moon);

    assertEquals(test, Arrays.asList("moon","moon"));
  }

  @Test(timeout = 500)
  public void testFilterNotA() {
    
    test = ListExamples.filter(threeStrB, isA);

    assertEquals(test, Arrays.asList());
  }

  @Test(timeout = 500)
  public void testFilterPartialA() {

    test = ListExamples.filter(partial, isA);

    assertEquals(test, Arrays.asList("a", "a"));
  }

  @Test(timeout = 500)
  public void testFilterFullA() {

    test = ListExamples.filter(Arrays.asList("a","a","a"), isA);

    assertEquals(test, Arrays.asList("a","a","a"));
  }

}
