package volleyObjects;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.Serializable;

public class TournamentLoader implements Serializable {

   private static final long serialVersionUID = 1L;

   public static boolean saveTournament(Tournament t, String filename) {
      try {
         FileOutputStream fos = new FileOutputStream("trs/" + filename);
         ObjectOutputStream out = new ObjectOutputStream(fos);
         out.writeObject(t);
         out.close();
         return true;
      } catch (FileNotFoundException e) {
         return false;
      } catch (IOException e) {
         return false;
      }
   }

   public static Tournament loadTournament(String filename) {
      try {
         FileInputStream fis = new FileInputStream("trs/" + filename);
         ObjectInputStream in = new ObjectInputStream(fis);
         Tournament result = (Tournament) in.readObject();
         in.close();
         return result;
      } catch (FileNotFoundException e) {
         return null;
      } catch (IOException e) {
         return null;
      } catch (ClassNotFoundException e) {
         return null;
      }
   }

   public static Tournament createTournament(int teamCount, int fieldCount, int minTime,
         int maxTime, int breakTime, String nextStartTime) {
      Tournament result = new Tournament();
      result.setTeamCount(teamCount);
      result.setFieldCount(fieldCount);
      result.setMinTime(minTime);
      result.setMaxTime(maxTime);
      result.setBreakTime(breakTime);
      result.setNextStartTime(nextStartTime);
      return result;
   }

   public static File[] getFileList() {
      File file = new File("trs/");
      return file.listFiles();
   }
}
