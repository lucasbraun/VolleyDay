package volleyObjects;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;

import teamComparators.EqualGroupsPointsComparator;

public class Group implements Serializable {

   private static final long serialVersionUID = 1L;
   private String name;
   public List<Team> members;
   private List<Match> matches;
   private int status; // to which round does group belong to

   public Group(String name, int status) {
      this.name = name;
      members = new ArrayList<Team>();
      matches = new ArrayList<Match>();
      this.status = status;
   }

   public void setName(String name) {
      this.name = name;
   }

   public String getName() {
      return name;
   }

   public int getStatus() {
      return status;
   }

   public void addMember(Team team) {
      members.add(team);
   }

   public void addMembers(List<Team> teams) {
      Iterator<Team> it = teams.iterator();
      while (it.hasNext()) {
         members.add(it.next());
      }
   }

   public int getMemberCount() {
      return members.size();
   }

   public int getMatchCount() {
      return matches.size();
   }

   public List<Match> getMatches() {
      if (matches.size() > 0 && matches.get(0).getTime() != null) {
         // return new LinkedList<Match>(new TreeSet<Match>(matches));
         LinkedList<Match> result = new LinkedList<Match>(matches);
         Collections.sort(result);
         return result;
      } else {
         return matches;
      }
   }

   private void addMatch(Match match) {
      matches.add(match);
   }

   public void createMatches(int matchesPerTeam) {
      int gamesPerRound = (members.size() - 1) / 2; // for even number of teams the actual
                                                    // number of games per round will be 1
                                                    // bigger
      int modulus = 2 * gamesPerRound + 1;
      boolean even = (members.size() % 2 == 0);
      boolean flip;
      Match match;

      for (int pauseIndex = 0; pauseIndex < modulus; pauseIndex++) {
         flip = true;
         for (int i = 1; i <= gamesPerRound; i++) {
            if (flip) {
               match = new Match(members.get((pauseIndex + i) % modulus),
                     members.get((pauseIndex - i + modulus) % modulus), status);
            } else {
               match = new Match(members.get((pauseIndex - i + modulus) % modulus),
                     members.get((pauseIndex + i) % modulus), status);
            }
            addMatch(match);
            flip = !flip;
         }
         if (even) {
            if ((modulus - pauseIndex) % 2 == 0) {
               match = new Match(members.get(modulus), members.get(pauseIndex), status);
            } else {
               match = new Match(members.get(pauseIndex), members.get(modulus), status);
            }
            addMatch(match);
         }
      }

      // Special Case: if there are 3 teams in this group, but 4 in others
      if (members.size() == 3 && matchesPerTeam == 4) {
         for (int i = 0; i < 3; i++) {
            addMatch(new Match(matches.get(i).getTeam2(), matches.get(i).getTeam1(), status));
         }
      }
   }

   public void createFinalMatches() {
      Match match;
      if (members.size() == 2) {
         // Finals
         match = new Match(members.get(0), members.get(1), 4);
         addMatch(match);
      } else {
         // Semifinals
         match = new Match(members.get(0), members.get(3), 3);
         addMatch(match);
         match = new Match(members.get(1), members.get(2), 3);
         addMatch(match);
      }
   }

   public List<Team> getTable() {
      // bring all teams up to date
      for (Team team : members) {
         team.updateScore(status);
      }
      // sort them in descending order
      LinkedList<Team> result = new LinkedList<Team>(members);
      Collections.sort(result, new EqualGroupsPointsComparator());
      Collections.reverse(result);
      return result;
   }

   public static void main(String[] unused) {
      List<Team> teams = new ArrayList<Team>();
      teams.add(new Team("Team 1"));
      teams.add(new Team("Team 2"));
      Group g;
      for (int n = 3; n <= 10; n++) {
         teams.add(new Team("Team " + n));
         g = new Group("Test", 1);
         for (Team t : teams) {
            g.addMember(t);
         }
         try {
            g.createMatches(g.getMemberCount() - 1);
            System.out.println("For " + n + " teams:");
            for (Match m : g.getMatches()) {
               System.out.println(m.getTeam1().getName() + " : " + m.getTeam2().getName());
            }
            System.out.println("");
         } catch (Exception e) {
            e.printStackTrace();
         }
      }
   }
}
