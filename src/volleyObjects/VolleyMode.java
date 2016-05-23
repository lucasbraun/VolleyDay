package volleyObjects;

import java.io.Serializable;
import java.util.Collections;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;
import java.util.Set;
import java.util.TreeSet;
import java.util.Vector;

/**
 * This class does all the magic of a volleyday tournament. The public functions could later
 * be exported to a common API. The important functions for doing the match/field
 * partitioning correctly, are isNearEnough(i,j) and getRange(i).
 * 
 * @see VolleyMode#isNearEnough(int, int)
 * @see VolleyMode#getRange(int)
 * @author Lucas
 * @version 1.0
 */
public class VolleyMode implements Serializable {

   private static final long serialVersionUID = 1L;

   public static int[] checkParamters(int gpt, int totalTime, int minTime, int maxTime,
         int breakTime, int fieldCount, int teamCount) {
      // if check OK returns "ok", if not OK returns the lower and upper bound
      // set lb (lower bounds) and ub (upper bounds)
      int lbTotalGames = Math.round(fieldCount * totalTime / (maxTime + breakTime));
      int ubTotalGames = Math.round(fieldCount * totalTime / (minTime + breakTime));
      int lbGpt = Math.round(2 * lbTotalGames / teamCount);
      int ubGpt = Math.round(2 * ubTotalGames / teamCount);
      int[] result = new int[0];

      if (gpt <= ubGpt && gpt >= lbGpt) {
         return result;
      }

      // gpt not within bounds
      result = new int[2];
      result[0] = lbGpt;
      result[1] = ubGpt;
      return result;
   }

   public static Pair<Integer, Time> round1(int gamesPerTeam, int totalTime, Time starttime,
         int breakTime, List<Team> teams, List<Group> groups, List<Field> fields)
         throws Exception {

      // determine number of groups
      int teamsPerGroup = gamesPerTeam + 1;
      int groupNumber = teams.size() / teamsPerGroup;
      if ((teams.size() % teamsPerGroup) > 0) {
         groupNumber++;
      }

      // create groups
      Character c = new Character('A');
      for (int i = 0; i < groupNumber; i++) {
         groups.add(new Group("Gruppe " + (c++), 1));
      }

      // insert teams into groups
      for (int i = 0; i < teams.size(); i++) {
         groups.get(i % groupNumber).addMember(teams.get(i));
      }

      // create matches
      for (int i = 0; i < groups.size(); i++) {
         groups.get(i).createMatches(groups.get(0).getMemberCount());
      }

      // match fields to matches (null matches can be created)
      matchFields(groups, fields);

      // set time schedule (and remove null matches)
      int gameTime = totalTime / fields.get(0).getNumberOfActiveMatches(1);
      gameTime -= breakTime;
      Time endingTime = setSchedule(starttime, gameTime, breakTime, fields, 1);

      // return game time and ending Clock
      return (new Pair<Integer, Time>(gameTime, endingTime));
   }

