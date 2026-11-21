# Lesson 02 — Variables and scalar types

**Phase 1 — Fundamentals**

Declare variables, constants and named numbers, work with the predefined scalar
types, and learn why Ada never converts between types behind your back.
The lesson also draws the line between errors caught at compile time and errors
raised at run time.

Course notes (French): [`lecon_02_variables_et_types_scalaires.pdf`](lecon_02_variables_et_types_scalaires.pdf)

## Objectives

- Declare variables, constants and named numbers in the declarative part.
- Explain strong typing and write explicit type conversions.
- Use `Integer`, `Natural`, `Positive` and `Float`, and write their literals.
- Use `Boolean` and `Character` without implicit arithmetic.
- Query types with attributes: `'First`, `'Last`, `'Image`, `'Value`, `'Pos`, `'Val`, `'Succ`, `'Pred`.
- Choose between `/`, `mod` and `rem`, and use `**`.
- Tell a compile-time error from a run-time error.
- Read a GNAT type error and an exception traceback.

## Key points

### Declarations

Declarations go between `is` and `begin`; statements go between `begin` and `end`.
The name comes first, then the type.

```ada
procedure Radar_Setup is
   Range_Km    : Integer := 0;               --  variable
   Max_Range   : constant Integer := 400;    --  typed constant
   Full_Circle : constant := 360;            --  named number
begin
   Range_Km := Max_Range / 2;
end Radar_Setup;
```

| Form | Example |
|---|---|
| Variable | `Count : Integer;` |
| Initialized variable | `Count : Integer := 0;` |
| Several variables | `X, Y : Integer := 0;` (both are initialized) |
| Constant | `Max_Range : constant Integer := 400;` |
| Named number | `Full_Circle : constant := 360;` |

- `:=` assigns, `=` compares. `X = 3;` on its own is not a statement.
- A named number has no type: it stays a *universal* number, like a literal, and
  adapts to the type expected where it is used.
- GNAT reports a variable that is never modified (`could be declared constant`) and
  a variable read before it has a value. Declare everything that never changes as
  `constant`.

### Strong typing and conversions

Ada never converts implicitly between types, not even between two numeric types.
A conversion is written like a function call with the target type's name.

```ada
Result := Ratio * Count;          --  refused: Float * Integer
Result := Ratio * Float (Count);  --  OK
```

| Expression | Value | Note |
|---|---|---|
| `Integer (2.7)` | `3` | Rounds to nearest, unlike C, which truncates |
| `Integer (2.5)` | `3` | Halfway values round away from zero |
| `Integer (-2.5)` | `-3` | |
| `Float (Total) / Float (Count)` | exact quotient | Convert **before** dividing |
| `Float (Total / Count)` | truncated quotient | The integer division already lost the fraction |

A **subtype** adds a constraint to an existing type: `Natural` and `Positive` are
subtypes of `Integer` and mix freely with it. A **distinct type** cannot be mixed
without a conversion: `Ada.Text_IO.Positive_Count` is a subtype of `Count`, an
integer type distinct from `Integer`. That is why `Set_Col` refuses an `Integer`:

```
error: expected type "Ada.Text_Io.Positive_Count"
error: found type "Standard.Integer"
```

When GNAT lists several candidate interpretations, look for the
`expected type` / `found type` pair: it is almost always the real cause.

### Numeric types

| | C | Python | Ada (GNAT) |
|---|---|---|---|
| Integer size | `int`, usually 32 bits | unbounded | `Integer`, 32 bits |
| Integer overflow | undefined behaviour | impossible | `Constraint_Error` |
| Single precision | `float` | — | `Float` |
| Double precision | `double` | `float` | `Long_Float` |

| Literal | Kind | Value |
|---|---|---|
| `1_000_000` | integer | one million |
| `1E6` | integer | 1 000 000 (positive exponent only) |
| `1.0E-3` | real | 0.001 |
| `16#FF#` | integer | 255 |
| `2#1010_0101#` | integer | 165 |

A real literal always has digits on both sides of the point: `0.5`, not `.5`;
`3.0`, not `3.`. The point, not the exponent, decides whether a literal is real.

### Boolean and Character

- `Boolean` has two values, `True` and `False`, and no link with integers:
  `if Count then` is refused, write `if Count /= 0 then`.
- `and` / `or` evaluate both sides; `and then` / `or else` short-circuit, left to right.
  Use `and then` when the right side only makes sense if the left side is true:
  `if Count /= 0 and then Total / Count > 10 then`.
