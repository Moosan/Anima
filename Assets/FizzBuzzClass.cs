namespace FizzBuzz
{
    public class FizzBuzzClass
    {
        public static string Result1(int value) {
            return "1";
        }
        public static string Result2(int value)
        {
            return value.ToString();
        }
        public static string Result3(int value)
        {
            if (value == 3) return "Fizz";
            return value.ToString();
        }
        public static string Result4(int value)
        {
            if (value == 3) return "Fizz";
            if (value == 5) return "Buzz";
            return value.ToString();
        }
        public static string Result5(int value)
        {
            if (value % 3 == 0) return "Fizz";
            if (value == 5) return "Buzz";
            return value.ToString();
        }
        public static string Result6(int value)
        {
            if (value % 3 == 0) return "Fizz";
            if (value % 5 == 0) return "Buzz";
            return value.ToString();
        }
        public static string Result7(int value)
        {
            if (value % 15 == 0) return "FizzBuzz";
            if (value % 3 == 0) return "Fizz";
            if (value % 5 == 0) return "Buzz";
            return value.ToString();
        }
    }
}