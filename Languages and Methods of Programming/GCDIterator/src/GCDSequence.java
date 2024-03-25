import java.util.Iterator;
import java.util.ArrayList;
import java.util.Arrays;

public class GCDSequence implements Iterable<Integer>{
    private ArrayList<Integer> seq;
    GCDSequence(Integer[] arr){
        seq = new ArrayList<>(Arrays.asList(arr));
    }
    private class GCDIterator implements Iterator<Integer> {
        private int pos;
        private int calcGCD(int a, int b){
            if (b == 0) return a;
            else return calcGCD(b, a % b);
        }
        public GCDIterator() {pos = 0;}
        public boolean hasNext() {return pos < seq.size() - 1;}
        public Integer next() {
            return calcGCD(seq.get(pos), seq.get(++pos));
        }
    }
    public Iterator<Integer> iterator() {return new GCDIterator();}
    public void addInt(Integer x) {
        seq.add(x);
    }
    public void addInt(int index, Integer x) {
        seq.add(index, x);
    }
    public String loopGCD() {
        int greatestGCD = 0, lowestGCD = 10000;
        for (Integer currentGCD : this) {
            if (currentGCD > greatestGCD) greatestGCD = currentGCD;
            if (currentGCD < lowestGCD) lowestGCD = currentGCD;
        }
        return ("Sequence: " + seq + ", Greatest GCD = " + greatestGCD + ", lowest GCD = " + lowestGCD);
    }
}