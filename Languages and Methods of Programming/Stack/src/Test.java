public class Test {
    public static void main(String[] args){
        Stack s = new Stack();
        System.out.println(s.empty() ? "Stack is empty" : "Stack is not empty");
        for (int i = 1; i < 12; i++){
            s.push(i);
            System.out.println("Pushed " + i + " into stack");
        }
        System.out.println("Stack after 11 pushes:" + s);
        System.out.println(s.empty() ? "Stack is empty" : "Stack is not empty");
        for (int i = 12; i > 1; i--){
            System.out.println("Popped " + s.pop() + " from stack");
        }
        System.out.println(s.empty() ? "Stack is empty" : "Stack is not empty");
        int error = s.pop();
    }
}