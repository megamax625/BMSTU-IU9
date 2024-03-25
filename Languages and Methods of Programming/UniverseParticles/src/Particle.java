public class Particle {
    static int count = 0;
    double mass, vx, vy, vz;
    Particle(double m, double x, double y, double z){
        mass = m;
        vx = x;
        vy = y;
        vz = z;
        count += 1;
    }
    double vel(){
        return Math.sqrt(vx * vx + vy * vy + vz * vz);
    }
    double kineticCalc(){
        return mass * Math.pow(this.vel(), 2) / 2;
    }
}