   public static Pair<Integer, Time> round2(int gamesPerTeam, int totalTime, Time starttime,
         int breakTime, List<Team> teams, List<Group> groups, List<Field> fields)
         throws Exception {
      // in this second half, we have a "winner" and a "looser" table

      // determine number of groups
      int teamsPerGroup = gamesPerTeam + 1;
      int groupNumber = teams.size() / teamsPerGroup;
      if ((teams.size() % teamsPerGroup) > 0) {
         groupNumber++;
      }

      // create winner groups
      Group tempGroup;
      List<Group> winnerGroups = new LinkedList<Group>();
      for (int i = 0; i < (groupNumber + 1) / 2; i++) {
         tempGroup = new Group("Gruppe A" + String.valueOf(i + 1), 2);
         groups.add(tempGroup);
         winnerGroups.add(tempGroup);
      }

      // create loser groups
      List<Group> loserGroups = new LinkedList<Group>();
      for (int i = 0; i < groupNumber / 2; i++) {
         tempGroup = new Group("Gruppe B" + String.valueOf(i + 1), 2);
         groups.add(tempGroup);
         loserGroups.add(tempGroup);
      }

      // insert teams into groups

      // get the winner and loser teams from first round and redistribute them
      List<Group> old = getActiveGroups(groups, 1);
      int totalSize = winnerGroups.size() + loserGroups.size();
      int r = teams.size() % totalSize;
      int k = teams.size() / totalSize * winnerGroups.size()
            + (r > winnerGroups.size() ? winnerGroups.size() : r);
      Pair<List<Team>, List<Team>> result = getKBestTeams(k, old);
      redistribute(result.getFirst(), old, winnerGroups);
      redistribute(result.getSecond(), old, loserGroups);

      // create matches for winner and loser groups
      for (int i = 0; i < winnerGroups.size(); i++) {
         winnerGroups.get(i).createMatches(winnerGroups.get(0).getMemberCount());
      }
      for (int i = 0; i < loserGroups.size(); i++) {
         loserGroups.get(i).createMatches(loserGroups.get(0).getMemberCount());
      }

      // match fields to matches (null matches can be created)
      if (winnerGroups.size() + loserGroups.size() == 4 && fields.size() == 6
            && winnerGroups.get(0).getMemberCount() == 6 && teams.size() > 21
            && teams.size() < 25) {
         matchFields2(getActiveGroups(groups, 2), fields);
      } else {
         matchFields(getActiveGroups(groups, 2), fields);
      }

      // set time schedule (and remove null matches)
      int gameTime = totalTime / fields.get(0).getNumberOfActiveMatches(2);
      gameTime -= breakTime;
      Time endingTime = setSchedule(starttime, gameTime, breakTime, fields, 2);

      // return game time and ending Clock
      return (new Pair<Integer, Time>(gameTime, endingTime));
   }

   public static Time finalRound(int gameTime, int status, Time starttime, int breakTime,
         List<Team> teams, List<Group> groups, List<Field> fields) {
      // for finals and semi-finals, two new groups are built (loser finals or winner finals)
      List<Group> oldGroups = getActiveGroups(groups, status - 1);
      int k = (status == 3) ? 4 : 2;
      String groupname;

      // Get teams for winner finals, create matches and add them to fields
      List<Group> tempGroups = new LinkedList<Group>();
      for (int i = 0; i < (oldGroups.size() + 1) / 2; i++) {
         tempGroups.add(oldGroups.get(i));
      }
      List<Team> tempList = getKBestTeams(k, tempGroups).getFirst();
      groupname = (status == 3) ? "Halbfinal A" : "Final A";
      Group tempGroup = new Group(groupname, status);
      tempGroup.addMembers(tempList);
      tempGroup.createFinalMatches();
      groups.add(tempGroup);

      int fieldIndex = fields.size() / 2;
      for (Match m : tempGroup.getMatches()) {
         fields.get(fieldIndex).addMatch(m);
         m.setField(fields.get(fieldIndex));
         fieldIndex++;
      }

      // Get teams for loser finals, create matches and add them to fields
      tempGroups = new LinkedList<Group>();
      for (int i = (oldGroups.size() + 1) / 2; i < oldGroups.size(); i++) {
         tempGroups.add(oldGroups.get(i));
      }
      tempList = getKBestTeams(k, tempGroups).getFirst();
      groupname = (status == 3) ? "Halbfinal B" : "Final B";
      tempGroup = new Group(groupname, status);
      tempGroup.addMembers(tempList);
      tempGroup.createFinalMatches();
      groups.add(tempGroup);

      fieldIndex = 0;
      for (Match m : tempGroup.getMatches()) {
         fields.get(fieldIndex).addMatch(m);
         m.setField(fields.get(fieldIndex));
         fieldIndex++;
      }

      if (k == 2) {
         // remove the winner final and put it later in the first field
         Field tempField = fields.get(fields.size() / 2);
         Match tempMatch = tempField.getMatches().get(tempField.getMatches().size() - 1);
         tempField.getMatches().remove(tempMatch);
         tempField = fields.get(0);
         tempMatch.setField(tempField);
         tempField.addMatch(tempMatch);
      }

      // matchFields(getActiveGroups(groups, status), fields);
      return setSchedule(starttime, gameTime, breakTime, fields, status);
   }

   public static List<Group> getActiveGroups(List<Group> groups, int status) {
      Vector<Group> result = new Vector<Group>();
      Iterator<Group> it = groups.iterator();
      while (it.hasNext()) {
         Group group = it.next();
         if (group.getStatus() == status) {
            result.add(group);
         }
      }
      return result;
   }

