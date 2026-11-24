# Lesson 03 — Defining your own types

**Phase 1 — Fundamentals**

Stop using `Integer` and `Float` for everything: declare one type per physical quantity,
restrict values with subtypes, and pick the right kind of type for each piece of data:
integer range, enumeration, modular, floating point or fixed point.
The compiler then refuses to mix units, and every out-of-range value raises
`Constraint_Error` at the exact place where it appears.

Course notes (French): [`lecon_03_creer_ses_propres_types.pdf`](lecon_03_creer_ses_propres_types.pdf)

## Objectives

- Declare integer types with `type ... is range` and explain why they cannot be mixed.
- Restrict an existing type with a `subtype`, and choose between a new type and a subtype.
- Declare enumerations and use their attributes: `'Pos`, `'Val`, `'Succ`, `'Pred`, `'Image`, `'Value`.
- Use modular types for cyclic values, and `'Mod` to convert into them.
- Declare floating-point types with `digits` and fixed-point types with `delta`.
- Explain what `'Small` is and why a fixed-point value can be inexact.
- Predict whether an out-of-range value is reported at compile time or raised at run time.

## Key points

### A new integer type

```ada
type Altitude_Ft is range 0 .. 60_000;
type Distance_Nm is range 0 .. 500;
```

Each declaration creates a **new type**, distinct from `Integer` and from every other type.
A C `typedef` only creates an alias; Python has no equivalent.

| Statement | Result |
|---|---|
| `Alt := Alt + 1_000;` | OK: a literal adapts to the expected type |
| `Alt := Alt + Dist;` | Compilation error: two different types |
| `Alt := Count;` (`Count : Integer`) | Compilation error: two different types |
| `Alt := Altitude_Ft (Count) * 2;` | OK: explicit conversion, range checked |
| `Dist := 600;` | Warning (value known), `Constraint_Error` at run time |

Mixing two types is a real error, refused by every Ada compiler:

```
error: invalid operand types for operator "+"
error: left operand has type "Cruise_Ft" defined at line 7
error: right operand has type "Speed_Kt" defined at line 9
```

GNAT names the **declared subtype** of each operand (`Cruise_Ft`); the type that
matters is its parent, `Altitude_Ft`.

### Subtypes

```ada
subtype Cruise_Ft is Altitude_Ft range 20_000 .. 45_000;
```

A subtype keeps the same type and adds a constraint.

| | New `type` | `subtype` |
|---|---|---|
| Mixing with the parent type | Refused at compile time | Allowed, no conversion |
| Range check | On assignment | On assignment |
| Use it for | A different quantity or unit | The same quantity, restricted |

`Natural` and `Positive` are subtypes of `Integer`, declared in package `Standard`:

```ada
subtype Natural  is Integer range 0 .. Integer'Last;
subtype Positive is Integer range 1 .. Integer'Last;
```

A heading and a speed are two types; a battery level and a critical battery level
are a type and a subtype.

### Enumerations

```ada
type Track_Status is (Tentative, Confirmed, Coasting, Lost);
subtype Active_Status is Track_Status range Tentative .. Coasting;
```

Values are ordered by declaration (`Tentative < Lost` is `True`) and have no link with
integers. A C `enum` is an `int`: `dir = dir + 1` compiles and can produce a value that
matches no constant.

| Attribute | Example | Result |
|---|---|---|
| `'First`, `'Last` | `Track_Status'Last` | `Lost` |
| `'Pos` | `Track_Status'Pos (Confirmed)` | `1` (ranks start at 0) |
| `'Val` | `Track_Status'Val (0)` | `Tentative` |
| `'Succ`, `'Pred` | `Track_Status'Succ (Tentative)` | `Confirmed` |
| `'Image` | `Track_Status'Image (Coasting)` | `"COASTING"` (upper case) |
| `'Value` | `Track_Status'Value ("lost")` | `Lost` (case ignored) |

- `Track_Status'Succ (Lost)` raises `Constraint_Error`: there is no wrap-around.
- The number of values is `Track_Status'Pos (Track_Status'Last) + 1`. GNAT also offers
  `'Range_Length`, but it is not standard Ada.
