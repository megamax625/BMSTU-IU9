import javax.swing.*;
import java.awt.*;

public class CanvasPanel extends JPanel {
    private int size = 10;
    private String type = "фигура О";
    public void setSize(int s) {
        size = s;
        repaint();
    }
    public void setType(String s) {
        type = s;
        repaint();
    }
    protected void paintComponent(Graphics g) {
        super.paintComponent(g);
        int i;
        if (type.equals("Фигура O")) {
            g.setColor(Color.YELLOW);
            g.fillRect(100, 100, size * 2, size * 2);
        }
        if (type.equals("Фигура I")) {
            g.setColor(Color.CYAN);
            for (i = 0; i < 4; i++) g.fillRect(100 + i * size, 100, size, size);
        }
        if (type.equals("Фигура L")) {
            g.setColor(Color.ORANGE);
            for (i = 0; i < 3; i++) g.fillRect(100, 100 + i * size, size, size);
            g.fillRect(100 + size, 100 + 2 * size, size, size);
        }
        if (type.equals("Фигура J")) {
            g.setColor(Color.BLUE);
            for (i = 0; i < 3; i++) g.fillRect(100, 100 - i * size, size, size);
            g.fillRect(100 - size, 100 - 2 * size, size, size);
        }
        if (type.equals("Фигура Z")) {
            g.setColor(Color.RED);
            for (i = 0; i < 2; i++) g.fillRect(100 + i * size, 100, size, size);
            for (i = 0; i < 2; i++) g.fillRect(100 + size + i * size, 100 - size, size, size);
        }
        if (type.equals("Фигура S")) {
            g.setColor(Color.GREEN);
            for (i = 0; i < 2; i++) g.fillRect(100 - i * size, 100, size, size);
            for (i = 0; i < 2; i++) g.fillRect(100 - size - i * size, 100 - size, size, size);
        }
        if (type.equals("Фигура T")) {
            g.setColor(Color.PINK);
            for (i = 0; i < 3; i++) g.fillRect(100 + i * size, 100, size, size);
            g.fillRect(100 + size, 100 + size, size, size);
        }
    }
}