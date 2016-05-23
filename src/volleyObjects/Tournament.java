package volleyObjects;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;

public class Tournament implements Serializable {

   // This class implements a tournament.
   // To create it use the Constructor method and after that call
   // the setGamesPerTeam function until the value corresponds to
   // the parameters given

   private static final long serialVersionUID = 1L;
   // attributes with default values
   private int totalTime = 120;
   private int minTime = 10;
   private int maxTime = 20;
   private int breakTime = 2;
   private int status = 0;
   private int gamesPerTeam;
   private int gameTime;
   private Time nextStartTime = Time.parseTime("9:00");

   private List<Team> teams;
   private List<Field> fields;
   private List<Group> groups = new ArrayList<Group>();

   public void setTotalTime(int totalTime) {
      this.totalTime = totalTime;
   }

   public void setMinTime(int minTime) {
      this.minTime = minTime;
   }

   public void setMaxTime(int maxTime) {
      this.maxTime = maxTime;
   }

   public void setBreakTime(int breakTime) {
      this.breakTime = breakTime;
   }

   public void setTeamCount(int teamCount) {
      // this method should normally be called just once!
      teams = new ArrayList<Team>();
      for (int i = 0; i < teamCount; i++) {
         teams.add(new Team("Team" + i));
      }
   }

   public void setFieldCount(int fieldCount) {
      // this method should normally be called just once!
      fields = new ArrayList<Field>();
      for (int i = 0; i < fieldCount; i++) {
         fields.add(new Field("Field" + i));
      }
   }

   public Time getNextStartTime() {
      return nextStartTime;
   }

   public void setNextStartTime(String nextStartTime) {
      this.nextStartTime = Time.parseTime(nextStartTime);
   }

   public int[] setGamesPerTeam(int gpt) {
      // returns the bounds if gamesPerTeam not OK and an empty array if OK
      int[] bounds = VolleyMode.checkParamters(gpt, totalTime, minTime, maxTime, breakTime,
            fields.size(), teams.size());
      if (bounds.length == 0) {
         gamesPerTeam = gpt;
      }
      return bounds;
   }

   public int getTotalTime() {
      return totalTime;
   }

   public int getMinTime() {
      return minTime;
   }

   public int getMaxTime() {
      return maxTime;
   }

   public int getBreakTime() {
      return breakTime;
   }

   public int getStatus() {
      return status;
   }

   public int getGameTime() {
      return gameTime;
   }

   public List<Team> getTeams() {
      return teams;
   }

   public List<Field> getFields() {
      return fields;
   }

   public List<Group> getGroups() {
      return groups;
   }

   public void addTeam(String teamname) throws Exception {
      if (status < 1) {
         teams.add(new Team(teamname));
      } else {
         throw new Exception("Es können keine Teams mehr hinzugefügt werden!");
      }
   }

   public void updateTeam(int id, String name, double fixbetrag, double varbetrag) {
      Team team = teams.get(id);
      team.setName(name);
      team.setFixbetrag(fixbetrag);
      team.setVarbetrag(varbetrag);
   }

   public void removeTeam(int id) throws Exception {
      if (status < 1) {
         teams.remove(id);
      } else {
         throw new Exception("Es können keine Teams mehr gelöscht werden!");
      }
   }

   public void addField(String fieldname) throws Exception {
      if (status < 1) {
         fields.add(new Field(fieldname));
      } else {
         throw new Exception("Es können keine Spielfelder mehr hinzufgefügt werden.");
      }
   }

   public void updateField(int id, String name) {
      fields.get(id).setName(name);
   }

   public void removeField(int id) throws Exception {
      if (status < 1) {
         fields.remove(id);
      } else {
         throw new Exception("Es können keine Spielfelder mehr gelöscht werden.");
      }
   }