   private static void matchFields(List<Group> groups, List<Field> fields) {
      // this function can produce null matches as place-holders
      // teams should at least play twice in a row. if so, it should be on the same field!

      if (groups.size() == 2 && fields.size() == 4
            && groups.get(0).getMemberCount() == groups.get(1).getMemberCount()) {
         // special case for Volleyday 2012
         List<Group> tempGroup;
         List<Field> tempField;
         tempGroup = new LinkedList<Group>();
         tempGroup.add(groups.get(0));
         tempField = new LinkedList<Field>();
         tempField.add(fields.get(0));
         tempField.add(fields.get(1));
         matchFields(tempGroup, tempField);
         tempGroup = new LinkedList<Group>();
         tempGroup.add(groups.get(1));
         tempField = new LinkedList<Field>();
         tempField.add(fields.get(2));
         tempField.add(fields.get(3));
         matchFields(tempGroup, tempField);
         return;
      }

      // initialize tickets and matchlists, index refers to group index
      Set<Ticket> tickets = new TreeSet<Ticket>();
      List<List<Match>> matchlists = new LinkedList<List<Match>>();
      Iterator<Match> mit;
      int totalMatches = 0;
      int scheduledMatches = 0;

      Group temp;
      List<Match> tempList;
      for (int i = 0; i < groups.size(); i++) {
         temp = groups.get(i);
         tickets.add(new Ticket(i, temp.getMatchCount()));
         totalMatches += temp.getMatchCount();
         tempList = new LinkedList<Match>();
         mit = temp.getMatches().iterator();
         while (mit.hasNext()) {
            tempList.add(mit.next());
         }
         matchlists.add(tempList);
      }

      // initialize previous and current round, index in list corresponds to field index
      List<Match> preprevRound = getNullRound(fields.size());
      List<Match> previousRound = getNullRound(fields.size());
      List<Match> currentRound = getNullRound(fields.size());

      // match the matches to the fields
      int fieldIndex = 0;
      Field tempField;
      Ticket tempTicket;
      int tempIndex; // temporary group index
      Match tempMatch;
      Iterator<Ticket> it;
      while (scheduledMatches < totalMatches) {
         if (fieldIndex == 0) {
            // update previous round, initialize currentRound
            preprevRound = previousRound;
            previousRound = currentRound;
            currentRound = getNullRound(fields.size());
         }

         tempField = fields.get(fieldIndex);
         tempMatch = null;

         // first of all, the system should check whether a team could play two matches in a
         // row on the
         // same field (groups must have at least 3 teams, otherwise this group is
         // blocking!!)
         if (previousRound.get(fieldIndex) != null) {
            for (int i = 0; i < matchlists.size(); i++) {
               if (matchlists.get(i).size() > 0) {
                  tempMatch = matchlists.get(i).get(0); // get next match to schedule of a
                                                        // certain group
                  if ((tempMatch.participatesIn(previousRound.get(fieldIndex)) > 0)
                        && (checkPreviousRound(tempMatch, previousRound, preprevRound,
                              fields, fieldIndex))
                        && checkActualRound(tempMatch, currentRound)) {
                     // match Field to Match
                     tempMatch.setField(tempField);

                     // adjust helping values
                     scheduledMatches++;
                     matchlists.get(i).remove(tempMatch);

                     // find ticket to change and change it
                     it = tickets.iterator();
                     while (it.hasNext()) {
                        tempTicket = it.next();
                        if (tempTicket.getIndex() == i) {
                           tickets.remove(tempTicket);
                           tempTicket
                                 .setRemainingMatches(tempTicket.getRemainingMatches() - 1);
                           tickets.add(tempTicket);
                           break;
                        }
                     }

                     // match is found and has been placed --> break
                     break;
                  } else {
                     tempMatch = null;
                  }
               }
            }
         }

         // search for group and match in ticket order
         it = tickets.iterator();
         while (it.hasNext() && tempMatch == null) { // tempMatch is null as long as no match
                                                     // is found!
            tempTicket = it.next();
            tempIndex = tempTicket.getIndex();
            tempList = matchlists.get(tempIndex);

            // test which match of this group can be put
            mit = tempList.iterator();
            while (mit.hasNext() && tempMatch == null) {
               tempMatch = mit.next();
               if (checkActualRound(tempMatch, currentRound)
                     && checkPreviousRound(tempMatch, previousRound, preprevRound, fields,
                           fieldIndex)) {
                  // match Field to Match
                  tempMatch.setField(tempField);

                  // adjust helping values
                  scheduledMatches++;
                  tickets.remove(tempTicket);
                  tempTicket.setRemainingMatches(tempTicket.getRemainingMatches() - 1);
                  tickets.add(tempTicket);
                  tempList.remove(tempMatch);
               } else {
                  tempMatch = null;
               }
            }
         }

         // match Match to Field and update currentRound, in worst case add null value
         tempField.addMatch(tempMatch);
         currentRound.set(fieldIndex, tempMatch);

         // iterate to next field
         fieldIndex = (fieldIndex + 1) % fields.size();
      }
   }

