--  Prints the total and average leg distance of a mission
with Ada.Text_IO;
use Ada.Text_IO;

procedure Ex02_Mission_Average is
   --  Values in km
   Leg_1_Distance : constant Positive := 125;
   Leg_2_Distance : constant Positive := 240;
   Leg_3_Distance : constant Positive := 98;
   Leg_4_Distance : constant Positive := 311;
   Leg_Count      : constant Positive := 4;
   Total : constant Positive :=
      Leg_1_Distance + Leg_2_Distance + Leg_3_Distance + Leg_4_Distance;
   Average : constant Float := Float (Total) / Float (Leg_Count);
   Rounded : constant Positive := Integer (Average);
   Truncated : constant Positive := Total / Leg_Count;
begin
   Put_Line ("MISSION AVERAGE");
   Put_Line ("Total distance (km):" & Total'Image);
   Put_Line ("Average (km):" & Average'Image);
   Put_Line ("Rounded (km):" & Rounded'Image);
   Put_Line ("Truncated (km):" & Truncated'Image);
end Ex02_Mission_Average;
