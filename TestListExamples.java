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
  List<String> empty = Arrays.asList();

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

  public void testFilter() {

  }



}