   /**
    * not used at the moment as not sure whether it works properly
    * 
    * @param groups
    * @param fields
    */
   private static void matchFields2(List<Group> groups, List<Field> fields) {
      // special matching function for a special case!
      // case where number of groups divides number of fields and groups are of equal size
      // fields must be nearby!
      int matchCount = groups.get(0).getMatchCount();
      int gamesPerRound = groups.get(0).getMemberCount() / 2;
      int rounds = groups.get(0).getMemberCount() - 1;
      int fieldIndex = 0;
      Group tempGroup;
      Field tempField;
      Match tempMatch = null;

      for (int r = 0; r < rounds; r++) {
         for (int g = 0; g < groups.size(); g++) {
            tempGroup = groups.get(g);
            for (int i = 0; i < gamesPerRound; i++) {
               tempField = fields.get(fieldIndex);
               if (tempGroup.getMatchCount() == matchCount) {
                  tempMatch = tempGroup.getMatches().get(r * gamesPerRound + i);
               } else { // memberCount is one smaller
                  if (i < gamesPerRound - 1) {
                     tempMatch = tempGroup.getMatches().get(r * (gamesPerRound - 1) + i);
                  } else {
                     tempMatch = null;
                  }
               }
               if (tempMatch != null) {
                  tempMatch.setField(tempField);
               }
               tempField.addMatch(tempMatch);
               fieldIndex = (fieldIndex + 1) % fields.size();
            }
         }
      }
   }

   private static List<Match> getNullRound(int size) {
      List<Match> result = new LinkedList<Match>();
      for (int i = 0; i < size; i++) {
         result.add(null);
      }
      return result;
   }

   private static boolean checkActualRound(Match m, List<Match> actualRound) {
      // returns true if none of the teams is engaged in the same round
      boolean result = true;
      Iterator<Match> it = actualRound.iterator();
      Match temp;
      while (it.hasNext()) {
         temp = it.next();
         if (temp != null && (m.participatesIn(temp) > 0)) {
            result = false;
            break;
         }
      }
      return result;
   }

   private static boolean checkPreviousRound(Match m, List<Match> previousRound,
         List<Match> preprevRound, List<Field> fields, int fieldIndex) {
      // returns true if teams were not engaged in previous round or, if so, on the same or a
      // near field, and not 3 times in a row!

      int matchCount1 = 0;
      int matchCount2 = 0;
      int fieldIndex1 = -1;
      int fieldIndex2 = -1;
      int participatedIn;

      // check two rounds before
      for (int i = 0; i < preprevRound.size(); i++) {
         participatedIn = preprevRound.get(i) == null ? 0 : m.participatesIn(preprevRound
               .get(i));
         if (participatedIn == 1 || participatedIn == 3) {
            matchCount1++;
         }
         if (participatedIn > 1) {
            matchCount2++;
         }
      }

      // check round before
      for (int i = 0; i < previousRound.size(); i++) {
         participatedIn = previousRound.get(i) == null ? 0 : m.participatesIn(previousRound
               .get(i));
         if (participatedIn == 1 || participatedIn == 3) {
            fieldIndex1 = i;
            matchCount1++;
         }
         if (participatedIn > 1) {
            fieldIndex2 = i;
            matchCount2++;
         }
      }

      // make sure that teams do not play 3 times in a row
      if (matchCount1 > 1 || matchCount2 > 1) {
         return false;
      }

      // make sure team 1 doesn't have to travel too far
      if ((fieldIndex1 >= 0)
            && !isNearEnough(fields.get(fieldIndex1), fields.get(fieldIndex))) {
         return false;
      }

      // make sure team 2 doesn't have to travel too far
      if ((fieldIndex2 >= 0)
            && !isNearEnough(fields.get(fieldIndex2), fields.get(fieldIndex))) {
         return false;
      }

      return true;
   }

