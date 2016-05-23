package teamComparators;

import java.util.Comparator;

import volleyObjects.Team;

/**
 * This Comparator compares two teams of equal group size (which implies same number of
 * matches). The priority is points -> goal-difference -> number of goals scored Carefull!!
 * The caller of the comparator must make sure that the points are up2date!
 * 
 * @author Lucas
 * @version 1.0
 */
public class EqualGroupsPointsComparator implements Comparator<Team> {

   @Override
   public int compare(Team arg0, Team arg1) {
      int differenz0, differenz1;
      if (arg0.getPunkte() == arg1.getPunkte()) {
         differenz0 = arg0.getTore() - arg0.getKassierteTore();
         differenz1 = arg1.getTore() - arg1.getKassierteTore();
         if (differenz0 == differenz1) {
            return Integer.valueOf(arg0.getTore()).compareTo(arg1.getTore());
         } else {
            return Integer.valueOf(differenz0).compareTo(differenz1);
         }
      } else {
         return Integer.valueOf(arg0.getPunkte()).compareTo(arg1.getPunkte());
      }
   }

}
