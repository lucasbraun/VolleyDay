package volleyObjects;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

public class Field implements Serializable {

   private static final long serialVersionUID = 1L;
   private String name;
   private List<Match> matches;

   private int regionIndex = 0;

   public Field(String name) {
      this.name = name;
      matches = new ArrayList<Match>();
   }

   public void setName(String name) {
      this.name = name;
   }

   public void setRegionIndex(int regionIndex) {
      this.regionIndex = regionIndex;
   }

   public String getName() {
      return name;
   }

   public int getRegionIndex() {
      return regionIndex;
   }

   public void addMatch(Match match) {
      matches.add(match);
   }

   public int getNumberOfActiveMatches(int status) {
      int result = 0;
      Iterator<Match> it = matches.iterator();
      Match temp;
      while (it.hasNext()) {
         temp = it.next();
         if (temp != null && temp.getStatus() == status) {
            result++;
         }
      }
      return result;
   }

   public List<Match> getActiveMatches(int status) {
      List<Match> result = new ArrayList<Match>();
      Iterator<Match> it = matches.iterator();
      Match temp;
      while (it.hasNext()) {
         temp = it.next();
         // null matches are possible in actual round...
         if (temp == null || temp.getStatus() == status) {
            result.add(temp);
         }
      }
      return result;
   }

   public List<Match> getMatches() {
      return matches;
   }
}
