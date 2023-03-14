/*
 * Name: Rae Matthias
 * Email: amatthias@ucsd.edu
 * PID: A17495586
 * 
 * This file tests ListExamples.java for correctness
 */

import static org.junit.Assert.*;
import org.junit.*;
import java.util.Arrays;
import java.util.List;

/*
 * This class creates a custom StringChecker that checks if a string is "moon"
 */
class IsMoon implements StringChecker {
  public boolean checkString(String s) {
    return s.equalsIgnoreCase("moon");
  }
}

/*
 * This class creates a custom StringChecker that checks if a string is "a"
 */
class IsA implements StringChecker {
  public boolean checkString(String s) {
    return s.equalsIgnoreCase("a");
  }
}

/*
 * This class aims to test ListExamples using test data
 */
public class TestListExamples {

  // test data initialization
  List<String> threeStrF = Arrays.asList("a", "b", "c");
  List<String> fiveStr = Arrays.asList("b", "c", "d", "e", "f");
  List<String> threeStrB = Arrays.asList("e", "f", "g");
  List<String> partial = Arrays.asList("a","moon","b","a","moon","moon");
  List<String> empty = Arrays.asList();

  StringChecker moon = new IsMoon();
  StringChecker isA = new IsA();

  List<String> test;
  List<String> expected;

  // ==== Test ListExamples.merge(List<String> list1, List<String> list2) ====

  /**
   * Tests merge() effecting the first half of the greater list
   */
  @Test(timeout = 500)
  public void testMergeFront() {

    test = ListExamples.merge(threeStrF, fiveStr);
    expected = Arrays.asList("a", "b", "b", "c", "c", "d", "e", "f");

    assertEquals(expected, test);
  }

  /**
   * Tests merge() effecting the latter half of the greater list
   */
  @Test(timeout = 500) 
  public void testMergeBack() {

    test = ListExamples.merge(threeStrB, fiveStr);
    expected = Arrays.asList("b","c","d","e","e","f","f","g");

    assertEquals(expected, test);
  }

  /**
   * Tests merge() of a populated string and an empty string
   */
  @Test(timeout = 500)
  public void testMergeEmpty() {

    test = ListExamples.merge(threeStrF, empty);

    assertEquals(threeStrF,test);
  }

  // ===== Test ListExamples.filter(List<String> list, StringChecker sc) =====

  /**
   * Tests filter() with StringChecker moon if none of the 
   * list elements are moon
   */
  @Test(timeout = 500)
  public void testFilterNotMoon() {

    test = ListExamples.filter(threeStrF, moon);

    assertEquals(Arrays.asList(), test);
  }

  /**
   * Tests filter() with StringChecker moon if some of the 
   * list elements are moon
   */
  @Test(timeout = 500)
  public void testFilterPartialMoon() {

    test = ListExamples.filter(partial,moon);

    assertEquals(Arrays.asList("moon","moon","moon"), test);
  }

  /**
   * Tests filter() with StringChecker moon if all of the 
   * list elements are moon
   */
  @Test(timeout = 500)
  public void testFilterFullMoon() {

    test = ListExamples.filter(Arrays.asList("moon","moon"),moon);

    assertEquals(Arrays.asList("moon","moon"), test);
  }

  /**
   * Tests filter() with StringChecker a if none of the
   * list elements are a
   */
  @Test(timeout = 500)
  public void testFilterNotA() {
    
    test = ListExamples.filter(threeStrB, isA);

    assertEquals(Arrays.asList(), test);
  }

  /**
   * Tests filter() with StringChecker a if some of the
   * list elements are a
   */
  @Test(timeout = 500)
  public void testFilterPartialA() {

    test = ListExamples.filter(partial, isA);

    assertEquals(Arrays.asList("a", "a"), test);
  }

  /**
   * Tests filter() with StringChecker a if all of the
   * list elements are a
   */
  @Test(timeout = 500)
  public void testFilterFullA() {

    test = ListExamples.filter(Arrays.asList("a","a","a"), isA);

    assertEquals(Arrays.asList("a","a","a"), test);
  }

}
