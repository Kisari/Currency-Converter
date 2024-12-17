public class Main{
    public static void main(String[] args) {
        int[] input = {3, 7, 1, 2, 6, 4};

        int n = input.length;

        int actually_n = n + 1;

        //becasue ranging from 1 to n. So the sum is
        int sum = actually_n * (actually_n + 1) / 2;

        for (int i = 0; i < n; i++) {
            sum -= input[i];
        }

        System.out.println("Missing number is: " + sum);
    }
}