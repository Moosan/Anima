using UnityEngine;
using FizzBuzz;
namespace FizzBuzzTest
{
    public class Test
    {
        public void Main() {
            Debug.Assert("1" == FizzBuzzClass.Result1(1));
            Debug.Assert("2" == FizzBuzzClass.Result2(2));
            Debug.Assert("Fizz" == FizzBuzzClass.Result3(3));
            Debug.Assert("4" == FizzBuzzClass.Result1(4));
            Debug.Assert("Buzz" == FizzBuzzClass.Result4(5));
            Debug.Assert("Fizz" == FizzBuzzClass.Result5(6));
            Debug.Assert("7" == FizzBuzzClass.Result1(7));
            Debug.Assert("8" == FizzBuzzClass.Result1(8));
            Debug.Assert("Fizz" == FizzBuzzClass.Result1(9));
            Debug.Assert("Buzz" == FizzBuzzClass.Result1(10));
            Debug.Assert("1" == FizzBuzzClass.Result1(11));
            Debug.Assert("2" == FizzBuzzClass.Result1(12));
            Debug.Assert("Fizz" == FizzBuzzClass.Result1(13));
            Debug.Assert("4" == FizzBuzzClass.Result1(14));
            Debug.Assert("FizzBuzz" == FizzBuzzClass.Result1(15));
        }
    }
}