- `Boolean` and `Character` are predefined enumerations: `type Boolean is (False, True);`.
- To put a double quote inside a string, double it: `"Operator input ""coasting"""`.

### Modular types

```ada
type Heading_Deg is mod 360;   --  0 .. 359
```

Arithmetic wraps around and never raises an exception:

| Expression | Result |
|---|---|
| `Heading_Deg (350) + 20` | `10` |
| `Heading_Deg (5) - 10` | `355` |
| `Heading_Deg (Raw)` with `Raw = 725` | `Constraint_Error`: a conversion checks the range |
| `Heading_Deg'Mod (Raw)` with `Raw = 725` | `5`: `'Mod` applies the modulus |

- Any modulus is allowed, not only powers of two as with C's `unsigned` types.
- Modular types support `and`, `or`, `xor` and `not` on bits. `Interfaces.Unsigned_8`,
  `Unsigned_16`, etc. are modular types.
- Wrapping hides errors. Use `mod` only when wrapping has a physical meaning (angle,
  odometer, bit pattern). A quantity such as a number of missiles needs a `range`:
  with `mod 9`, firing with 0 missiles left would give 8, a full launcher.

### Floating-point and fixed-point types

```ada
type Altitude_M    is digits 6 range -500.0 .. 20_000.0;
type Voltage       is delta 0.01 range 0.0 .. 5.0;
type Exact_Voltage is delta 0.01 range 0.0 .. 5.0
  with Small => 0.01;
```

| | `digits` (floating point) | `delta` (fixed point) |
|---|---|---|
| You specify | Significant digits | Maximum absolute error |
| Error | Relative | Absolute, the same everywhere |
| Representation | Hardware float | Scaled integer |
| Typical use | Wide ranges, scientific computing | Sensors, ADCs, CPUs without an FPU |

- With `digits`, you state what you need and the compiler picks `float` or `double`.
- Never compare two floats with `=`: compare `abs (A - B)` with a tolerance.
- A fixed-point value is a multiple of `'Small`. Without a `Small` clause, `'Small` is the
  **largest power of two** not greater than `delta`: 1/128 for `delta 0.01`, 1/16 for `delta 0.1`.
- `Voltage'Value ("1.1")` is stored as 141/128 = 1.1015625; times 4 it gives 4.40625,
  printed as `4.41`. With `Small => 0.01`, 1.1 is exactly 110 × 0.01 and the result is `4.40`.
- `'Image` of a fixed-point value prints as many decimals as `delta` needs, which can hide
  the stored error.
- A fixed-point value can be multiplied or divided by an `Integer` without conversion:
  `Cell_V * Cell_Count`. An integer type such as `Speed_Kt` has no such operator.

### Compile time or run time?

The language guarantees one thing: a value outside its subtype raises `Constraint_Error`
**at run time**. GNAT may also report it at compile time, as a warning, when it can
deduce the value: literals, constants, and even variables in straight-line code.

```
ex05_missile_counter.adb:23:43: warning: value not in range of type "Missile_Count" defined at line 6
ex05_missile_counter.adb:23:43: warning: Constraint_Error will be raised at run time
```

This warning is enabled by default; `compile_checks = "Errors"` turns it into a build
failure. A value read with `'Value`, from a sensor, a file or the keyboard, is never known.

```
raised CONSTRAINT_ERROR : ex05_missile_counter.adb:23 range check failed
```

`Remaining - 1` computes `-1` without trouble: arithmetic is done in the **base type**
(`Missile_Count'Base`), which is wider than `0 .. 8`. The range check fails when the
result is stored, hence *range check*, not *overflow check*.

### Choosing a type

| The data is… | Declare |
|---|---|
| A quantity with a unit | `type ... is range` or `digits` |
| The same quantity, restricted | `subtype ... is ... range` |
| A finite list of states | An enumeration |
| Cyclic (angle, counter, bits) | `type ... is mod` |
| Decimal, or for a CPU without an FPU | `type ... is delta ...` (with `Small` if decimal) |

## Exercises

Each exercise is a separate main program declared in `lesson_03.gpr`.
Run one with `bin/<name>.exe` (Windows) or `bin/<name>` (Linux).

