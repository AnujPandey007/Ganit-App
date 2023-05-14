import 'dart:math';
import 'package:equations/equations.dart';

class MathService {

  static String solveLinear(String equation){
    double a, b, result;
    String steps = '';

    RegExp exp = RegExp(r'(-?\d+)x\s*([+\-]\s*\d+)\s*=\s*([+-]?\d+)');
    Match match = exp.firstMatch(equation) as Match;

    a = double.parse(match.group(1)!);
    b = double.parse(match.group(2)!.replaceAll(' ', ''));
    result = double.parse(match.group(3)!);

    final solution = Linear(
      a: Complex.fromReal(a),
      b: Complex.fromReal(result-b),
    );

    print("$a, $result and $b");

    for (final root in solution.solutions()) {
      steps+=(root).toString();
    }


    // steps += 'Step 1: The given equation is:\n $equation\n\n';
    //
    // steps += 'Step 2: Move the constant term to the right side:\n';
    // steps += '$a*x = ${result - b}\n\n';
    //
    // steps += 'Step 3: Divide both sides by the coefficient of x:\n';
    // steps += 'x = ${(result - b) / a}\n\n';

    return ('The solution to the equation $equation is:\n\n $steps');
  }


  static String solveQuadratic(String equation) {
    double? a, b, c, delta, root1, root2;
    String result = '';

    // extract the coefficients using regular expressions
    RegExp exp = RegExp(r'(-?\d+)x\^2\s*([+\-]\s*\d+)x\s*([+\-]\s*\d+)\s*=\s*0');
    Match match = exp.firstMatch(equation) as Match;
    a = double.parse(match.group(1)!);
    b = double.parse(match.group(2)!.replaceAll(' ', ''));
    c = double.parse(match.group(3)!.replaceAll(' ', ''));

    // display the qua equation to the user
    result += 'Step 1: The quadratic equation is:\n';
    result += '$a*x^2 + $b*x + $c = 0\n\n';

    // apply the quadratic formula
    delta = b*b- 4 * a* c;

    // display the discriminant to the user
    result += 'Step 2: The discriminant of the quadratic equation is:\n';
    result += 'delta = $b^2 - 4*$a*$c = $delta\n\n';

    if (delta < 0) {
      // no real roots
      result += 'Step 3: The equation has no real roots\n';
    } else if (delta == 0) {
      // one real root
      root1 = -b / (2 * a);
      result += 'Step 3: The equation has one real root:\n';
      result += 'x = -b / 2a = $root1\n';
    } else {
      // two real roots
      root1 = (-b + sqrt(delta)) / (2 * a);
      root2 = (-b - sqrt(delta)) / (2 * a);
      result += 'Step 3: The equation has two real roots:\n';
      result += 'x1 = (-$b + sqrt($delta)) / ${2*a} = $root1\n';
      result += 'x2 = (-$b - sqrt($delta)) / ${2*a} = $root2\n';
    }

    // display the final result to the user
    return (result);
  }

  static String solveIntegration(String function, double x, double y){
    final simpson = SimpsonRule(
      function: function,
      lowerBound: x,
      upperBound: y,
    );

    String result = "$function from $x to $y : ${simpson.integrate().result.toStringAsFixed(3).toString()}";
    return result;
  }


}