   public void calculateNext() {
      Pair<Integer, Time> result;
      // user interface must make sure gpt, nextStarttime and total time is set correctly
      try {
         switch (status) {
            case 0:
               result = VolleyMode.round1(gamesPerTeam, totalTime, nextStartTime, breakTime,
                     teams, groups, fields);
               gameTime = result.getFirst();
               nextStartTime = result.getSecond();
               status = 1;
               break;
            case 1:
               result = VolleyMode.round2(gamesPerTeam, totalTime, nextStartTime, breakTime,
                     teams, groups, fields);
               gameTime = result.getFirst();
               nextStartTime = result.getSecond();
               status = 2;
               break;
            case 2:
               nextStartTime = VolleyMode.finalRound(totalTime, 3, nextStartTime, breakTime,
                     teams, groups, fields);
               gameTime = totalTime;
               status = 3;
               break;
            case 3:
               VolleyMode.finalRound(totalTime, 4, nextStartTime, breakTime, teams, groups,
                     fields);
               gameTime = totalTime;
               status = 4;
               break;
            case 4:
               status = 5;
         }
      } catch (Exception ex) {
         ex.printStackTrace();
      }
   }

   public void updateAllScores(int status) {
      for (Team t : teams) {
         t.updateScore(status);
      }
   }

   public List<List<Match>> getOverviewTable(int status) {
      List<List<Match>> result = new LinkedList<List<Match>>();

      List<Iterator<Match>> matchiterators = new LinkedList<Iterator<Match>>();
      // one matchiterator for every field
      List<Match> actualMatches = new LinkedList<Match>();
      // matches that are to come next, index corresponds to group index

      // Set matchiterators and actualMatches;
      Iterator<Field> fieldIterator = fields.iterator();
      Field tempField;
      Iterator<Match> temp;
      while (fieldIterator.hasNext()) {
         tempField = fieldIterator.next();
         temp = tempField.getActiveMatches(status).iterator();
         matchiterators.add(temp);
         if (temp.hasNext()) {
            actualMatches.add(temp.next());
         } else {
            actualMatches.add(null);
         }
      }

      // Set times
      List<Time> times = new LinkedList<Time>();
      Iterator<Match> it = fields.get(0).getActiveMatches(status).iterator(); // get iterator
                                                                              // of first
                                                                              // field (which
                                                                              // is dense)
      while (it.hasNext()) {
         times.add(it.next().getTime());
      }

      // Loop over all the times and all the fields and add a match if there is one.
      Iterator<Time> timeIterator = times.iterator();
      Time actualTime;
      List<Match> tempResult;
      while (timeIterator.hasNext()) {
         tempResult = new LinkedList<Match>();
         actualTime = timeIterator.next();
         for (int i = 0; i < fields.size(); i++) {
            if (actualMatches.get(i) != null
                  && actualMatches.get(i).getTime().equals(actualTime)) {
               // add to table
               tempResult.add(actualMatches.get(i));
               // set next match in that group to actual match if there is one
               if (matchiterators.get(i).hasNext()) {
                  actualMatches.set(i, matchiterators.get(i).next());
               } else {
                  actualMatches.set(i, null);
               }
            } else {
               // add a void match
               tempResult.add(null);
            }
         }
         result.add(tempResult);
      }
      return result;
   }

   public List<Group> getActiveGroups(int status) {
      return VolleyMode.getActiveGroups(groups, status);
   }

   public double getBetrag() {
      Iterator<Team> it = teams.iterator();
      double result = 0;
      while (it.hasNext()) {
         result += it.next().getBetrag();
      }
      result = ((double) Math.round(result * 100)) / 100;
      return result;
   }

   public List<Team> getBestSponsors() {
      Iterator<Team> it = teams.iterator();
      double bestBetrag = 0;
      Team temp;
      List<Team> result = new LinkedList<Team>();
      while (it.hasNext()) {
         temp = it.next();
         if (temp.getBetrag() > bestBetrag) {
            bestBetrag = temp.getBetrag();
            result = new LinkedList<Team>();
         }
         if (temp.getBetrag() >= bestBetrag) {
            result.add(temp);
         }
      }
      return result;
   }
}
