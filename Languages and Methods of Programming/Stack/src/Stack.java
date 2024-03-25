/// Dynamic integer stack with empty, push, pop
public class Stack {
    int cap, top;
    int[] data;
    Stack() {
        cap = 5;
        top = 0;
        data = new int[cap];
    }
    boolean empty(){
        return top == 0;
    }
    void push(int x){
        if (top == cap) this.enlarge(x);
        else data[top] = x;
        top++;
    }
    int pop(){
        if (this.empty()) System.out.println("Stack Depleted");
        else {
            top--;
            return data[top];
        }
        return 0;
    }
    void enlarge(int x){
        int[] t = new int[2 * cap];
        for (int i = 0; i < cap; i++) t[i] = data[i];
        data = t;
        cap *= 2;
        data[top] = x;
        System.out.println("Stack Enlarged");
    }
    public String toString(){
        String str = "( ";
        for (int x : data) str = str + x + " ";
        str = str + ")";
        return str;
    }
}
