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