| # | File | Topic |
|---|---|---|
| 1 | [`src/ex01_flight_limits.adb`](src/ex01_flight_limits.adb) | `range` types and subtypes |
| 2 | [`src/ex02_track_status.adb`](src/ex02_track_status.adb) | Enumerations and their attributes |
| 3 | [`src/ex03_radar_heading.adb`](src/ex03_radar_heading.adb) | Modular types and `'Mod` |
| 4 | [`src/ex04_sensor_types.adb`](src/ex04_sensor_types.adb) | `digits`, `delta` and `'Small` |
| 5 | [`src/ex05_missile_counter.adb`](src/ex05_missile_counter.adb) | `Constraint_Error` at run time |

### Exercise 1 — Flight limits

Declare an altitude type from 0 to 60 000 ft, a speed type from 0 to 900 kt, and a
cruise subtype of the altitude type from 20 000 to 45 000 ft. A cruise starts at
35 000 ft and climbs by 1 500 ft. Print exactly the following, with every limit taken
from an attribute and every value that never changes declared as a constant.

```
FLIGHT LIMITS
Altitude (ft):  0 .. 60000
Cruise (ft):  20000 .. 45000
Speed (kt):  0 .. 900
Climb: 35000 -> 36500
```

Then add a line that adds an altitude and a speed, build, read the error and remove the line.

### Exercise 2 — Track status

Declare the enumeration `Track_Status` (`Tentative`, `Confirmed`, `Coasting`, `Lost`), the
subtype `Active_Status` from `Tentative` to `Coasting`, and a simulated operator input
`"coasting"`. Print exactly the following; `4`, `3` and `COASTING` are computed with attributes.

```
TRACK STATUS
Values: TENTATIVE .. LOST
Count: 4
Active: TENTATIVE .. COASTING
After CONFIRMED comes COASTING
Rank of LOST: 3
Operator input "coasting" -> COASTING
```

### Exercise 3 — Radar heading, modular version

Redo exercise 3 of lesson 2 with `type Heading_Deg is mod 360`: start heading 10°, three
independent turns of -30, 400 and -725 (`Integer` values). No `mod` or `rem` operator
may appear in the code.

```
RADAR HEADING
Start heading: 10
Turn -30  -> 340
Turn  400 -> 50
Turn -725 -> 5
```

### Exercise 4 — Sensor types

Declare `Altitude_M` (6 digits, -500.0 to 20 000.0 m), `Voltage` (`delta 0.01`, 0.0 to 5.0 V)
and `Exact_Voltage` (the same with `Small => 0.01`). Convert a 35 000 ft cruise altitude
(`Integer`) to metres (1 ft = 0.3048 m). Read one battery cell from the string `"1.1"`
into each voltage type, and compute the voltage of a pack of 4 cells in series in each type.

```
SENSOR TYPES
Altitude (m): -5.00000E+02 ..  2.00000E+04
Altitude digits:  6
Cruise altitude (m):  1.06680E+04
Voltage small:  7.81250000000000000E-03
Exact voltage small:  1.00000000000000000E-02
Pack voltage:  4.41
Exact pack voltage:  4.40
```

Explain by hand why the two pack voltages differ.

### Exercise 5 — Missile counter

Declare `Missile_Count` from 0 to 8. The number of loaded missiles comes from the
simulated input `"2"`, read with `'Value`. Fire three times: each shot subtracts 1 and
prints the remaining count. The program prints the following, then stops on
`Constraint_Error` at the third shot.

```
LAUNCHER
Loaded: 2
Fired, remaining: 1
Fired, remaining: 0
```

Then replace `'Value` with the literal `2`, predict what the build will report, and check.

## Solutions

Try each exercise before reading this section.

<details>
<summary>Exercise 1 — Flight limits</summary>