   private static boolean isNearEnough(Field field1, Field field2) {
      return field1.getRegionIndex() == field2.getRegionIndex();
   }

   private static Time setSchedule(Time startTime, int gameTime, int breakTime,
         List<Field> fields, int status) {
      // this function should wipe out null matches if there are any

      Iterator<Field> it = fields.iterator();
      Iterator<Match> mit;
      List<Match> voidMatches;
      Match temp;
      Time clock = new Time(0, 0);
      Time result = new Time(clock);
      Field field;
      while (it.hasNext()) {
         field = it.next();
         clock = new Time(startTime);
         voidMatches = new LinkedList<Match>();
         mit = field.getActiveMatches(status).iterator();
         while (mit.hasNext()) {
            temp = mit.next();
            if (temp != null) {
               temp.setTime(new Time(clock));
            } else {
               voidMatches.add(temp);
            }
            clock.addMinutes(gameTime + breakTime);
            if (clock.compareTo(result) > 0) {
               result = new Time(clock);
            }
         }
         field.getMatches().removeAll(voidMatches);
      }
      return (result);
   }

   private static Pair<List<Team>, List<Team>> getKBestTeams(int k, List<Group> groups) {
      // We consider that the first teams of every group are directly qualified and some
      // places are given to
      // the remaining teams with most of the points
      List<Team> winners = new LinkedList<Team>();
      List<Team> losers = new LinkedList<Team>(); // all teams start in loser group, some go
                                                  // to the winners

      int status = groups.get(0).getStatus();
      Iterator<Team> it;
      Iterator<Group> git = groups.iterator();
      Team tempTeam;
      while (git.hasNext()) {
         it = git.next().members.iterator();
         while (it.hasNext()) {
            tempTeam = it.next();
            losers.add(tempTeam);
            tempTeam.updateScore(status);
         }
      }

      int directsperGroup = k / groups.size();
      int totalIndirects = k - groups.size() * directsperGroup;

      Group tempGroup;
      List<Team> tempList;
      git = groups.iterator();

      // sort out all directly qualified teams
      while (git.hasNext()) {
         tempGroup = git.next();
         // tempList = new LinkedList<Team>((new
         // TreeSet<Team>(tempGroup.members)).descendingSet());
         tempList = new LinkedList<Team>(tempGroup.members);
         Collections.sort(tempList);
         Collections.reverse(tempList);
         for (int i = 0; i < directsperGroup; i++) {
            winners.add(tempList.get(i));
            losers.remove(tempList.get(i));
         }
      }

      // sort out the remaining teams
      // tempList = new LinkedList<Team>((new TreeSet<Team>(losers)).descendingSet());
      tempList = new LinkedList<Team>(losers);
      Collections.sort(tempList);
      Collections.reverse(tempList);
      for (int i = 0; i < totalIndirects; i++) {
         winners.add(tempList.get(i));
         losers.remove(tempList.get(i));
      }

      return (new Pair<List<Team>, List<Team>>(winners, losers));
   }

   /**
    * redistribute teams that were part of old groups into new groups
    * 
    * @param teams
    *           teams to be distributed
    * @param oldGroups
    *           is a super-set of teams
    * @param newGroups
    */
   private static void redistribute(List<Team> teams, List<Group> oldGroups,
         List<Group> newGroups) {
      // create a templist where teams are ordered along old groups
      List<Team> tmpList = new LinkedList<Team>();
      for (Group g : oldGroups) {
         for (Team t : g.members) {
            if (teams.contains(t)) {
               tmpList.add(t);
            }
         }
      }

      // fill the teams in the temp list to new groups
      int groupIndex = 0;
      for (Team t : tmpList) {
         newGroups.get(groupIndex).addMember(t);
         groupIndex = (groupIndex + 1) % newGroups.size();
      }
   }
}