- Mixing `and` and `or` without parentheses is a compilation error.
- `'A'` is a `Character`, `"A"` is a `String`. `Character` is an enumeration of the
  256 Latin-1 characters: `'A' + 1` is refused.

### Attributes

| Attribute | Example | Result |
|---|---|---|
| `'First`, `'Last` | `Integer'Last` | `2147483647` |
| `'Image` | `Count'Image` (Count = 42) | `" 42"` (leading space for the sign) |
| `'Value` | `Integer'Value ("  42 ")` | `42` (leading and trailing spaces ignored) |
| `'Pos` | `Character'Pos ('A')` | `65` |
| `'Val` | `Character'Val (66)` | `'B'` |
| `'Succ`, `'Pred` | `Character'Succ ('A')` | `'B'` |

- `'Image` of a non-negative number starts with a space; `'Image` of a negative
  number, a `Boolean` or an enumeration does not.
- `Character'Image ('Z')` is `"'Z'"`, with the quotes. To print a character, concatenate
  it directly: `Put_Line ("Mode: " & Mode);`.
- `Float'Image` uses scientific notation: `2.5` gives `" 2.50000E+00"`.
- `Integer'Value ("12x")` raises `Constraint_Error`, where C's `atoi` silently returns `12`.
- In the function form `Natural'Image (X)`, the parameter is of the base type:
  it documents an intent but checks nothing. Only an object of subtype `Natural` is checked.

### Arithmetic operators

