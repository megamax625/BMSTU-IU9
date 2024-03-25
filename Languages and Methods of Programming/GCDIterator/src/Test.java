public class Test {
    public static void main(String[] args) {
        GCDSequence a = new GCDSequence(new Integer[] {2, 2, 30, 5, 10}); // GGCD = 5, LGCD = 2
        GCDSequence b = new GCDSequence(new Integer[] {10, 30, 40, 50}); // GGCD = 10, LGCD = 10
        GCDSequence rand = new GCDSequence(new Integer[] {(int)(Math.random() * 10000), (int)(Math.random() * 10000),
                (int)(Math.random() * 10000), (int)(Math.random() * 10000), (int)(Math.random() * 10000)});
        System.out.println(a.loopGCD());
        a.addInt(1); // LGCD should change to 1
        System.out.println(a.loopGCD());
        a.addInt(2, 30); // GGCD should change to 30
        System.out.println(a.loopGCD());
        System.out.println(b.loopGCD());
        b.addInt(100); // GGCD should change to 50
        System.out.println(b.loopGCD());
        b.addInt(3, 5); // LGCD should change to 5
        System.out.println(b.loopGCD());
        System.out.println(rand.loopGCD());
    }
}