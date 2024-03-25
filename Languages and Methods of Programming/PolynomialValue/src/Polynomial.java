import java.util.HashMap;
import java.util.Map;

public class Polynomial implements Comparable<Polynomial>{
    private int x;
    HashMap<String, String> map;
    public Polynomial(int xinput, int[][] indexes) {
        map = new HashMap<String, String>();
        this.x = xinput;
        for (int[] i : indexes){
            map.put(Integer.toString(i[0]), Integer.toString(i[1]));
        }
    }
    public String toString(){
        String res = "";
        for (String key : map.keySet()){
            res = res + map.get(key) + "x^" + key + " + ";
        }
        res = res + "0";
        return res;
    }
    public double calcValue(){
        double res = 0;
        for (String key : map.keySet()){
            res += Integer.parseInt(map.get(key)) * Math.pow(x, Double.parseDouble(key));
        }
        return res;
    }
    public double getArg(){
        return x;
    }
    public int compareTo(Polynomial obj){
        double first = this.calcValue();
        double second = obj.calcValue();
        if (first == second) return 0;
        if (first > second) return 1;
        else return -1;
    }
}
