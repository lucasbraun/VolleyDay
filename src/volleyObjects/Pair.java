package volleyObjects;

import java.io.Serializable;

public class Pair<G,H> implements Serializable{
	
	private static final long serialVersionUID = 1L;
	private G first;
	private H second;
	
	public Pair(G first, H second){
		this.first = first;
		this.second = second;
	}

	public void setFirst(G first) {
		this.first = first;
	}

	public G getFirst() {
		return first;
	}

	public void setSecond(H second) {
		this.second = second;
	}

	public H getSecond() {
		return second;
	}
}