```ada
--  Prints the flight envelope limits and a climb within the cruise band
with Ada.Text_IO;
use Ada.Text_IO;

procedure Ex01_Flight_Limits is
   type Altitude_Ft is range 0 .. 60_000;
   subtype Cruise_Ft is Altitude_Ft range 20_000 .. 45_000;

   type Speed_Kt is range 0 .. 900;

   Cruise_Start   : constant Cruise_Ft := 35_000;
   Climb          : constant           := 1_500;
   Climbed_Cruise : constant Cruise_Ft := Cruise_Start + Climb;
begin
   Put_Line ("FLIGHT LIMITS");

   Put_Line ("Altitude (ft): " & Altitude_Ft'First'Image
     & " .." & Altitude_Ft'Last'Image);

   Put_Line ("Cruise (ft): " & Cruise_Ft'First'Image
     & " .." & Cruise_Ft'Last'Image);

   Put_Line ("Speed (kt): " & Speed_Kt'First'Image
     & " .." & Speed_Kt'Last'Image);

   Put_Line ("Climb:" & Cruise_Start'Image & " ->" & Climbed_Cruise'Image);
end Ex01_Flight_Limits;
```

`Climbed_Cruise` is declared with the subtype `Cruise_Ft`: a climb above 45 000 ft
would be reported at compile time, because every value is static.
`Climb` is a named number and adapts to `Altitude_Ft` in the addition.

</details>

<details>
<summary>Exercise 2 — Track status</summary>

```ada
--  Prints the radar track states and their enumeration attributes
with Ada.Text_IO;
use Ada.Text_IO;

procedure Ex02_Track_Status is
   type Track_Status is (Tentative, Confirmed, Coasting, Lost);
   subtype Active_Status is Track_Status range Tentative .. Coasting;

   Last_Rank        : constant Natural  :=
     Track_Status'Pos (Track_Status'Last);
   Number_Of_Values : constant Positive := Last_Rank + 1;

   Reference_Status : constant Track_Status := Confirmed;

   Operator_Input : constant String := "coasting";
begin
   Put_Line ("TRACK STATUS");

   Put_Line ("Values: " & Track_Status'First'Image
     & " .. " & Track_Status'Last'Image);

   Put_Line ("Count:" & Number_Of_Values'Image);

   Put_Line ("Active: " & Active_Status'First'Image
     & " .. " & Active_Status'Last'Image);

   Put_Line ("After " & Reference_Status'Image
     & " comes " & Track_Status'Succ (Reference_Status)'Image);

   Put_Line ("Rank of " & Track_Status'Last'Image & ":"
     & Last_Rank'Image);

   Put_Line ("Operator input """ & Operator_Input & """ -> "
     & Track_Status'Value (Operator_Input)'Image);
end Ex02_Track_Status;
```

`'Value` is not a static expression, so its check happens at run time: an input
such as `"landed"` raises `Constraint_Error`.

</details>

<details>
<summary>Exercise 3 — Radar heading, modular version</summary>

```ada
--  Prints the radar heading after each turn, using a modular heading type
with Ada.Text_IO;
use Ada.Text_IO;

procedure Ex03_Radar_Heading is
   type Heading_Deg is mod 360;

   Start_Heading : constant Heading_Deg := 10;

   Turn_1 : constant Integer := -30;
   Turn_2 : constant Integer := 400;
   Turn_3 : constant Integer := -725;

   Turn_Column    : constant Positive_Count := 6;
   Arrow_Column   : constant Positive_Count := 11;
   Heading_Column : constant Positive_Count := 13;

   New_Heading_1 : constant Heading_Deg :=
     Start_Heading + Heading_Deg'Mod (Turn_1);
   New_Heading_2 : constant Heading_Deg :=
     Start_Heading + Heading_Deg'Mod (Turn_2);
   New_Heading_3 : constant Heading_Deg :=
     Start_Heading + Heading_Deg'Mod (Turn_3);
begin
   Put_Line ("RADAR HEADING");
   Put_Line ("Start heading:" & Start_Heading'Image);

   Put ("Turn");
   Set_Col (Turn_Column);
   Put (Turn_1'Image);
   Set_Col (Arrow_Column);
   Put ("->");
   Set_Col (Heading_Column);
   Put_Line (New_Heading_1'Image);

   Put ("Turn");
   Set_Col (Turn_Column);
   Put (Turn_2'Image);
   Set_Col (Arrow_Column);
   Put ("->");
   Set_Col (Heading_Column);
   Put_Line (New_Heading_2'Image);

   Put ("Turn");
   Set_Col (Turn_Column);
   Put (Turn_3'Image);
   Set_Col (Arrow_Column);
   Put ("->");
   Set_Col (Heading_Column);
   Put_Line (New_Heading_3'Image);
end Ex03_Radar_Heading;
```

