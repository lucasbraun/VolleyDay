package volleyObjects;

import java.io.Serializable;

public class Match implements Serializable, Comparable<Match>{

	private static final long serialVersionUID = 1L;
	private Team team1;
	private Team team2;
	private int points1;
	private int points2;
	private int goals1;
	private int goals2;
	private Field field;
	private Time time;
	private int status;
	
	public Match (Team team1, Team team2, int status) {
		this.setTeam1(team1);
		team1.addMatch(this);
		this.setTeam2(team2);
		team2.addMatch(this);
		points1 = 0;
		points2 = 0;
		goals1 = 0;
		goals2 = 0;
		this.status = status;
	}
	
	public void setResult (int goals1, int goals2) {
		this.goals1 = goals1;
		this.goals2 = goals2;
		if (goals1 > goals2) {
			points1 = 2;
			points2 = 0;
		} else {
			if (goals1 < goals2) {
				points1 = 0;
				points2 = 2;
			} else if (goals1 > 0){
				points1 = 1;
				points2 = 1;
			}
		}
		// tell teams they have to update the score
		team1.setHasChanged();
		team2.setHasChanged();
	}

	public int getGoals1() {
		return goals1;
	}
	
	public int getGoals2() {
		return goals2;
	}

	public int getPoints1() {
		return points1;
	}
	
	public int getPoints2() {
		return points2;
	}

	public void setTeam1(Team team1) {
		this.team1 = team1;
	}

	public Team getTeam1() {
		return team1;
	}

	public void setTeam2(Team team2) {
		this.team2 = team2;
	}

	public Team getTeam2() {
		return team2;
	}
	
	public int getStatus() {
		return status;
	}

	public void setTime(Time time) {
		this.time = time;
	}

	public Time getTime() {
		return time;
	}

	public void setField(Field field) {
		this.field = field;
	}

	public Field getField() {
		return field;
	}
	
	public int participatesIn(Match arg0) {
		// returns 1 if Team1 participates in arg0, 2 if Team 2 does and 3 if both do, 0 if none does
		int result = 0;
		if (arg0.getTeam1() == team1 || arg0.getTeam2() == team1)
			result += 1;
		if (arg0.getTeam1() == team2 || arg0.getTeam2() == team2)
			result += 2;
		return result;
	}

	@Override
	public int compareTo(Match arg0){
		if (time.equals(arg0.time))
			return 0;
		else
			return time.compareTo(arg0.time);
	}
}
