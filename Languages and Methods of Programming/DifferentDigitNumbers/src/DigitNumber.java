public class DigitNumber implements Comparable<DigitNumber>{
    private int number;
    private int count, memocap;
    private int[] memo;
    public DigitNumber(int x){
        number = x;
        count = 0;
        memo = new int[10];
        for (int i = 0; i < 10; i++) memo[i] = 10;
        memocap = 0;
    }
    public int getNumber(){
        return number;
    }
    private int inMemo(int x){
        for (int i : memo) if (i == x) return 1;
        return -1;
    }
    public String toString(){
        return "" + number;
    }
    public int differentDigitCalc(){
        int numbercopy = number;
        if (numbercopy == 0) return 1;
        else {
            int digit = numbercopy % 10;
            while (numbercopy != 0) {
                if (inMemo(digit) == -1) {
                    count++;
                    memo[memocap] = digit;
                    memocap++;
                }
                numbercopy /= 10;
                digit = numbercopy % 10;
            }
        }
        return count;
    }
    public int compareTo(DigitNumber obj){
        if (this.differentDigitCalc() == obj.differentDigitCalc()) return 0;
        else if (this.differentDigitCalc() > obj.differentDigitCalc()) return 1;
        else return -1;
    }
}