`Heading_Deg (Turn_1)` would raise `Constraint_Error`: -30 is not in `0 .. 359`.
`'Mod` applies the modulus, then the addition wraps on its own.
A value of type `Heading_Deg` is always a valid heading, so nothing needs to be
"normalized" any more. The repeated block will become a loop in lesson 4.

</details>

<details>
<summary>Exercise 4 — Sensor types</summary>

```ada
--  Compares floating-point and fixed-point types for sensor values
with Ada.Text_IO;
use Ada.Text_IO;

procedure Ex04_Sensor_Types is
   type Altitude_M is digits 6 range -500.0 .. 20_000.0;

   type Voltage       is delta 0.01 range 0.0 .. 5.0;
   type Exact_Voltage is delta 0.01 range 0.0 .. 5.0
     with Small => 0.01;

   Feet_To_Meters : constant := 0.3048;
   Cell_Count     : constant := 4;

   Cruise_Altitude_Ft : constant Integer    := 35_000;
   Cruise_Altitude_M  : constant Altitude_M :=
     Altitude_M (Float (Cruise_Altitude_Ft) * Feet_To_Meters);

   Cell_Reading : constant String := "1.1";

   Cell_V : constant Voltage := Voltage'Value (Cell_Reading);
   Pack_V : constant Voltage := Cell_V * Cell_Count;

   Exact_Cell_V : constant Exact_Voltage :=
     Exact_Voltage'Value (Cell_Reading);
   Exact_Pack_V : constant Exact_Voltage := Exact_Cell_V * Cell_Count;
begin
   Put_Line ("SENSOR TYPES");

   Put_Line ("Altitude (m): " & Altitude_M'First'Image
     & " .. " & Altitude_M'Last'Image);

   Put_Line ("Altitude digits: " & Altitude_M'Digits'Image);

   Put_Line ("Cruise altitude (m): " & Cruise_Altitude_M'Image);

   Put_Line ("Voltage small: " & Voltage'Small'Image);

   Put_Line ("Exact voltage small: " & Exact_Voltage'Small'Image);

   Put_Line ("Pack voltage: " & Pack_V'Image);

   Put_Line ("Exact pack voltage: " & Exact_Pack_V'Image);
end Ex04_Sensor_Types;
```

1.1 × 128 = 140.8, so `Voltage` stores 141/128 = 1.1015625. Four cells give 4.40625,
printed with two decimals as `4.41`. `Exact_Voltage` is not more precise (0.01 is
coarser than 1/128), but 1.1 is an exact multiple of 0.01, so no rounding occurs.
Each computation starts from the string in its own type: converting `Cell_V` to
`Exact_Voltage` would carry the error over.

</details>

<details>
<summary>Exercise 5 — Missile counter</summary>

```ada
--  Fires missiles until the launcher counter raises Constraint_Error
with Ada.Text_IO;
use Ada.Text_IO;

procedure Ex05_Missile_Counter is
   type Missile_Count is range 0 .. 8;

   Loaded_Input : constant String := "2";

   Remaining_Missiles : Missile_Count :=
     Missile_Count'Value (Loaded_Input);
begin
   Put_Line ("LAUNCHER");
   Put_Line ("Loaded:" & Remaining_Missiles'Image);

   Remaining_Missiles := Remaining_Missiles - 1;
   Put_Line ("Fired, remaining:" & Remaining_Missiles'Image);

   Remaining_Missiles := Remaining_Missiles - 1;
   Put_Line ("Fired, remaining:" & Remaining_Missiles'Image);

   Remaining_Missiles := Remaining_Missiles - 1;
   Put_Line ("Fired, remaining:" & Remaining_Missiles'Image);
end Ex05_Missile_Counter;
```

```
raised CONSTRAINT_ERROR : ex05_missile_counter.adb:22 range check failed
```

`'Value` hides the initial value from the compiler, so the build is silent and the
third shot fails at run time. With the literal `2`, GNAT follows the variable through
the straight-line code and reports `Constraint_Error will be raised at run time`;
the warning stops the build. This is the first variable of the course: its value
really changes during execution.

</details>