| Operator | Meaning | Note |
|---|---|---|
| `/` on integers | division truncated toward zero | `-7 / 2 = -3` (Python's `//` gives `-4`) |
| `rem` | remainder, sign of the dividend | C's `%`: `-7 rem 3 = -1` |
| `mod` | modulo, sign of the divisor | Python's `%`: `-7 mod 3 = 2` |
| `**` | power | integer base: exponent must be `Natural`; real base: integer exponent |
| `abs` | absolute value | |

There is no `++` and no `+=`. Ada 2022 adds the target name `@`:
`Count := @ + 1;`. To bring a value back into a cyclic range (heading, angle, hour),
use `mod`: `(Heading + Turn) mod 360` always lies in `0 .. 359`.

### Compile time or run time?

The language rule: a value that does not fit its type raises `Constraint_Error`
**at run time**. GNAT may also predict it at compile time when every value is known,
and then reports a warning, which stops the build in this repository. A value read
from a file, a sensor or the keyboard is never known at compile time.

```
raised CONSTRAINT_ERROR : bad input for 'Value: "  42x"
0x... System.Val_Util.Bad_Value at s-valuti.adb:52
0x... Ex04_Sensor_Check at ex04_sensor_check.adb:8
```

Read the first line to know **what** happened, then the first line that names one of
your files to know **where**.

## Exercises

Each exercise is a separate main program declared in `lesson_02.gpr`.
Run one with `bin/<name>.exe` (Windows) or `bin/<name>` (Linux).

| # | File | Topic |
|---|---|---|
| 0 | [`../lesson_01/src/ex04_target_report.adb`](../lesson_01/src/ex04_target_report.adb) | Replacing a magic number with a typed constant |
| 1 | [`src/ex01_type_limits.adb`](src/ex01_type_limits.adb) | `'First`, `'Last`, `'Image`, `'Pos` |
| 2 | [`src/ex02_mission_average.adb`](src/ex02_mission_average.adb) | Conversions, rounding and truncation |
| 3 | [`src/ex03_radar_heading.adb`](src/ex03_radar_heading.adb) | `mod`, `rem` and named numbers |
| 4 | [`src/ex04_sensor_check.adb`](src/ex04_sensor_check.adb) | `'Value`, `Character`, `Boolean` |

### Exercise 0 — Warm-up: no magic number

In exercise 4 of lesson 1, the column `15` appears four times. Replace it with one
named constant of the right type, without changing the output.

### Exercise 1 — Scalar type limits

Print exactly the following. Every limit comes from an attribute, the codes of the
first and last characters are printed instead of the characters, and the column
positions (1, 13, 27) are named constants.

```
SCALAR TYPE LIMITS

Type        First         Last
Integer     -2147483648    2147483647
Natural      0             2147483647
Positive     1             2147483647
Boolean     FALSE         TRUE
Character    0             255
```

### Exercise 2 — Mission average

A drone flies four legs of 125, 240, 98 and 311 km. Print exactly the following.
`Rounded` is obtained by converting the average, `Truncated` by integer division,
and every declaration that never changes is a constant.

```
MISSION AVERAGE
Total distance (km): 774
Average (km): 1.93500E+02
Rounded (km): 194
Truncated (km): 193
```

### Exercise 3 — Radar heading

A radar starts at heading 10°. Three independent turns are tested from that start:
-30, 400 and -725. For each one, print the new heading computed with `mod 360` and
with `rem 360`. The value 360 is a named number, and the columns start at 11 and 21.

```
RADAR HEADING
Start heading: 10
Turn      mod       rem
-30        340      -20
 400       50        50
-725       5        -355
```

### Exercise 4 — Sensor check

Sensors are named by letters starting from `'A'`. Sensor `'C'` sends its reading as
the text `"  42 "`. A reading is valid between 0 and 100, and the alarm goes off when
it is out of range or above 80. Print exactly the following, with the reading obtained
by `'Value` and the sensor number and next sensor computed with attributes.

```
SENSOR CHECK
Sensor: C
Sensor number: 3
Next sensor: D
Reading: 42
In range: TRUE
Alarm: FALSE
```

Then replace the text with `"42x"`, rebuild and run: the build succeeds and the
program stops with `Constraint_Error`.

## Solutions

Try each exercise before reading this section.

<details>
<summary>Exercise 0 — No magic number</summary>

`Set_Col` expects a `Positive_Count`, so a constant of type `Integer` is refused.
Declare the constant with the type the procedure expects:

```ada
   Status_Column : constant Positive_Count := 15;
```

A named number (`Status_Column : constant := 15;`) also compiles, but the typed
constant says what the value is: a column position.

</details>

<details>
<summary>Exercise 1 — Scalar type limits</summary>

```ada
--  Prints the first and last values of the predefined scalar types
with Ada.Text_IO;
use Ada.Text_IO;

procedure Ex01_Type_Limits is
   First_Column : constant Positive_Count := 13;
   Last_Column  : constant Positive_Count := 27;
begin
   Put_Line ("SCALAR TYPE LIMITS");
   New_Line;

   Put ("Type");
   Set_Col (First_Column);
   Put ("First");
   Set_Col (Last_Column);
   Put_Line ("Last");

   Put ("Integer");
   Set_Col (First_Column);
   Put (Integer'First'Image);
   Set_Col (Last_Column);
   Put_Line (Integer'Last'Image);

   Put ("Natural");
   Set_Col (First_Column);
   Put (Natural'First'Image);
   Set_Col (Last_Column);
   Put_Line (Natural'Last'Image);

   Put ("Positive");
   Set_Col (First_Column);
   Put (Positive'First'Image);
   Set_Col (Last_Column);
   Put_Line (Positive'Last'Image);

   Put ("Boolean");
   Set_Col (First_Column);
   Put (Boolean'First'Image);
   Set_Col (Last_Column);
   Put_Line (Boolean'Last'Image);

   Put ("Character");
   Set_Col (First_Column);
   Put (Character'Pos (Character'First)'Image);
   Set_Col (Last_Column);
   Put_Line (Character'Pos (Character'Last)'Image);
end Ex01_Type_Limits;
```

Each line starts in column 1, so no `Set_Col` is needed for the first column.
`0` and `1` are shifted one character to the right because `'Image` reserves a
space for the sign of a number; `FALSE` is an enumeration literal and has no sign.

</details>

<details>
<summary>Exercise 2 — Mission average</summary>

```ada
--  Prints the total and average leg distance of a mission
with Ada.Text_IO;
use Ada.Text_IO;

procedure Ex02_Mission_Average is
   Leg_Count : constant Positive := 4;
   Leg_1_Km  : constant Positive := 125;
   Leg_2_Km  : constant Positive := 240;
   Leg_3_Km  : constant Positive := 98;
   Leg_4_Km  : constant Positive := 311;
   Total_Km  : constant Positive :=
     Leg_1_Km + Leg_2_Km + Leg_3_Km + Leg_4_Km;
   Average   : constant Float    := Float (Total_Km) / Float (Leg_Count);
   Rounded   : constant Positive := Positive (Average);
   Truncated : constant Positive := Total_Km / Leg_Count;
begin
   Put_Line ("MISSION AVERAGE");
   Put_Line ("Total distance (km):" & Total_Km'Image);
   Put_Line ("Average (km):" & Average'Image);
   Put_Line ("Rounded (km):" & Rounded'Image);
   Put_Line ("Truncated (km):" & Truncated'Image);
end Ex02_Mission_Average;
```

`Total_Km / Leg_Count` cannot initialize a `Float`: it is an integer division.
`Float (Total_Km / Leg_Count)` compiles but gives `193.0`, because the fraction is
lost before the conversion. 193.5 rounds to 194; with a last leg of 310 km, the
average would be 193.25 and both results would be 193.

</details>

<details>
<summary>Exercise 3 — Radar heading</summary>

```ada
--  Prints the radar heading after each turn, normalized with mod and rem
with Ada.Text_IO;
use Ada.Text_IO;

procedure Ex03_Radar_Heading is
   Full_Circle   : constant         := 360;
   Start_Heading : constant Natural := 10;
   Turn_1        : constant Integer := -30;
   Turn_2        : constant Integer := 400;
   Turn_3        : constant Integer := -725;

   Mod_Column : constant Positive_Count := 11;
   Rem_Column : constant Positive_Count := 21;
begin
   Put_Line ("RADAR HEADING");
   Put_Line ("Start heading:" & Start_Heading'Image);

   Put ("Turn");
   Set_Col (Mod_Column);
   Put ("mod");
   Set_Col (Rem_Column);
   Put_Line ("rem");

   --  rem keeps the sign of the dividend: negative headings are invalid
   Put (Turn_1'Image);
   Set_Col (Mod_Column);
   Put (Natural'Image ((Start_Heading + Turn_1) mod Full_Circle));
   Set_Col (Rem_Column);
   Put_Line (Integer'Image ((Start_Heading + Turn_1) rem Full_Circle));

   Put (Turn_2'Image);
   Set_Col (Mod_Column);
   Put (Natural'Image ((Start_Heading + Turn_2) mod Full_Circle));
   Set_Col (Rem_Column);
   Put_Line (Integer'Image ((Start_Heading + Turn_2) rem Full_Circle));

   Put (Turn_3'Image);
   Set_Col (Mod_Column);
   Put (Natural'Image ((Start_Heading + Turn_3) mod Full_Circle));
   Set_Col (Rem_Column);
   Put_Line (Integer'Image ((Start_Heading + Turn_3) rem Full_Circle));
end Ex03_Radar_Heading;
```

`Natural + Integer` needs no conversion: `Natural` is a subtype of `Integer`.
With a positive divisor, `mod` always returns a value in `0 .. 359`, a valid heading.
Storing a negative `rem` result in a `Natural` raises `Constraint_Error` at run time;
here GNAT would predict it at compile time because every value is static.

</details>

<details>
<summary>Exercise 4 — Sensor check</summary>

```ada
--  Checks a sensor reading against its valid range and alarm threshold
with Ada.Text_IO;
use Ada.Text_IO;

procedure Ex04_Sensor_Check is
   First_Sensor    : constant Character := 'A';
   Current_Sensor  : constant Character := 'C';
   Next_Sensor     : constant Character := Character'Succ (Current_Sensor);
   Sensor_Number   : constant Positive  :=
     Character'Pos (Current_Sensor) - Character'Pos (First_Sensor) + 1;

   Raw_Reading     : constant String    := "  42 ";
   Reading         : constant Integer   := Integer'Value (Raw_Reading);
   Min_Reading     : constant Natural   := 0;
   Max_Reading     : constant Positive  := 100;
   Alarm_Threshold : constant Positive  := 80;

   In_Range        : constant Boolean   :=
     Reading >= Min_Reading and then Reading <= Max_Reading;
   Alarm           : constant Boolean   :=
     not In_Range or else Reading > Alarm_Threshold;
begin
   Put_Line ("SENSOR CHECK");
   Put_Line ("Sensor: " & Current_Sensor);
   Put_Line ("Sensor number:" & Sensor_Number'Image);
   Put_Line ("Next sensor: " & Next_Sensor);
   Put_Line ("Reading:" & Reading'Image);
   Put_Line ("In range: " & In_Range'Image);
   Put_Line ("Alarm: " & Alarm'Image);
end Ex04_Sensor_Check;
```

Two traps hide in the expected output: `Character'Image` adds quotes, so the
character is concatenated directly; `Boolean'Image` has no leading space, so the
label ends with one. `Alarm` reuses `In_Range` instead of repeating the bounds:
with a threshold above 100, a hand-written test would miss out-of-range readings.

With `"42x"`, `'Value` is not evaluated at compile time: the build succeeds and the
program stops at run time on line 8 with `Constraint_Error`.

</details>
