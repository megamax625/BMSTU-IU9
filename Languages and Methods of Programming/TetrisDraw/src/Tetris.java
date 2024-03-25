import javax.swing.*;
import javax.swing.event.ChangeEvent;
import javax.swing.event.ChangeListener;

public class Tetris {
    private JPanel mainPanel;
    private JSpinner SizeSpinner;
    private JSlider figureType;
    private JTextField areaField;
    private JTextArea textType;
    private CanvasPanel canvasPanel;

    public Tetris() {
        SizeSpinner.addChangeListener(new ChangeListener() {
            @Override
            public void stateChanged(ChangeEvent e) {
                int Area = (int)SizeSpinner.getValue();
                canvasPanel.setSize(Area);
                Area *= Area;
                areaField.setText(new String(String.valueOf(Area)));
            }
        });
        SizeSpinner.setValue(20);
        figureType.addChangeListener(new ChangeListener() {
            @Override
            public void stateChanged(ChangeEvent e) {
                String str = "";
                if (figureType.getValue() == 0) str = "Фигура O";
                if (figureType.getValue() == 1) str = "Фигура I";
                if (figureType.getValue() == 2) str = "Фигура L";
                if (figureType.getValue() == 3) str = "Фигура J";
                if (figureType.getValue() == 4) str = "Фигура Z";
                if (figureType.getValue() == 5) str = "Фигура S";
                if (figureType.getValue() == 6) str = "Фигура T";
                textType.setText(str);
                canvasPanel.setType(str);
            }
        });
    }
    public static void main(String[] args) {
        JFrame frame = new JFrame("Tetris");
        frame.setContentPane(new Tetris().mainPanel);
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.pack();
        frame.setVisible(true);
    }
}
