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
   Average   : constant Float    :=
      Float (Total_Km) / Float (Leg_Count);
   Rounded   : constant Positive := Integer (Average);
   Truncated : constant Positive := Total_Km / Leg_Count;
begin
   Put_Line ("MISSION AVERAGE");
   Put_Line ("Total distance (km):" & Total_Km'Image);
   Put_Line ("Average (km):" & Average'Image);
   Put_Line ("Rounded (km):" & Rounded'Image);
   Put_Line ("Truncated (km):" & Truncated'Image);
end Ex02_Mission_Average;
