public class KineticTest {
    public static void main(String[] args){
        Particle partX = new Particle(2, 1, 0, 0);
        Particle partY = new Particle(2, 0, 1, 0);
        Particle partZ = new Particle(2, 0, 0, 1);
        Particle partXYZ = new Particle(2, 1, 1, 1);
        System.out.println("Particle 1's kinetic energy is " + partX.kineticCalc());
        System.out.println("Particle 2's kinetic energy is " + partY.kineticCalc());
        System.out.println("Particle 3's kinetic energy is " + partZ.kineticCalc());
        System.out.println("Particle 4's kinetic energy is " + partXYZ.kineticCalc());
        int num = (int)(Math.random() * 5000000);
        System.out.println("Creating " + num + " new particles");
        Particle[] particles = new Particle[num + 4];
        particles[0] = partX;
        particles[1] = partY;
        particles[2] = partZ;
        particles[3] = partXYZ;
        for (int i = 4; i < num + 4; i++){
            Particle part = new Particle(Math.random(), Math.random() * 5, Math.random() * 5, Math.random() * 5);
            particles[i] = part;
        }
        double kineticTotal = 0;
        for (int i = 0; i < Particle.count; i++){
            kineticTotal += particles[i].kineticCalc();
        }
        System.out.println("Total kinetic energy of " + Particle.count + " particles is " + kineticTotal);
    }
}