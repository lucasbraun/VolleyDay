package testers;

import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;
import java.util.TreeSet;

import volleyObjects.Field;
import volleyObjects.Group;
import volleyObjects.Match;
import volleyObjects.Team;
import volleyObjects.Time;
import volleyObjects.Tournament;
import volleyObjects.TournamentLoader;

public class VolleyTester {

   private static void printOverview(Tournament t, int status) {
      List<List<Match>> table = t.getOverviewTable(status);
      Iterator<List<Match>> rowIterator = table.iterator();
      Iterator<Match> columnIterator;
      Match tempMatch;
      while (rowIterator.hasNext()) {
         columnIterator = rowIterator.next().iterator();
         while (columnIterator.hasNext()) {
            tempMatch = columnIterator.next();
            if (tempMatch != null) {
               System.out.print(tempMatch.getTeam1().getName() + " " + tempMatch.getGoals1()
                     + ":" + tempMatch.getGoals2() + " " + tempMatch.getTeam2().getName()
                     + ", " + tempMatch.getTime().out() + " // ");
            } else {
               System.out.print("__ // ");
            }
         }
         System.out.println("");
      }
   }

   private static void printGroups(Tournament t, int status) {
      Iterator<Team> it;
      Group tempGroup;
      Iterator<Group> git = t.getActiveGroups(status).iterator();
      while (git.hasNext()) {
         tempGroup = git.next();
         System.out.println(tempGroup.getName() + "\n---------");
         it = tempGroup.members.iterator();
         while (it.hasNext()) {
            System.out.println(it.next().getName());
         }
      }
   }

   @SuppressWarnings("unused")
   private static void printGroupsWithMatches(Tournament t) {
      Iterator<Group> groupIterator = t.getGroups().iterator();
      Iterator<Match> matchIterator;
      Group tempGroup;
      Match tempMatch;
      while (groupIterator.hasNext()) {
         tempGroup = groupIterator.next();
         System.out.println(tempGroup.getName());
         System.out.println("===========");
         matchIterator = tempGroup.getMatches().iterator();
         while (matchIterator.hasNext()) {
            tempMatch = matchIterator.next();
            System.out.println(tempMatch.getTeam1().getName() + " : "
                  + tempMatch.getTeam2().getName() + ", " + tempMatch.getTime().out());
         }
         System.out.println("");
      }
   }

   @SuppressWarnings("unused")
   private static void printFieldsWithMatches(Tournament t) {
      Iterator<Field> fieldIterator = t.getFields().iterator();
      Iterator<Match> matchIterator;
      Field tempField;
      Match tempMatch;
      while (fieldIterator.hasNext()) {
         tempField = fieldIterator.next();
         System.out.println(tempField.getName());
         System.out.println("===========");
         matchIterator = tempField.getMatches().iterator();
         while (matchIterator.hasNext()) {
            tempMatch = matchIterator.next();
            System.out.println(tempMatch.getTeam1().getName() + " : "
                  + tempMatch.getTeam2().getName() + ", " + tempMatch.getTime().out());
         }
         System.out.println("");
      }
   }

   private static Tournament getDefaultTournament() {
      Tournament result = new Tournament();
      result.setFieldCount(6);
      result.setTeamCount(24);
      result.setNextStartTime("9:00");
      return result;
   }

   private static void RandomizeMatches(Tournament t, int status) {
      Iterator<Group> it = t.getActiveGroups(status).iterator();
      Iterator<Match> mit;
      Match temp;
      while (it.hasNext()) {
         mit = it.next().getMatches().iterator();
         while (mit.hasNext()) {
            temp = mit.next();
            Double d1 = 20 * Math.random();
            Double d2 = 20 * Math.random();
            temp.setResult(d1.intValue(), d2.intValue());
         }
      }
   }

   private static void test1() {
      Tournament tournament1 = getDefaultTournament();
      tournament1.setTeamCount(12);
      tournament1.setFieldCount(4);
      tournament1.setBreakTime(2);
      tournament1.setMinTime(7);
      tournament1.setMaxTime(25);

      for (int i = 1; i <= 4; i++) {
         switch (i) {
            case 1:
               tournament1.setNextStartTime("11:00");
               tournament1.setTotalTime(120);
               tournament1.setGamesPerTeam(3);
               break;
            case 2:
               tournament1.setNextStartTime("14:00");
               tournament1.setTotalTime(150);
               tournament1.setGamesPerTeam(5);
               break;
            case 3:
               tournament1.setNextStartTime("17:00");
               tournament1.setTotalTime(20);
               break;
         }
         tournament1.calculateNext();
         RandomizeMatches(tournament1, i);
         System.out.println("==========\nRound" + i + "\n==========");
         System.out.println("Spielzeit: " + tournament1.getGameTime() + "\n");
         printGroups(tournament1, i);
         System.out.println("");
         printOverview(tournament1, i);
         System.out.println("");
      }
   }

   @SuppressWarnings("unused")
   private static void test2() {

      // initialize teams
      List<Team> teams = new LinkedList<Team>();
      for (int i = 0; i < 7; i++) {
         teams.add(new Team("Team_" + i));
      }

      // initialize groups
      Group group1 = new Group("Gruppe 1", 1);
      Group group2 = new Group("Gruppe 2", 1);
      for (int i = 0; i < 3; i++) {
         group1.addMember(teams.get(i));
         group2.addMember(teams.get(4 + i));
      }
      group1.addMember(teams.get(3));

      // create matches
      group1.createMatches(4);
      group2.createMatches(4);

      // play matches
      Double d1;
      Double d2;
      Match tempMatch;
      for (int i = 0; i < 6; i++) {
         d1 = 20 * Math.random();
         d2 = 20 * Math.random();
         tempMatch = group1.getMatches().get(i);
         tempMatch.setResult(d1.intValue(), d2.intValue());

         d1 = 20 * Math.random();
         d2 = 20 * Math.random();
         tempMatch = group2.getMatches().get(i);
         tempMatch.setResult(d1.intValue(), d2.intValue());
      }

      // set timings
      for (Match tempi : group1.getMatches()) {
         tempi.setTime(new Time(12, 0));
      }
      for (Match tempi : group2.getMatches()) {
         tempi.setTime(new Time(12, 0));
      }

      // output
      System.out.println("Tabelle Gruppe 1\n================");
      for (Team temp : group1.getTable()) {
         System.out.println(temp.getName() + ": " + temp.getPunkte() + ", " + temp.getTore()
               + " : " + temp.getKassierteTore());
      }
      System.out.println("\nTabelle Gruppe 2\n================");
      for (Team temp : group2.getTable()) {
         System.out.println(temp.getName() + ": " + temp.getPunkte() + ", " + temp.getTore()
               + " : " + temp.getKassierteTore());
      }
      List<Team> tempList = new LinkedList<Team>((new TreeSet<Team>(teams)).descendingSet());
      System.out.println("\nGesamt-Tabelle\n===============");
      for (Team temp : tempList) {
         System.out.println(temp.getName() + ": " + temp.getPunkte() + ", " + temp.getTore()
               + " : " + temp.getKassierteTore());
      }
   }

   @SuppressWarnings("unused")
   private static void randomTournament(String tname) {
      Tournament t = TournamentLoader.loadTournament(tname);
      RandomizeMatches(t, t.getStatus());
      TournamentLoader.saveTournament(t, tname);
   }

   public static void main(String[] args) {
      test1();
   }
}
