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

    steps += 'Step 1: The given equation is:\n $equation\n\n';

    steps += 'Step 2: Move the constant term to the right side:\n';
    steps += '$a*x = ${result - b}\n\n';

    steps += 'Step 3: Divide both sides by the coefficient of x:\n';
    steps += 'x = ${(result - b) / a}\n\n';

    return ('The solution to the equation $equation is:\n\n $steps');
  }


  static String solveQuadratic(String equation) {
    double a, b, c;
    String steps = '';

    RegExp exp = RegExp(r'(-?\d*)x\^2\s*([+\-]\s*\d*)x\s*([+\-]\s*\d*)\s*=\s*([+-]?\d+)');
    Match? match = exp.firstMatch(equation);

    if (match != null) {
      String coefficientA = match.group(1) ?? '1';
      String coefficientB = match.group(2) ?? '0';
      String coefficientC = match.group(3) ?? '0';

      a = double.tryParse(coefficientA.replaceAll(' ', '')) ?? 1;
      b = double.tryParse(coefficientB.replaceAll(' ', '')) ?? 0;
      c = double.tryParse(coefficientC.replaceAll(' ', '')) ?? 0;

      if (a == 0) {
        return 'The given equation is not quadratic.';
      }

      steps += 'Step 1: The given equation is:\n $equation\n\n';
      steps += 'Step 2: Move all terms to the left side:\n';
      steps += '${a}x^2 + ${b}x + ${c} = 0\n\n';

      double discriminant = b * b - 4 * a * c;
      if (discriminant > 0) {
        double root1 = (-b + sqrt(discriminant)) / (2 * a);
        double root2 = (-b - sqrt(discriminant)) / (2 * a);
        steps += 'Step 3: The quadratic equation has two real roots:\n';
        steps += 'x1 = ${root1.toString().substring(0,5)}\n';
        steps += 'x2 = ${root2.toString().substring(0,5)}\n\n';
      } else if (discriminant == 0) {
        double root = -b / (2 * a);
        steps += 'Step 3: The quadratic equation has a repeated real root:\n';
        steps += 'x = ${root.toString().substring(0,5)}\n\n';
      } else {
        double realPart = -b / (2 * a);
        double imaginaryPart = sqrt(-discriminant) / (2 * a);
        steps += 'Step 3: The quadratic equation has two complex roots:\n';
        steps += 'x1 = $realPart + ${imaginaryPart}i\n';
        steps += 'x2 = $realPart - ${imaginaryPart}i\n\n';
      }

      return 'The solution to the equation $equation is:\n\n $steps';
    } else {
      return 'Invalid quadratic equation.';
    }
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