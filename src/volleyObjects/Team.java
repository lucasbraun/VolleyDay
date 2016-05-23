package volleyObjects;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Iterator;
import java.util.List;

public class Team implements Serializable, Comparable<Team> {

   private static final long serialVersionUID = 1L;
   private String name;
   private double fixbetrag;
   private double varbetrag;
   private int punkte; // points in a special round
   private int tore; // goals in a special round
   private int kassierteTore; // goals received in a special round
   private int total_tore; // goals in all rounds
   private boolean total_toreUp2Date; // is counter for total_tore up-to-date?
   private List<Match> matches;

   public Team(String name) {
      this.name = name;
      punkte = 0;
      tore = 0;
      total_tore = 0;
      total_toreUp2Date = true;
      matches = new ArrayList<Match>();
   }

   public Team(String name, double fixbetrag, double varbetrag) {
      this.name = name;
      punkte = 0;
      tore = 0;
      total_tore = 0;
      total_toreUp2Date = true;
      matches = new ArrayList<Match>();
      this.fixbetrag = fixbetrag;
      this.varbetrag = varbetrag;
   }

   public String getName() {
      return name;
   }

   public double getFixbetrag() {
      return fixbetrag;
   }

   public double getVarbetrag() {
      return varbetrag;
   }

   public void setName(String name) {
      this.name = name;
   }

   public void setVarbetrag(double value) {
      varbetrag = value;
   }

   public void setFixbetrag(double value) {
      fixbetrag = value;
   }

   public void addMatch(Match match) {
      matches.add(match);
   }

   public int getNumberofActiveMatches(int status) {
      int result = 0;
      Iterator<Match> it = matches.iterator();
      while (it.hasNext()) {
         if (it.next().getStatus() == status) {
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
         if (temp != null && temp.getStatus() == status) {
            result.add(temp);
         }
      }
      // return new LinkedList<Match>(new TreeSet<Match>(result));
      Collections.sort(result);
      return result;
   }

   public int getPunkte() {
      // call updateScore first!!
      return punkte;
   }

   public int getTore() {
      // call updateScore first!!
      return tore;
   }

   public int getKassierteTore() {
      // call updateScore first!!
      return kassierteTore;
   }

   public int getTotalTore() {
      return total_tore;
   }

   public double getBetrag() {
      bringUp2Date();
      double result = fixbetrag + varbetrag * total_tore;
      result = ((double) Math.round(result * 100)) / 100;
      return result;
   }

   public void setHasChanged() {
      // set this flag if match results have changed!
      total_toreUp2Date = false;
   }

   public void updateScore(int status) {
      punkte = 0;
      tore = 0;
      total_tore = 0;
      kassierteTore = 0;
      for (Match match : matches) {
         if (match.getTeam1() == this) {
            total_tore = total_tore + match.getGoals1();
            if (match.getStatus() == status) {
               tore += match.getGoals1();
               kassierteTore += match.getGoals2();
               punkte += match.getPoints1();
            }
         } else {
            total_tore = total_tore + match.getGoals2();
            if (match.getStatus() == status) {
               tore += match.getGoals2();
               kassierteTore += match.getGoals1();
               punkte += match.getPoints2();
            }
         }
      }
      total_toreUp2Date = true;
   }

   public int compareUnequal(Team arg0, int status) {
      double fraction = (double) getActiveMatches(status).size()
            / arg0.getActiveMatches(status).size();
      if ((double) punkte == (double) arg0.punkte * fraction) {
         Double r1 = (double) (tore - kassierteTore);
         Double r2 = (arg0.tore - arg0.kassierteTore) * fraction;
         if (r1.equals(r2)) {
            if ((double) tore == arg0.tore * fraction) {
               return -1;
            } else {
               return new Double((double) tore).compareTo(new Double(arg0.tore * fraction));
            }
         } else {
            return r1.compareTo(r2);
         }
      } else {
         return new Double((double) punkte).compareTo(new Double(arg0.punkte * fraction));
      }
   }

   @Override
   public int compareTo(Team arg0) {
      // make sure, score is up to date!
      int status = matches.get(matches.size() - 1).getStatus();
      if (getActiveMatches(status).size() == arg0.getActiveMatches(status).size()) {
         if (punkte == arg0.punkte) {
            Integer r1 = tore - kassierteTore;
            Integer r2 = arg0.tore - arg0.kassierteTore;
            if (r1.equals(r2)) {
               if (tore == arg0.tore) {
                  return 0;
               } else {
                  return new Integer(tore).compareTo(new Integer(arg0.tore));
               }
            } else {
               return r1.compareTo(r2);
            }
         } else {
            return new Integer(punkte).compareTo(new Integer(arg0.punkte));
         }
      } else {
         return compareUnequal(arg0, status);
      }
   }

   private void bringUp2Date() {
      if (!(total_toreUp2Date)) {
         total_tore = 0;
         Iterator<Match> it = matches.iterator();
         Match match;
         while (it.hasNext()) {
            match = it.next();
            if (match.getTeam1() == this) {
               total_tore = total_tore + match.getGoals1();
            } else {
               total_tore = total_tore + match.getGoals2();
            }
         }
         total_toreUp2Date = true;
      }
   }
}
