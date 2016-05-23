package volleyObjects;

import java.io.Serializable;

public class Ticket implements Serializable, Comparable<Ticket> {

	private static final long serialVersionUID = 1L;
	private Integer remainingMatches;	// number of remaining matches for this group
	private Integer index;				// group index
	
	public Ticket(int index, int remainingMatches) {
		this.index = index;
		this.remainingMatches = remainingMatches;
	}
	
	public void setRemainingMatches(Integer remainingMatches) {
		this.remainingMatches = remainingMatches;
	}
	
	public Integer getRemainingMatches() {
		return remainingMatches;
	}
	
	public Integer getIndex() {
		return index;
	}
	
	@Override
	public int compareTo(Ticket arg0) {
		// < means still more matches, as we want to give priority to that, second priority: lower index
		if (remainingMatches==arg0.remainingMatches) {
			return index.compareTo(arg0.index);
		} else {
			return arg0.remainingMatches.compareTo(this.remainingMatches);
		}
	}
}